/*
  This file is part of the Structure SDK.
  Copyright © 2019 rrd, Inc. All rights reserved.
  http://structure.io
*/

#import "CalibrationOverlay.h"
#import "ViewUtilities.h"
#import <Structure/Structure.h>

@interface CalibrationOverlay()
{
    UIView * _contentView;
}

@end

@implementation CalibrationOverlay
@synthesize overlayType = _overlayType;

- (instancetype)initWithType:(CalibrationOverlayType)overlayType
{
    self = [super initWithFrame:CGRectZero];
    
    self.overlayType = overlayType;
    self.translatesAutoresizingMaskIntoConstraints = NO;

    if(!self) {
        return nil;
    }
    
    return self;
}

- (void)setOverlayType:(CalibrationOverlayType)overlayType {
    _overlayType = overlayType;
    [self setup];
}

- (CalibrationOverlayType)overlayType {
    return _overlayType;
}

- (void) frameForCalibrationOverlayType:(CalibrationOverlayType)overlayType
{
    float height = NAN;
    float width = NAN;

    switch (overlayType) {
        case CalibrationOverlayTypeNone:
            width = 650.0; height = 340.0;
            break;
        case CalibrationOverlayTypeApproximate:
            width = 340.0; height = 56.0;
            break;
        case CalibrationOverlayTypeStrictlyRequired:
            width = 650.0; height = 340.0;
            break;
    }
    [self addConstraints:@[// Set full view width
                           [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:width],
                           // Set full view height
                           [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:height]]];
}

- (void)setup
{
    [self frameForCalibrationOverlayType:_overlayType];
    [_contentView removeFromSuperview];

    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.clipsToBounds = NO;
    [self addSubview:_contentView];
    
    // Pinning all edges of the content view to the superview (this object)
    [_contentView.superview addConstraints:@[// Top edge
                                             [NSLayoutConstraint constraintWithItem:_contentView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentView.superview
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:0.0],
                                             // Left edge
                                             [NSLayoutConstraint constraintWithItem:_contentView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentView.superview
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0
                                                                           constant:0.0],
                                             // Right edge
                                             [NSLayoutConstraint constraintWithItem:_contentView
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentView.superview
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0
                                                                           constant:0.0],
                                             // Bottom edge
                                             [NSLayoutConstraint constraintWithItem:_contentView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentView.superview
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:0.0]]];
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    self.userInteractionEnabled = YES;
    
    switch (_overlayType)
    {
        case CalibrationOverlayTypeNone:
        {
            self.layer.cornerRadius = 12.0;
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calibration.png"]];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.layer.cornerRadius = 8.0;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_contentView addSubview:imageView];

            [imageView.superview addConstraints:@[// Pin image to top (with inset) of superview
                                                  [NSLayoutConstraint constraintWithItem:imageView
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:imageView.superview
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1.0
                                                                                constant:35.0],
                                                  // Align the centre X axis to the superview
                                                  [NSLayoutConstraint constraintWithItem:imageView
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:imageView.superview
                                                                               attribute:NSLayoutAttributeCenterX
                                                                              multiplier:1.0
                                                                                constant:0.0]]];
            [imageView addConstraints:@[// Set width to 90
                                        [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:90.0],
                                        // Set height to 90
                                        [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:90.0]]];
            
            UILabel* titleLabel = [[UILabel alloc] init];
            titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            titleLabel.font = [UIFont systemFontOfSize:36.0 weight:UIFontWeightBold];
            titleLabel.adjustsFontSizeToFitWidth = NO;
            titleLabel.text = @"校准请求";
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [_contentView addSubview:titleLabel];
            
            // Set title height to 43
            [titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:43.0]];
            [titleLabel.superview addConstraints:@[// Align title to centre of superview
                                                   [NSLayoutConstraint constraintWithItem:titleLabel
                                                                                attribute:NSLayoutAttributeCenterX
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:titleLabel.superview
                                                                                attribute:NSLayoutAttributeCenterX
                                                                               multiplier:1.0
                                                                                 constant:0.0],
                                                   // Pin title to bottom of image view
                                                   [NSLayoutConstraint constraintWithItem:titleLabel
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:imageView
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.0
                                                                                 constant:25.0]]];
            
            UILabel * messageLabel = [[UILabel alloc] init];
            messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
            messageLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
            messageLabel.adjustsFontSizeToFitWidth = YES;
            NSString *subText = @"在开始扫码前，你需要先校准你的结构传感器.";
            NSMutableAttributedString* attrSub = [[NSMutableAttributedString  alloc] initWithString:subText];
            NSMutableParagraphStyle *subStyle = [[NSMutableParagraphStyle alloc] init];
            [subStyle setLineSpacing:8.0];
            [attrSub addAttribute:NSParagraphStyleAttributeName
                            value:subStyle
                            range:NSMakeRange(0, [subText length])];
            messageLabel.attributedText = attrSub;
            messageLabel.textColor = [UIColor whiteColor];
            [_contentView addSubview:messageLabel];

            [messageLabel.superview addConstraints:@[// Pin message underneath title label
                                                     [NSLayoutConstraint constraintWithItem:messageLabel
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:titleLabel
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1.0
                                                                                   constant:10.0],
                                                     // Align message to centre of superview
                                                     [NSLayoutConstraint constraintWithItem:messageLabel
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:messageLabel.superview
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1.0
                                                                                   constant:0.0]]];
            [messageLabel addConstraints:@[// Set message height to 26.0
                                           [NSLayoutConstraint constraintWithItem:messageLabel
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:26.0]]];

            UIButton * calibrateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            calibrateButton.translatesAutoresizingMaskIntoConstraints = NO;
            [calibrateButton setTitle: @"去校准" forState: UIControlStateNormal];
            [calibrateButton setTitleColor:colorFromHexString(@"#3A3A3C") forState:UIControlStateNormal];
            [calibrateButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.76] forState:UIControlStateHighlighted];
            
            [calibrateButton setBackgroundImage:imageWithColor([UIColor whiteColor], CGRectMake(0.0, 0.0, 260.0, 50.0), 25.0)
                                       forState:UIControlStateNormal];
            [calibrateButton setBackgroundImage:imageWithColor([UIColor lightGrayColor], CGRectMake(0.0, 0.0, 260.0, 50.0), 25.0)
                                       forState:UIControlStateHighlighted];
            
            calibrateButton.backgroundColor = [UIColor clearColor];
            calibrateButton.clipsToBounds = YES;
            calibrateButton.layer.cornerRadius = 25.0f;
            calibrateButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
            calibrateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            calibrateButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [calibrateButton addTarget: self action: @selector(calibrationButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
            [_contentView addSubview: calibrateButton];
            
            [calibrateButton addConstraints:@[// Pin calibrate button underneath message label with offset
                                              // Set button width to 260
                                              [NSLayoutConstraint constraintWithItem:calibrateButton
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:260.0],
                                              // Set button height to 50
                                              [NSLayoutConstraint constraintWithItem:calibrateButton
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:50.0]]];
            [calibrateButton.superview addConstraints:@[// Align button to centre of superview
                                                        [NSLayoutConstraint constraintWithItem:calibrateButton
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:calibrateButton.superview
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                    multiplier:1.0
                                                                                      constant:0.0],
                                                        [NSLayoutConstraint constraintWithItem:calibrateButton
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:messageLabel
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0
                                                                                      constant:30.0]]];
            break;
        }
        case CalibrationOverlayTypeApproximate:
        {
            self.layer.cornerRadius = 8.0;
            
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image-wvl-calibration"]];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.layer.cornerRadius = 8.0;
            imageView.clipsToBounds = YES;
            [_contentView addSubview: imageView];
            
            [imageView.superview addConstraints:@[// Pin image to top of superview with offset
                                                  [NSLayoutConstraint constraintWithItem:imageView
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:imageView.superview
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1.0
                                                                                constant:4.0],
                                                  // Pin image to leading edge of superview with offset
                                                  [NSLayoutConstraint constraintWithItem:imageView
                                                                               attribute:NSLayoutAttributeLeading
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:imageView.superview
                                                                               attribute:NSLayoutAttributeLeading
                                                                              multiplier:1.0
                                                                                constant:4.0]]];
            [imageView addConstraints:@[// Fix width to 48
                                        [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:48.0],
                                        // Fix height to 48
                                        [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:48.0]]];

            UILabel * message = [[UILabel alloc] init];
            message.translatesAutoresizingMaskIntoConstraints = NO;
            message.font = [UIFont fontWithName:@"DIN Alternate Bold" size:16.0];
            message.text = @"需要校准以获得最佳结果.";
            message.textColor = [UIColor whiteColor];
            [_contentView addSubview:message];

            [message.superview addConstraints:@[// Pin top of message to superview with offset
                                                [NSLayoutConstraint constraintWithItem:message
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:message.superview
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0
                                                                              constant:4.0],
                                                // Pin leading edge of message to superview with offset
                                                [NSLayoutConstraint constraintWithItem:message
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:message.superview
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:64.0],
                                                // Pin trailing edge of message to superview with offset
                                                [NSLayoutConstraint constraintWithItem:message
                                                                             attribute:NSLayoutAttributeTrailing
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:message.superview
                                                                             attribute:NSLayoutAttributeTrailing
                                                                            multiplier:1.0
                                                                              constant:4.0]]];
            // Set height of message to 22
            [message addConstraint:[NSLayoutConstraint constraintWithItem:message
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:22.0]];

            UIButton * calibrationButton = [UIButton buttonWithType: UIButtonTypeSystem];
            calibrationButton.translatesAutoresizingMaskIntoConstraints = NO;
            
            [calibrationButton setTitle: @"现在校准" forState: UIControlStateNormal];
            calibrationButton.tintColor = [UIColor colorWithRed:0.25 green:0.73 blue: 0.88 alpha: 1.];
            calibrationButton.titleLabel.font =  [UIFont fontWithName:@"DIN Alternate Bold" size:16.0];
            calibrationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            calibrationButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [calibrationButton addTarget: self action: @selector(calibrationButtonClicked:) forControlEvents: UIControlEventTouchUpInside];

            [_contentView addSubview: calibrationButton];
            [calibrationButton.superview addConstraints:@[// Pin calibration button beneath message with offset
                                                          [NSLayoutConstraint constraintWithItem:calibrationButton
                                                                                       attribute:NSLayoutAttributeTop
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:message
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                      multiplier:1.0
                                                                                        constant:4.0],
                                                          // Pin calibration button leading edge to leading edge of message
                                                          [NSLayoutConstraint constraintWithItem:calibrationButton
                                                                                       attribute:NSLayoutAttributeLeading
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:message
                                                                                       attribute:NSLayoutAttributeLeading
                                                                                      multiplier:1.0
                                                                                        constant:0.0]]];
            // Set height of calibration button to 22
            [calibrationButton addConstraint:[NSLayoutConstraint constraintWithItem:calibrationButton
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0
                                                                           constant:22.0]];
            break;
        }
        case CalibrationOverlayTypeStrictlyRequired:
        {
            self.layer.cornerRadius = 12.0;
            
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image-wvl-calibration.png"]];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_contentView addSubview: imageView];

            [imageView.superview addConstraints:@[// Pin image to top of superview with offset
                                                  [NSLayoutConstraint constraintWithItem:imageView
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:imageView.superview
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1.0
                                                                                constant:120.0],
                                                  // Pin image to leading edge of superview with offset
                                                  [NSLayoutConstraint constraintWithItem:imageView
                                                                               attribute:NSLayoutAttributeLeading
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:imageView.superview
                                                                               attribute:NSLayoutAttributeLeading
                                                                              multiplier:1.0
                                                                                constant:100.0]]];
            [imageView addConstraints:@[// Set image width to 90
                                        [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:90.0],
                                        // Set image height to 90
                                        [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:90.0]]];
            
            UIVisualEffect* visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView* visualEffectView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
            visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
            [_contentView addSubview:visualEffectView];
            visualEffectView.layer.cornerRadius = 45.0f;
            visualEffectView.layer.masksToBounds = YES;
            [_contentView bringSubviewToFront:visualEffectView];

            [visualEffectView.superview addConstraints:@[// Pin bottom of visual effect view to image view with offset
                                                         [NSLayoutConstraint constraintWithItem:visualEffectView
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:imageView
                                                                                      attribute:NSLayoutAttributeTop
                                                                                     multiplier:1.0
                                                                                       constant:32.5],
                                                         // Pin right of visual effect view to image view with offset
                                                         [NSLayoutConstraint constraintWithItem:visualEffectView
                                                                                      attribute:NSLayoutAttributeRight
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:imageView
                                                                                      attribute:NSLayoutAttributeLeft
                                                                                     multiplier:1.0
                                                                                       constant:35.0]]];
            
            [visualEffectView addConstraints:@[// Set width to 90
                                               [NSLayoutConstraint constraintWithItem:visualEffectView
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:90.0],
                                               // Set height to 90
                                               [NSLayoutConstraint constraintWithItem:visualEffectView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:90.0]]];

            UIImageView *wvl = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image-wvl.png"]];
            wvl.translatesAutoresizingMaskIntoConstraints = NO;
            [visualEffectView.contentView addSubview:wvl];

            // Pin all edges to super view edge with one offset on the left edge
            [wvl.superview addConstraints:@[[NSLayoutConstraint constraintWithItem:wvl
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:wvl.superview
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:0.0],
                                            [NSLayoutConstraint constraintWithItem:wvl
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:wvl.superview
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:5.0],
                                            [NSLayoutConstraint constraintWithItem:wvl
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:wvl.superview
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0.0],
                                            [NSLayoutConstraint constraintWithItem:wvl
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:wvl.superview
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:0.0]]];

            UILabel * titleLabel = [[UILabel alloc] init];
            titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            titleLabel.font = [UIFont systemFontOfSize:36.0 weight:UIFontWeightBold];
            
            titleLabel.adjustsFontSizeToFitWidth = YES;
            titleLabel.text = @"镜头的校准要求";
            titleLabel.textColor = [UIColor whiteColor];
            [_contentView addSubview:titleLabel];
            
            [titleLabel.superview addConstraints:@[// Pin top edge to superview with offset
                                                   [NSLayoutConstraint constraintWithItem:titleLabel
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:titleLabel.superview
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1.0
                                                                                 constant:50.0],
                                                   // Align centre X between title and superview
                                                   [NSLayoutConstraint constraintWithItem:titleLabel
                                                                                attribute:NSLayoutAttributeLeading
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:imageView
                                                                                attribute:NSLayoutAttributeTrailing
                                                                               multiplier:1.0
                                                                                 constant:22.0]]];
            [titleLabel addConstraints:@[// Set width to 400
                                         [NSLayoutConstraint constraintWithItem:titleLabel
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:380.0],
                                         // Set height to 43
                                         [NSLayoutConstraint constraintWithItem:titleLabel
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:43.0]]];
            
            UILabel * messageLabel = [[UILabel alloc] init];
            messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
            messageLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
            messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            messageLabel.numberOfLines = 0;
            NSString *subText = @"为了用你的广视镜进行扫描，你需要校准镜头.";
            NSMutableAttributedString* attrSub = [[NSMutableAttributedString  alloc] initWithString:subText];
            NSMutableParagraphStyle *subStyle = [[NSMutableParagraphStyle alloc] init];
            [subStyle setLineSpacing:8.0];
            [attrSub addAttribute:NSParagraphStyleAttributeName
                            value:subStyle
                            range:NSMakeRange(0, [subText length])];
            messageLabel.attributedText = attrSub;
            messageLabel.textColor = [UIColor whiteColor];
            [_contentView addSubview:messageLabel];

            [messageLabel.superview addConstraints:@[// Align centre X between message and titleLabel
                                                     [NSLayoutConstraint constraintWithItem:messageLabel
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:titleLabel
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1.0
                                                                                   constant:0.0],
                                                     // Pin message top to bottom of title with offset
                                                     [NSLayoutConstraint constraintWithItem:messageLabel
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:titleLabel
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1.0
                                                                                   constant:15.0],
                                                     // Set width of message to match title
                                                     [NSLayoutConstraint constraintWithItem:messageLabel
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:titleLabel
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:1.0
                                                                                   constant:0.0]]];
            
            UILabel * subMessageLabel = [[UILabel alloc] init];
            subMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
            subMessageLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
            subMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            subMessageLabel.numberOfLines = 0;

            NSString *text = @"(或者，您可以关闭并摘除广角镜头.)";
            NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:text];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:8.0];
            [attrString addAttribute:NSParagraphStyleAttributeName
                               value:style
                               range:NSMakeRange(0, [text length])];
            subMessageLabel.attributedText = attrString;
            subMessageLabel.textColor = colorFromHexString(@"#BDBDBD");
            [_contentView addSubview:subMessageLabel];

            [subMessageLabel.superview addConstraints:@[// Align centre X axis between sub-message and message
                                                        [NSLayoutConstraint constraintWithItem:subMessageLabel
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:messageLabel
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                    multiplier:1.0
                                                                                      constant:0.0],
                                                        // Pin top edge of sub-message to bottom of message
                                                        [NSLayoutConstraint constraintWithItem:subMessageLabel
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:messageLabel
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0
                                                                                      constant:13.0],
                                                        // Set width of sub-message to match message
                                                        [NSLayoutConstraint constraintWithItem:subMessageLabel
                                                                                     attribute:NSLayoutAttributeWidth
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:messageLabel
                                                                                     attribute:NSLayoutAttributeWidth
                                                                                    multiplier:1.0
                                                                                      constant:0.0]]];
            
            UIButton * calibrateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            calibrateButton.translatesAutoresizingMaskIntoConstraints = NO;
            [calibrateButton setTitle: @"现在校准" forState: UIControlStateNormal];
            [calibrateButton setTitleColor:colorFromHexString(@"#3A3A3C") forState:UIControlStateNormal];
            [calibrateButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.76] forState:UIControlStateHighlighted];
            
            [calibrateButton setBackgroundImage:imageWithColor([UIColor whiteColor], CGRectMake(0.0, 0.0, 413.0, 50.0), 25.0)
                                       forState:UIControlStateNormal];
            [calibrateButton setBackgroundImage:imageWithColor([UIColor lightGrayColor], CGRectMake(0.0, 0.0, 413.0, 50.0), 25.0)
                                       forState:UIControlStateHighlighted];

            calibrateButton.backgroundColor = [UIColor clearColor];
            calibrateButton.clipsToBounds = YES;
            calibrateButton.layer.cornerRadius = 25.0f;
            calibrateButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
            calibrateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            calibrateButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [calibrateButton addTarget: self action: @selector(calibrationButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
            [_contentView addSubview: calibrateButton];

            [calibrateButton.superview addConstraints:@[// Align centre X axis between calibration button and sub-message
                                                        [NSLayoutConstraint constraintWithItem:calibrateButton
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:calibrateButton.superview
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                    multiplier:1.0
                                                                                      constant:0.0],
                                                        // Pin top of calibration button to bottom edge of sub-message with offset
                                                        [NSLayoutConstraint constraintWithItem:calibrateButton
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:subMessageLabel
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0
                                                                                      constant:25.0]]];
            
            [calibrateButton addConstraints:@[// Set width to 260
                                              [NSLayoutConstraint constraintWithItem:calibrateButton
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:260.0],
                                              // Set height to 50
                                              [NSLayoutConstraint constraintWithItem:calibrateButton
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:50.0]]];
            break;
        }
    }
}

- (void)calibrationButtonClicked:(UIButton*)button
{
    if([self.delegate respondsToSelector:@selector(calibrationOverlayDidTapCalibrateButton:)]) {
        [self.delegate calibrationOverlayDidTapCalibrateButton:self];
    }
    else {
        launchCalibratorAppOrGoToAppStore();
    }
}

@end
