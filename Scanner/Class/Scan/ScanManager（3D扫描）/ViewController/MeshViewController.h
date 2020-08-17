/*
  This file is part of the Structure SDK.
  Copyright © 2016 rrd, Inc. All rights reserved.
  http://structure.io
*/

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Structure/Structure.h>
#import "EAGLView.h"

@protocol MeshViewDelegate <NSObject>
- (void)meshViewWillDismiss;
- (void)meshViewDidDismiss;
- (BOOL)meshViewDidRequestColorizing:(STMesh*)mesh
            previewCompletionHandler:(void(^)(void))previewCompletionHandler
           enhancedCompletionHandler:(void(^)(void))enhancedCompletionHandler;
@end

@interface MeshViewController : UIViewController <UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, assign) NSString *stlId;
@property (nonatomic, assign) id<MeshViewDelegate> delegate;

@property (nonatomic) BOOL needsDisplay; // force the view to redraw.
@property (nonatomic) BOOL colorEnabled;
@property (nonatomic) STMesh * mesh;

@property (weak, nonatomic) IBOutlet UISegmentedControl *displayControl;
@property (weak, nonatomic) IBOutlet UILabel *meshViewerMessageLabel;

+ (instancetype)viewController;

- (IBAction)displayControlChanged:(id)sender;

- (void)showMeshViewerMessage:(NSString *)msg;
- (void)hideMeshViewerMessage;

- (void)setCameraProjectionMatrix:(GLKMatrix4)projRt;
- (void)resetMeshCenter:(GLKVector3)center;

- (void)setupGL:(EAGLContext*)context;

@end
