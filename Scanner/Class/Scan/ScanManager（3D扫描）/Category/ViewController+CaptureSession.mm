/*
  This file is part of the Structure SDK.
  Copyright © 2019 rrd, Inc. All rights reserved.
  http://structure.io
*/

#import "ViewController.h"
#import "ViewController+CaptureSession.h"
#import "ViewController+SLAM.h"
#import "ViewController+OpenGL.h"

#import <Structure/Structure.h>
//#import <Structure/StructureSLAM.h>
//#import <Structure/STCaptureSession.h>

@implementation ViewController (CaptureSession)

#pragma mark -  Capture Session Setup

- (bool)videoDeviceSupportsHighResColor
{
    // High Resolution Color format is width 2592, height 1936.
    // Most recent devices support this format at 30 FPS.
    // However, older devices may only support this format at a lower framerate.
    // In your Structure Sensor is on firmware 2.0+, it supports depth capture at FPS of 24.

    AVCaptureDevice *testVideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (testVideoDevice == nil)
        assert(0);

    for (AVCaptureDeviceFormat* format in testVideoDevice.formats)
    {
        AVFrameRateRange* firstFrameRateRange = ((AVFrameRateRange *)[format.videoSupportedFrameRateRanges objectAtIndex:0]);

        double formatMinFps = firstFrameRateRange.minFrameRate;
        double formatMaxFps = firstFrameRateRange.maxFrameRate;

        if (   (formatMaxFps < 15) // Max framerate too low.
            || (formatMinFps > 30) // Min framerate too high.
            || (formatMaxFps == 24 && formatMinFps > 15) // We can neither do the 24 FPS max framerate, nor fall back to 15.
            )
            continue;

        CMFormatDescriptionRef formatDesc = format.formatDescription;
        FourCharCode fourCharCode = CMFormatDescriptionGetMediaSubType(formatDesc);

        CMVideoFormatDescriptionRef videoFormatDesc = formatDesc;
        CMVideoDimensions formatDims = CMVideoFormatDescriptionGetDimensions(videoFormatDesc);

        if ( 2592 != formatDims.width )
            continue;

        if ( 1936 != formatDims.height )
            continue;
        
        if ( format.isVideoBinned )
            continue;

        // we only support full range YCbCr for now
        if(fourCharCode != (FourCharCode)'420f')
            continue;

        // All requirements met.
        return true;
    }

    // No acceptable high-res format was found.
    return false;
}

- (void)setupCaptureSession
{
    // Clear / reset the capture session if it already exists
    if (_captureSession == nil)
    {
        // Create an STCaptureSession instance
        _captureSession = [STCaptureSession newCaptureSession];
    }
    else
    {
        _captureSession.streamingEnabled = NO;
    }

    STCaptureSessionColorResolution resolution = _dynamicOptions.highResColoring ?
        STCaptureSessionColorResolution2592x1936 :
        STCaptureSessionColorResolution640x480;

    if (!self.videoDeviceSupportsHighResColor)
    {
        NSLog(@"Device does not support high resolution color mode!");
        resolution = STCaptureSessionColorResolution640x480;
    }

    NSDictionary* sensorConfig = @{
                                   kSTCaptureSessionOptionColorResolutionKey: @(resolution),
                                   kSTCaptureSessionOptionDepthSensorVGAEnabledIfAvailableKey: @(NO),
                                   kSTCaptureSessionOptionColorMaxFPSKey: @(30.0f),
                                   kSTCaptureSessionOptionDepthSensorEnabledKey: @(YES),
                                   kSTCaptureSessionOptionUseAppleCoreMotionKey: @(YES),
                                   kSTCaptureSessionOptionDepthStreamPresetKey: @(_dynamicOptions.depthStreamPreset),
                                   kSTCaptureSessionOptionSimulateRealtimePlaybackKey: @(YES),
                                   };
    
//    _captureSession.occWriter.useH264ForColor = YES;
    
    // Set the lens detector off, and default lens state as "non-WVL" mode
    _captureSession.lens = STLensNormal;
    _captureSession.lensDetection = STLensDetectorOff;
    
    // Set ourself as the delegate to receive sensor data.
    _captureSession.delegate = self;
    [_captureSession startMonitoringWithOptions:sensorConfig];
}

- (BOOL)isStructureConnected
{
    return _captureSession.sensorMode > STCaptureSessionSensorModeNotConnected;
}

#pragma mark -  STCaptureSession delegate methods

- (void)captureSession:(STCaptureSession *)captureSession colorCameraDidEnterMode:(STCaptureSessionColorCameraMode)mode
{
    switch(mode)
    {
        case STCaptureSessionColorCameraModePermissionDenied:
        case STCaptureSessionColorCameraModeReady:
            break;
        case STCaptureSessionColorCameraModeUnknown:
        default:
        {
            // throw an exception
            @throw [NSException exceptionWithName:@"Camera Mode Exception"
                                           reason:@"The color camera has entered an unknown state."
                                         userInfo:nil];
            break;
        }
    }
    [self updateAppStatusMessage];
}

- (void)captureSession:(STCaptureSession *)captureSession sensorDidEnterMode:(STCaptureSessionSensorMode)mode
{
    switch(mode)
    {
        case STCaptureSessionSensorModeReady:
        case STCaptureSessionSensorModeWakingUp:
        case STCaptureSessionSensorModeStandby:
        case STCaptureSessionSensorModeNotConnected:
        case STCaptureSessionSensorModeBatteryDepleted:
            break;
            // Fall through intentional
        case STCaptureSessionSensorModeUnknown:
        default:
            // throw an exception
            @throw [NSException exceptionWithName:@"Sensor Mode Exception"
                                           reason:@"The sensor has entered an unknown mode."
                                         userInfo:nil];
            break;
    }
    [self updateAppStatusMessage];
}

- (void)captureSession:(STCaptureSession*)captureSession sensorChargerStateChanged:(STCaptureSessionSensorChargerState)chargerState
{
    switch (chargerState)
    {
        case STCaptureSessionSensorChargerStateConnected:
            break;
        case STCaptureSessionSensorChargerStateDisconnected:
            // Do nothing, we only need to handle low-power notifications based on the sensor mode.
            break;
        case STCaptureSessionSensorChargerStateUnknown:
        default:
            @throw [NSException exceptionWithName:@"Scanner"
                                           reason:@"Unknown STCaptureSessionSensorChargerState!"
                                         userInfo:nil];
            break;
    }
    [self updateAppStatusMessage];
}

- (void)captureSession:(STCaptureSession*)captureSession didStartAVCaptureSession:(AVCaptureSession*)avCaptureSession
{
    // Initialize our default video device properties once the AVCaptureSession has been started.
    _captureSession.properties = STCaptureSessionPropertiesSetColorCameraAutoExposureISOAndWhiteBalance();
}

- (void)captureSession:(STCaptureSession*)captureSession didStopAVCaptureSession:(AVCaptureSession*)avCaptureSession
{
}

- (void)captureSession:(STCaptureSession*)captureSession didOutputSample:(NSDictionary*)sample type:(STCaptureSessionSampleType)type
{
    switch (type)
    {
        case STCaptureSessionSampleTypeSensorDepthFrame:
        {
            STDepthFrame* depthFrame = [sample objectForKey:kSTCaptureSessionSampleEntryDepthFrame];
            if (_slamState.initialized)
            {
                [self processDepthFrame: depthFrame colorFrameOrNil:nil];
                // Scene rendering is triggered by new frames to avoid rendering the same view several times.
                [self renderSceneForDepthFrame: depthFrame colorFrameOrNil:nil];
            }
            break;
        }
        case STCaptureSessionSampleTypeIOSColorFrame:
        {
            // Skipping until a pair is returned.
            break;
        }
        case STCaptureSessionSampleTypeSynchronizedFrames:
        {
            STDepthFrame* depthFrame = [sample objectForKey:kSTCaptureSessionSampleEntryDepthFrame];
            STColorFrame* colorFrame = [sample objectForKey:kSTCaptureSessionSampleEntryIOSColorFrame];
            if (_slamState.initialized)
            {
                [self processDepthFrame:depthFrame colorFrameOrNil:colorFrame];
                // Scene rendering is triggered by new frames to avoid rendering the same view several times.
                [self renderSceneForDepthFrame:depthFrame colorFrameOrNil:colorFrame];
            }
            break;
        }
        case STCaptureSessionSampleTypeDeviceMotionData:
        {
            CMDeviceMotion* deviceMotion = [sample objectForKey:kSTCaptureSessionSampleEntryDeviceMotionData];
            [self processDeviceMotion:deviceMotion withError:nil];
            break;
        }
        case STCaptureSessionSampleTypeUnknown:
            @throw [NSException exceptionWithName:@"Scanner"
                                           reason:@"Unknown STCaptureSessionSampleType!"
                                         userInfo:nil];
            break;
        default:
            NSLog(@"Skipping Capture Session sample type: %ld", static_cast<long>(type));
            break;
    }
}

- (void)captureSession:(STCaptureSession*)captureSession onLensDetectorOutput:(STDetectedLensStatus)detectedLensStatus
{
    switch (detectedLensStatus)
    {
        case STDetectedLensNormal:
            // Detected a WVL is not attached to the bracket.
            NSLog(@"Detected that the WVL is off!");
            break;
        case STDetectedLensWideVisionLens:
            // Detected a WVL is attached to the bracket.
            NSLog(@"Detected that the WVL is on!");
            break;
        case STDetectedLensPerformingInitialDetection:
            // Triggers immediately when detector is turned on. Can put a message here
            // showing the user that the detector is working and they need to pan the
            // camera for best results
            NSLog(@"Performing initial detection!");
            break;
        case STDetectedLensUnsure:
            break;
        default:
            @throw [NSException exceptionWithName:@"Scanner"
                                           reason:@"Unknown STDetectedLensStatus!"
                                         userInfo:nil];
            break;
    }
}

@end
