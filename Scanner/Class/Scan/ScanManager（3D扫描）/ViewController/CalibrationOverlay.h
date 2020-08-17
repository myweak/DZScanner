/*
  This file is part of the Structure SDK.
  Copyright © 2019 rrd, Inc. All rights reserved.
  http://structure.io
*/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CalibrationOverlayType) {
    CalibrationOverlayTypeNone,
    CalibrationOverlayTypeApproximate,
    CalibrationOverlayTypeStrictlyRequired
};

@class CalibrationOverlay;

@protocol CalibrationOverlayDelegate<NSObject>
- (void)calibrationOverlayDidTapCalibrateButton:(CalibrationOverlay *)sender;
@end;

@interface CalibrationOverlay : UIView

@property (nonatomic, assign) CalibrationOverlayType overlayType;
@property (nonatomic, weak) id<CalibrationOverlayDelegate> delegate;

- (instancetype)initWithType:(CalibrationOverlayType)overlayType;

@end
