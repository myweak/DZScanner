/*
  This file is part of the Structure SDK.
  Copyright © 2019 rrd, Inc. All rights reserved.
  http://structure.io
*/

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "ViewController.h"
#import <Structure/Structure.h>

#import "MeshViewController.h"

@interface ViewController (CaptureSession) <STCaptureSessionDelegate>

- (BOOL)isStructureConnected;
- (void)setupCaptureSession;

@end
