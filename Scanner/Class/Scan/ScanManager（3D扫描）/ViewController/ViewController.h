/*
  This file is part of the Structure SDK.
  Copyright © 2019 rrd, Inc. All rights reserved.
  http://structure.io
*/

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <Structure/Structure.h>
#import <Structure/STCaptureSession.h>

#import "CalibrationOverlay.h"
#import "MeshViewController.h"
#import "SettingsPopupView.h"
// See default initialization in: -(void)initializeDynamicOptions
struct DynamicOptions
{
    bool depthAndColorTrackerIsOn;
    bool improvedTrackingIsOn;
    bool highResColoring;
    bool improvedMapperIsOn;
    bool highResMapping;
    STCaptureSessionPreset depthStreamPreset;
};

struct Options
{
    // The initial scanning volume size will be 0.5 x 0.5 x 0.5 meters
    // (X is left-right, Y is up-down, Z is forward-back)
    const GLKVector3 initVolumeSizeInMeters = GLKVector3Make (0.5f, 0.5f, 0.5f);
    
    // The maximum number of keyframes saved in keyFrameManager
    int maxNumKeyFrames = 48;
    
    // Colorizer quality
    STColorizerQuality colorizerQuality = STColorizerHighQuality;
    
    // Take a new keyframe in the rotation difference is higher than 20 degrees.
    float maxKeyFrameRotation = 20.0f * (M_PI / 180.f); // 20 degrees
    
    // Take a new keyframe if the translation difference is higher than 30 cm.
    float maxKeyFrameTranslation = 0.3; // 30cm

    // Threshold to consider that the rotation motion was small enough for a frame to be accepted
    // as a keyframe. This avoids capturing keyframes with strong motion blur / rolling shutter.
    float maxKeyframeRotationSpeedInDegreesPerSecond = 1.f;
    
    // Whether we should use depth aligned to the color viewpoint when Structure Sensor was calibrated.
    // This setting may get overwritten to false if no color camera can be used.
    bool useHardwareRegisteredDepth = false;
    
    // Whether to enable an expensive per-frame depth accuracy refinement.
    // Note: this option requires useHardwareRegisteredDepth to be set to false.
    const bool applyExpensiveCorrectionToDepth = true;
    
    // Whether the colorizer should try harder to preserve appearance of the first keyframe.
    // Recommended for face scans.
    bool prioritizeFirstFrameColor = true;
    
    // Target number of faces of the final textured mesh.
    int colorizerTargetNumFaces = 50000;
    
    // Focus position for the color camera (between 0 and 1). Must remain fixed one depth streaming
    // has started when using hardware registered depth.
    const float lensPosition = 0.75f;
};

enum ScannerState
{
    // Defining the volume to scan
    ScannerStateCubePlacement = 0,
    
    // Scanning
    ScannerStateScanning,
    
    // Visualizing the mesh
    ScannerStateViewing,
    
    NumStates
};

// SLAM-related members.
struct SlamData
{
    SlamData ()
    : initialized (false)
    , scannerState (ScannerStateCubePlacement)
    {}
    
    BOOL initialized;
    BOOL showingMemoryWarning = false;
    
    NSTimeInterval prevFrameTimeStamp = -1.0;
    
    STScene *scene;
    STTracker *tracker;
    STMapper *mapper;
    STCameraPoseInitializer *cameraPoseInitializer;
    GLKMatrix4 initialDepthCameraPose = GLKMatrix4Identity;
    GLKMatrix4 cubePose = GLKMatrix4Identity;
    STKeyFrameManager *keyFrameManager;
    ScannerState scannerState;
    
    GLKVector3 volumeSizeInMeters = GLKVector3Make(NAN, NAN, NAN);
};

// Utility struct to manage a gesture-based scale.
struct PinchScaleState
{
    PinchScaleState ()
    : currentScale (1.f)
    , initialPinchScale (1.f)
    {}
    
    float currentScale;
    float initialPinchScale;
};

float inline keepInRange(float value, float minValue, float maxValue)
{
    if (isnan (value))
        return minValue;
    
    if (value > maxValue)
        return maxValue;
    
    if (value < minValue)
        return minValue;
    
    return value;
}

struct AppStatus
{
    NSString* const pleaseConnectSensorMessage = @"请连接Structure Sensor.";
    NSString* const pleaseChargeSensorMessage = @"请给Structure Sensor充电.";
    
    NSString* const needColorCameraAccessMessage = @"该app需要获得相机权限.\n请到设置->隐私->相机处进行设置";
    NSString* const needCalibratedColorCameraMessage = @"This app requires an iOS device with a supported bracket.";
    
    NSString* const finalizingMeshMessage = @"Finalizing model...";
    NSString* const sensorIsWakingUpMessage = @"Sensor 正在初始化中. 请等待...";
    // Whether there is currently a message to show.
    bool needsDisplayOfStatusMessage = false;

    // Flag to disable entirely status message display.
    bool statusMessageDisabled = false;
};


// Display related members.
struct DisplayData
{
    DisplayData ()
    {
    }
    
    ~DisplayData ()
    {
        if (lumaTexture)
        {
            CFRelease (lumaTexture);
            lumaTexture = NULL;
        }
        
        if (chromaTexture)
        {
            CFRelease (chromaTexture);
            chromaTexture = NULL;
        }
        
        if (videoTextureCache)
        {
            CFRelease(videoTextureCache);
            videoTextureCache = NULL;
        }
    }
    
    // OpenGL context.
    EAGLContext *context;

    // Intrinsics to use with the current frame in the undistortion shader
    STIntrinsics intrinsics;

    // OpenGL Texture reference for y images.
    CVOpenGLESTextureRef lumaTexture;
    
    // OpenGL Texture reference for color images.
    CVOpenGLESTextureRef chromaTexture;
    
    // OpenGL Texture cache for the color camera.
    CVOpenGLESTextureCacheRef videoTextureCache;
    
    // Shader to render a GL texture as a simple quad.
    STGLTextureShaderYCbCr *yCbCrTextureShader;
    STGLTextureShaderRGBA *rgbaTextureShader;
    
    GLuint depthAsRgbaTexture;
    
    // Renders the volume boundaries as a cube.
    STCubeRenderer *cubeRenderer;
    
    // OpenGL viewport.
    GLfloat viewport[4];
    
    // OpenGL projection matrix for the color camera.
    GLKMatrix4 colorCameraGLProjectionMatrix = GLKMatrix4Identity;
    
    // OpenGL projection matrix for the depth camera.
    GLKMatrix4 depthCameraGLProjectionMatrix = GLKMatrix4Identity;

    // Mesh rendering alpha
    float meshRenderingAlpha = 0.8;
};

@interface ViewController : UIViewController <STBackgroundTaskDelegate, MeshViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate, SettingsPopupViewDelegate>
{
    STSensorController *_sensorController;
    // Structure Sensor controller.
    STStreamConfig _structureStreamConfig;
    
    SlamData _slamState;
    
    Options _options;
    
    DynamicOptions _dynamicOptions;
    
    // Manages the app status messages.
    AppStatus _appStatus;
    
    DisplayData _display;
    
    // Most recent gravity vector from IMU.
    GLKVector3 _lastGravity;
    
    // Scale of the scanning volume.
    PinchScaleState _volumeScale;

    // Mesh viewer controllers.
    UINavigationController *_meshViewNavigationController;
    MeshViewController *_meshViewController;
    
    // Structure Sensor controller.
    STCaptureSession* _captureSession;
    
    // IMU handling.
    CMMotionManager *_motionManager;
    NSOperationQueue *_imuQueue;
    
    STBackgroundTask* _naiveColorizeTask;
    STBackgroundTask* _enhancedColorizeTask;
    STDepthToRgba *_depthAsRgbaVisualizer;
    
    bool _useColorCamera;
    
    UIButton* _popupView;
    SettingsPopupView* _settingsPopupView;
    CalibrationOverlay* _calibrationOverlay;
}

@property (nonatomic, retain) NSString *stlId;
@property (nonatomic, assign) int battery;//电池电量

@property (weak, nonatomic) IBOutlet UILabel *appStatusMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *trackingLostLabel;

- (IBAction)scanButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

+ (instancetype) viewController;

- (void)enterCubePlacementState;
- (void)enterScanningState;
- (void)enterViewingState;
- (void)adjustVolumeSize:(GLKVector3)volumeSize;
- (void)updateAppStatusMessage;
- (BOOL)currentStateNeedsSensor;
- (void)updateIdleTimer;
- (void)showTrackingMessage:(NSString*)message;
- (void)hideTrackingErrorMessage;
- (void)processDeviceMotion:(CMDeviceMotion *)motion withError:(NSError *)error;
- (void)onSLAMOptionsChanged;

@end
