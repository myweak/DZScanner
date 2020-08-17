/*
  This file is part of the Structure SDK.
  Copyright © 2016 rrd, Inc. All rights reserved.
  http://structure.io
*/

#import "MeshViewController.h"
#import "MeshRenderer.h"
#import "ViewpointController.h"
#import "CustomUIKitStyles.h"
#import <ImageIO/ImageIO.h>
#include <vector>
#include <cmath>

//#import "MainStlModel.h"
//#import "ModelDraftViewController.h"
//#import "QiniuTool.h"


//#import <MBProgressHUD+NHAdd.h>
#import <SSZipArchive.h>
//#import "ObjToStl/Obj2Stl.hpp"
#import "Obj2Stl.hpp"
#import "ScanFileModel.h"

#import "DModel.hpp"
#include <iostream>
#include <fstream>

using namespace std;

// Local Helper Functions
namespace
{
    
    void saveJpegFromRGBABuffer(const char* filename, unsigned char* src_buffer, int width, int height)
    {
        FILE *file = fopen(filename, "w");
        if(!file)
            return;
        
        CGColorSpaceRef colorSpace;
        CGImageAlphaInfo alphaInfo;
        CGContextRef context;
        
        colorSpace = CGColorSpaceCreateDeviceRGB();
        alphaInfo = kCGImageAlphaNoneSkipLast;
        context = CGBitmapContextCreate(src_buffer, width, height, 8, width * 4, colorSpace, alphaInfo);
        CGImageRef rgbImage = CGBitmapContextCreateImage(context);
        
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        CFMutableDataRef jpgData = CFDataCreateMutable(NULL, 0);
        
        CGImageDestinationRef imageDest = CGImageDestinationCreateWithData(jpgData, CFSTR("public.jpeg"), 1, NULL);
        CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, // Our empty IOSurface properties dictionary
                                                     NULL,
                                                     NULL,
                                                     0,
                                                     &kCFTypeDictionaryKeyCallBacks,
                                                     &kCFTypeDictionaryValueCallBacks);
        CGImageDestinationAddImage(imageDest, rgbImage, (CFDictionaryRef)options);
        CGImageDestinationFinalize(imageDest);
        CFRelease(imageDest);
        CFRelease(options);
        CGImageRelease(rgbImage);
        
        fwrite(CFDataGetBytePtr(jpgData), 1, CFDataGetLength(jpgData), file);
        fclose(file);
        CFRelease(jpgData);
    }
    
}

@interface MeshViewController ()
{
    STMesh *_mesh;
    CADisplayLink *_displayLink;
    MeshRenderer *_renderer;
    ViewpointController *_viewpointController;
    GLfloat _glViewport[4];
    
    GLKMatrix4 _modelViewMatrixBeforeUserInteractions;
    GLKMatrix4 _projectionMatrixBeforeUserInteractions;
}

@property MFMailComposeViewController *mailViewController;
@end

@implementation MeshViewController

@synthesize mesh = _mesh;

+ (instancetype)viewController {
    MeshViewController *vc = [[MeshViewController alloc] initWithNibName:@"MeshView" bundle:nil];
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(dismissView)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(openMesh)];
    self.navigationItem.rightBarButtonItem = emailButton;
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.title = @"3D模型预览";
    }
    
    return self;
}

- (void)setupGestureRecognizer
{
    UIPinchGestureRecognizer *pinchScaleGesture = [[UIPinchGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(pinchScaleGesture:)];
    [pinchScaleGesture setDelegate:self];
    [self.view addGestureRecognizer:pinchScaleGesture];
    
    // We'll use one finger pan for rotation.
    UIPanGestureRecognizer *oneFingerPanGesture = [[UIPanGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(oneFingerPanGesture:)];
    [oneFingerPanGesture setDelegate:self];
    [oneFingerPanGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:oneFingerPanGesture];
    
    // We'll use two fingers pan for in-plane translation.
    UIPanGestureRecognizer *twoFingersPanGesture = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(twoFingersPanGesture:)];
    [twoFingersPanGesture setDelegate:self];
    [twoFingersPanGesture setMaximumNumberOfTouches:2];
    [twoFingersPanGesture setMinimumNumberOfTouches:2];
    [self.view addGestureRecognizer:twoFingersPanGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.meshViewerMessageLabel.alpha = 0.0;
    self.meshViewerMessageLabel.hidden = true;
    
    self.displayControl.hidden = YES; // xiao,第三个 保存C++ 会崩溃

    [self.meshViewerMessageLabel applyCustomStyleWithBackgroundColor:blackLabelColorWithLightAlpha];
    
    _renderer = new MeshRenderer();    
    _viewpointController = new ViewpointController(self.view.frame.size.width,
                                                   self.view.frame.size.height);
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    
    [self.displayControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    [self setupGestureRecognizer];
}

- (void)setLabel:(UILabel*)label enabled:(BOOL)enabled {
    
    UIColor* whiteLightAlpha = [UIColor colorWithRed:1.0  green:1.0   blue:1.0 alpha:0.5];
    
    if(enabled)
        [label setTextColor:[UIColor whiteColor]];
        else
        [label setTextColor:whiteLightAlpha];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"保存3D扫描模型页"];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"保存3D扫描模型页"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    if (_displayLink)
    {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(draw)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    _viewpointController->reset();

    if (!self.colorEnabled)
        [self.displayControl removeSegmentAtIndex:2 animated:NO];
    
    self.displayControl.selectedSegmentIndex = 1;
    _renderer->setRenderingMode( MeshRenderer::RenderingModeLightedGray );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupGL:(EAGLContext *)context
{
    [(EAGLView*)self.view setContext:context];
    [EAGLContext setCurrentContext:context];
    
    _renderer->initializeGL();
    
    [(EAGLView*)self.view setFramebuffer];
    CGSize framebufferSize = [(EAGLView*)self.view getFramebufferSize];
    
    float imageAspectRatio = 1.0f;
    
    // The iPad's diplay conveniently has a 4:3 aspect ratio just like our video feed.
    // Some iOS devices need to render to only a portion of the screen so that we don't distort
    // our RGB image. Alternatively, you could enlarge the viewport (losing visual information),
    // but fill the whole screen.
    if ( std::abs(framebufferSize.width/framebufferSize.height - 640.0f/480.0f) > 1e-3)
        imageAspectRatio = 480.f/640.0f;
    
    _glViewport[0] = (framebufferSize.width - framebufferSize.width*imageAspectRatio)/2;
    _glViewport[1] = 0;
    _glViewport[2] = framebufferSize.width*imageAspectRatio;
    _glViewport[3] = framebufferSize.height;
}

#pragma mark - 退出当前页面
- (void)dismissView
{

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"是否退出？"
                                                                   message:@"退出后，该数据将不会被保存！"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self goBack];
                                                       }];
    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * action) {}];
    
    [alert addAction:okButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}
//返回上一页
-(void)goBack
{
    if ([self.delegate respondsToSelector:@selector(meshViewWillDismiss)])
        [self.delegate meshViewWillDismiss];
    
    // Make sure we clear the data we don't need.
    _renderer->releaseGLBuffers();
    _renderer->releaseGLTextures();
    
    [_displayLink invalidate];
    _displayLink = nil;
    
    self.mesh = nil;
    
    [(EAGLView *)self.view setContext:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.delegate respondsToSelector:@selector(meshViewDidDismiss)])
            [self.delegate meshViewDidDismiss];
    }];
    
}
#pragma mark - MeshViewer setup when loading the mesh

- (void)setCameraProjectionMatrix:(GLKMatrix4)projection
{
    _viewpointController->setCameraProjection(projection);
    _projectionMatrixBeforeUserInteractions = projection;
}

- (void)resetMeshCenter:(GLKVector3)center
{
    _viewpointController->reset();
    _viewpointController->setMeshCenter(center);
    _modelViewMatrixBeforeUserInteractions = _viewpointController->currentGLModelViewMatrix();
}

- (void)setMesh:(STMesh *)meshRef
{
    _mesh = meshRef;
    
    if (meshRef)
    {
        _renderer->uploadMesh(meshRef);
    
        [self trySwitchToColorRenderingMode];

        self.needsDisplay = TRUE;
    }
}

#pragma mark - Email Mesh OBJ file

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self.mailViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareScreenShot:(NSString*)screenshotPath
{
    const int width = 320;
    const int height = 240;
    
    GLint currentFrameBuffer;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &currentFrameBuffer);
    
    // Create temp texture, framebuffer, renderbuffer
    glViewport(0, 0, width, height);
    
    GLuint outputTexture;
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &outputTexture);
    glBindTexture(GL_TEXTURE_2D, outputTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    GLuint colorFrameBuffer, depthRenderBuffer;
    glGenFramebuffers(1, &colorFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, colorFrameBuffer);
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, outputTexture, 0);
    
    // Keep the current render mode
    MeshRenderer::RenderingMode previousRenderingMode = _renderer->getRenderingMode();
    
    STMesh* meshToRender = _mesh;
    
    // Screenshot rendering mode, always use colors if possible.
    if ([meshToRender hasPerVertexUVTextureCoords] && [meshToRender meshYCbCrTexture])
    {
        _renderer->setRenderingMode( MeshRenderer::RenderingModeTextured );
    }
    else if ([meshToRender hasPerVertexColors])
    {
        _renderer->setRenderingMode( MeshRenderer::RenderingModePerVertexColor );
    }
    else // meshToRender can be nil if there is no available color mesh.
    {
        _renderer->setRenderingMode( MeshRenderer::RenderingModeLightedGray );
    }
    
    // Render from the initial viewpoint for the screenshot.
    _renderer->clear();
    _renderer->render(_projectionMatrixBeforeUserInteractions, _modelViewMatrixBeforeUserInteractions);
    
    // Back to current render mode
    _renderer->setRenderingMode( previousRenderingMode );
    
    struct RgbaPixel { uint8_t rgba[4]; };
    std::vector<RgbaPixel> screenShotRgbaBuffer (width*height);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, screenShotRgbaBuffer.data());
    
    // We need to flip the axis, because OpenGL reads out the buffer from the bottom.
    std::vector<RgbaPixel> rowBuffer (width);
    for (int h = 0; h < height/2; ++h)
    {
        RgbaPixel* screenShotDataTopRow    = screenShotRgbaBuffer.data() + h * width;
        RgbaPixel* screenShotDataBottomRow = screenShotRgbaBuffer.data() + (height - h - 1) * width;
        
        // Swap the top and bottom rows, using rowBuffer as a temporary placeholder.
        memcpy(rowBuffer.data(), screenShotDataTopRow, width * sizeof(RgbaPixel));
        memcpy(screenShotDataTopRow, screenShotDataBottomRow, width * sizeof (RgbaPixel));
        memcpy(screenShotDataBottomRow, rowBuffer.data(), width * sizeof (RgbaPixel));
    }
    
    saveJpegFromRGBABuffer([screenshotPath UTF8String], reinterpret_cast<uint8_t*>(screenShotRgbaBuffer.data()), width, height);
    
    // Back to the original frame buffer
    glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);
    glViewport(_glViewport[0], _glViewport[1], _glViewport[2], _glViewport[3]);
    
    // Free the data
    glDeleteTextures(1, &outputTexture);
    glDeleteFramebuffers(1, &colorFrameBuffer);
    glDeleteRenderbuffers(1, &depthRenderBuffer);
}



#pragma mark -上传文件到服务器
- (void)openMesh
{

    // 弹窗
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"请给Structure Sensor模型命名！"
           message: nil
    preferredStyle:UIAlertControllerStyleAlert];
    
    // 占位符
    [saveAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入名称";
        [textField becomeFirstResponder];
    }];
    // 确定按钮
    __weak MeshViewController *weakSelf = self;
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf saveFieldDataWithName:saveAlert.textFields.firstObject.text];
        
    }];
    // 取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [saveAlert addAction:saveAction];
    [saveAlert addAction:cancelAction];
    [self presentViewController:saveAlert animated:YES completion:nil];

}


- (void)saveFieldDataWithName:(NSString *)filedName{
    if (checkStrEmty(filedName)) {
        showTopMessage(@"请输入Structure Sensor模型名称请！");
        [self openMesh];
        return;
    }
    __weak MeshViewController *weakSelf = self;

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    // 获取当前的文件名称
    NSString *timeName = [NSString stringWithFormat:@"%@",[self getCurrentDateString]];
    
    // 1.压缩文件的名称
    NSString* zipFilename = [NSString stringWithFormat:@"%@.zip",timeName];
    //2. 截图的名称
    NSString* screenshotFilename = [NSString stringWithFormat:@"%@.jpg",timeName];
    // 获取本地目录
    NSString* cacheDirectory = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
    cacheDirectory = [NSString stringWithFormat:@"%@/LaoxiaoScan", cacheDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

       // 1。//检查 沙盒是否有当前文件
       BOOL resultcache = [fileManager fileExistsAtPath:cacheDirectory];
       if (!resultcache) {
           [fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
           return;
       }
    
    // 压缩文件的地址
    NSString *zipPath = [cacheDirectory stringByAppendingPathComponent:zipFilename];
    // 保存截图的地址
    NSString *screenshotPath =[cacheDirectory stringByAppendingPathComponent:screenshotFilename];
    
    //3.stl模型
    NSString *stlStr = [NSString stringWithFormat:@"%@.stl",timeName];
    // stl文件名
    NSString *stlFilePath = [cacheDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",stlStr]];
    
    //4. obj文件
    NSString *objStr = [NSString stringWithFormat:@"%@.obj",timeName];
    // obj文件名
    NSString *objFileName =[@"obj_" stringByAppendingFormat:@"%@", objStr];
    NSString *objFilePath = [cacheDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",objFileName]];



    //-------------------------------------------------------------------------------
        {
            NSDictionary* objOtions = @{
                kSTMeshWriteOptionFileFormatKey: @(STMeshWriteOptionFileFormatObjFile),
            };
            //写入 沙盒 1 <.obj>
            [_mesh writeToFile:objFilePath options:objOtions error:nil];
            
            // obj转stl
            const char * objFilePathChar = [objFilePath UTF8String];
            const char * stlFilePathChar = [stlFilePath UTF8String];
            
            
            //写入 沙盒 2、3 <.obj><.stl>
            bool re =  ObjTStl::loadStl((char *)objFilePathChar, (char *)stlFilePathChar);
            if (!re) {
                 showMessage(@"解压失败");
                // 不需要的 <.obj> 文件
                [[NSFileManager defaultManager] removeItemAtPath:objFilePath error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:stlFilePath error:nil];
                [SVProgressHUD dismiss];
                return;
            }
            
            
            // 保存截图 <.jpg>
            [self prepareScreenShot:screenshotPath];
            
            // 压缩文件
            //    NSDictionary* zipOptions = @{
            //                              kSTMeshWriteOptionFileFormatKey: @(STMeshWriteOptionFileFormatObjFileZip),
            //                              };
            //写入 沙盒 4 <.zip>
            //    [meshToSend writeToFile:zipPath options:zipOptions error:&error];
            //压缩。zip
            BOOL success =   [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:@[screenshotPath,stlFilePath]];
            if (!success) {
                showTopMessage(@"资源压缩失败");
                // 不需要的 <.obj> 文件
                [[NSFileManager defaultManager] removeItemAtPath:objFilePath error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:screenshotPath error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:stlFilePath error:nil];
                [SVProgressHUD dismiss];
                return;
            }
        }
        
   
    
    //-------------------------------------------------------------------------------

    
    dispatch_async(dispatch_get_main_queue(), ^{

    UIImage *zipedImage = [[UIImage imageWithContentsOfFile:screenshotPath] zipImageWithSize:CGSizeMake(500, 500)];
    [[MZQiNiuManager shareManager] uploadImageWithData:UIImageJPEGRepresentation(zipedImage,0.3) name:MZQiNiuManager_FieldName completion:^(BOOL success, NSString *fileUrl) {
        
        if (success) {
            
            //压缩级别是介于0.0和1.0之间的浮点值，其中0.0表示无压缩，而1.0表示最大压缩。值0.1将提供最快的压缩率
            NSData *stlData = [NSData dataWithContentsOfFile:zipPath];
            //                    NSData *stlData = [datass gzippedDataWithCompressionLevel:0.5];
            
            [[MZQiNiuManager shareManager] uploadFiledWithData:stlData fileName:timeName fileTypeStr:(NSString *)@"zip" completion:^(BOOL success_scan, NSString *fileUrl_scan) {
                
                if (success_scan) {
                    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
                    [parameter setValue:filedName forKey:@"name"];
                    [parameter setValue:fileUrl.imageUrlStr forKey:@"preview"];
                    [parameter setValue:fileUrl_scan.imageUrlStr forKey:@"sourceUrl"];
                    [[RRNetWorkingManager sharedSessionManager] postScanSource:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_name_Scan object:nil];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf goBack];
                            });
                        }
                        [SVProgressHUD dismiss];
                        showMessage(responseModel.msg);
                    }, nil)];

                }else{
                    [SVProgressHUD dismiss];
                    showTopMessage(@"资源上传失败！");
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 不需要的 <.obj> 文件
                    [[NSFileManager defaultManager] removeItemAtPath:objFilePath error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:screenshotPath error:nil];
                });
            }];
            
            
        }else{
            [SVProgressHUD dismiss];
            showTopMessage(@"图片加载失败");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 不需要的 <.obj> 文件
                [[NSFileManager defaultManager] removeItemAtPath:objFilePath error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:screenshotPath error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:stlFilePath error:nil];
            });
        }
    }];
        
        
        
         });
    
    
}



/**
 已时间给图片命名
 @return pic name
 */
-(NSString *)getCurrentDateString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}
-(NSString *)getCurrentTimeString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

#pragma mark - Rendering
- (void)draw
{
    [(EAGLView *)self.view setFramebuffer];
    
    glViewport(_glViewport[0], _glViewport[1], _glViewport[2], _glViewport[3]);
    
    bool viewpointChanged = _viewpointController->update();
    
    // If nothing changed, do not waste time and resources rendering.
    if (!_needsDisplay && !viewpointChanged)
        return;
    
    GLKMatrix4 currentModelView = _viewpointController->currentGLModelViewMatrix();
    GLKMatrix4 currentProjection = _viewpointController->currentGLProjectionMatrix();
    
    _renderer->clear();
    _renderer->render (currentProjection, currentModelView);

    _needsDisplay = FALSE;
    
    [(EAGLView *)self.view presentFramebuffer];
}

#pragma mark - Touch & Gesture control

- (void)pinchScaleGesture:(UIPinchGestureRecognizer *)gestureRecognizer
{
    // Forward to the ViewpointController.
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
        _viewpointController->onPinchGestureBegan([gestureRecognizer scale]);
    else if ( [gestureRecognizer state] == UIGestureRecognizerStateChanged)
        _viewpointController->onPinchGestureChanged([gestureRecognizer scale]);
}

- (void)oneFingerPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPos = [gestureRecognizer locationInView:self.view];
    CGPoint touchVel = [gestureRecognizer velocityInView:self.view];
    GLKVector2 touchPosVec = GLKVector2Make(touchPos.x, touchPos.y);
    GLKVector2 touchVelVec = GLKVector2Make(touchVel.x, touchVel.y);
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan)
        _viewpointController->onOneFingerPanBegan(touchPosVec);
    else if([gestureRecognizer state] == UIGestureRecognizerStateChanged)
        _viewpointController->onOneFingerPanChanged(touchPosVec);
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
        _viewpointController->onOneFingerPanEnded (touchVelVec);
}

- (void)twoFingersPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer numberOfTouches] != 2)
        return;
    
    CGPoint touchPos = [gestureRecognizer locationInView:self.view];
    CGPoint touchVel = [gestureRecognizer velocityInView:self.view];
    GLKVector2 touchPosVec = GLKVector2Make(touchPos.x, touchPos.y);
    GLKVector2 touchVelVec = GLKVector2Make(touchVel.x, touchVel.y);
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan)
        _viewpointController->onTwoFingersPanBegan(touchPosVec);
    else if([gestureRecognizer state] == UIGestureRecognizerStateChanged)
        _viewpointController->onTwoFingersPanChanged(touchPosVec);
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
        _viewpointController->onTwoFingersPanEnded (touchVelVec);
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    _viewpointController->onTouchBegan();
}

#pragma mark - UI Control

- (void)trySwitchToColorRenderingMode
{
    // Choose the best available color render mode, falling back to LightedGray
    
    // This method may be called when colorize operations complete, and will
    // switch the render mode to color, as long as the user has not changed
    // the selector.

    if(self.displayControl.selectedSegmentIndex == 2)
    {
        if ( [_mesh hasPerVertexUVTextureCoords])
            _renderer->setRenderingMode(MeshRenderer::RenderingModeTextured);
        else if ([_mesh hasPerVertexColors])
            _renderer->setRenderingMode(MeshRenderer::RenderingModePerVertexColor);
        else
            _renderer->setRenderingMode(MeshRenderer::RenderingModeLightedGray);
    }
}

- (IBAction)displayControlChanged:(id)sender {
    
    switch (self.displayControl.selectedSegmentIndex) {
        case 0: // x-ray
        {
            _renderer->setRenderingMode(MeshRenderer::RenderingModeXRay);
        }
            break;
        case 1: // lighted-gray
        {
            _renderer->setRenderingMode(MeshRenderer::RenderingModeLightedGray);
        }
            break;
        case 2: // color
        {
            [self trySwitchToColorRenderingMode];

            bool meshIsColorized = [_mesh hasPerVertexColors] ||
                                   [_mesh hasPerVertexUVTextureCoords];
            
            if ( !meshIsColorized ) [self colorizeMesh];
        }
            break;
        default:
            break;
    }
    
    self.needsDisplay = TRUE;
}

- (void)colorizeMesh
{
    [self.delegate meshViewDidRequestColorizing:_mesh previewCompletionHandler:^{
    } enhancedCompletionHandler:^{
        // Hide progress bar.
        [self hideMeshViewerMessage];
    }];
}

- (void)hideMeshViewerMessage
{
    [UIView animateWithDuration:0.5f animations:^{
        self.meshViewerMessageLabel.alpha = 0.0f;
    } completion:^(BOOL finished){
        [self.meshViewerMessageLabel setHidden:YES];
    }];
}

- (void)showMeshViewerMessage:(NSString *)msg
{
    [self.meshViewerMessageLabel setText:msg];
    
    if (self.meshViewerMessageLabel.hidden == YES)
    {
        [self.meshViewerMessageLabel setHidden:NO];
        
        self.meshViewerMessageLabel.alpha = 0.0f;
        [UIView animateWithDuration:0.5f animations:^{
            self.meshViewerMessageLabel.alpha = 1.0f;
        }];
    }
}

@end
