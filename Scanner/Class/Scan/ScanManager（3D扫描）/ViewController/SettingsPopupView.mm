/*
 This file is part of the Structure SDK.
 Copyright © 2019 rrd, Inc. All rights reserved.
 http://structure.io
 */

#import "SettingsPopupView.h"
#import "ViewUtilities.h"
#import "RrStucture.h"

@interface SettingsListModal : UIScrollView

@end

@implementation SettingsListModal
{
    id<SettingsPopupViewDelegate> _delegate;

    CGFloat marginSize;
    UIView* _contentView;
    
    // Objects that correspond to dynamic option settings
    UISwitch* highResolutionColorSwitch;
    UISwitch* irAutoExposureSwitch;
    UISlider* irManualExposureSlider;
    UISegmentedControl* distanceSegmentedControl; //距离设置
    UISegmentedControl* irGainSegmentedControl;
    UISegmentedControl* streamPresetSegmentedControl;
    UISegmentedControl* streamPresetSegmentedControl1;
    UISegmentedControl* trackerTypeSegmentedControl;
    UISwitch* improvedTrackerSwitch;
    UISwitch* highResolutionMeshSwitch;
    UISwitch* improvedMapperSwitch;
}

- (instancetype) initWithSettingsPopupViewDelegate:(id<SettingsPopupViewDelegate>)delegate
{
    self = [super init];

    if (self) {
        _delegate = delegate;
        marginSize = 18.0;
        [self setupUIComponentsAndLayout];

        
        bool highResolutionColor =  [RrUserDefaults getBoolValueInUDWithKey:HighResolutionColor];
        bool irAutoExposure =  [RrUserDefaults getBoolValueInUDWithKey:IrAutoExposure];
        bool improvedTracker =  [RrUserDefaults getBoolValueInUDWithKey:ImprovedTracker];
        bool highResolutionMesh =  [RrUserDefaults getBoolValueInUDWithKey:HighResolutionMesh];
        bool improvedMapper =  [RrUserDefaults getBoolValueInUDWithKey:ImprovedMapper];
        
        NSInteger irManualExposureValue =  [RrUserDefaults getIntValueInUDWithKey:IrManualExposureValue];
        NSInteger irGainSegmentedIndex =  [RrUserDefaults getIntValueInUDWithKey:IrGainSegmentedIndex];
        NSInteger streamPresetSegmentedIndex =  [RrUserDefaults getIntValueInUDWithKey:StreamPresetSegmentedIndex];
        NSInteger trackerTypeSegmentedIndex =  [RrUserDefaults getIntValueInUDWithKey:TrackerTypeSegmentedIndex];
        NSInteger distanceSegmentedIndex =  [RrUserDefaults getIntValueInUDWithKey:DistanceSegmentedIndex];
        
        
        // Default option states
//        highResolutionColorSwitch.on = YES;
//
//        irAutoExposureSwitch.on = NO;
//        irManualExposureSlider.value = 14;
//        irManualExposureSlider.enabled = !irAutoExposureSwitch.on;
//
//        irGainSegmentedControl.selectedSegmentIndex = 3;
//        streamPresetSegmentedControl.selectedSegmentIndex = 0;
//        trackerTypeSegmentedControl.selectedSegmentIndex = 0;
//        improvedTrackerSwitch.on = YES;
//        highResolutionMeshSwitch.on = YES;
//        improvedMapperSwitch.on = YES;
        
        highResolutionColorSwitch.on = highResolutionColor;

        irAutoExposureSwitch.on = irAutoExposure;
        irManualExposureSlider.value = irManualExposureValue;
        irManualExposureSlider.enabled = !irAutoExposure;

        irGainSegmentedControl.selectedSegmentIndex = irGainSegmentedIndex;
        streamPresetSegmentedControl.selectedSegmentIndex = streamPresetSegmentedIndex;
        trackerTypeSegmentedControl.selectedSegmentIndex = trackerTypeSegmentedIndex;
        distanceSegmentedControl.selectedSegmentIndex = distanceSegmentedIndex;
        improvedTrackerSwitch.on = improvedTracker;
        highResolutionMeshSwitch.on = highResolutionMesh;
        improvedMapperSwitch.on = improvedMapper;
        
        
        
        [self addTouchResponders];

        // NOTE: sreamingSettingsDidChange should call streamingPropertiesDidChange
        [self streamingOptionsDidChange:self];
        [self trackerSettingsDidChange:self];
        [self mapperSettingsDidChange:self];
    }
    return self;
}

- (void) setupUIComponentsAndLayout
{
    // Attributes that apply to the whole content view
    self.backgroundColor = [UIColor whiteColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 8.0f;
    
    
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.clipsToBounds = YES;
    _contentView.layoutMargins = UIEdgeInsetsMake(marginSize, marginSize, marginSize, marginSize);
    [self addSubview:_contentView];

    [self addConstraints:@[// Pin top of _contentView to its superview
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_contentView.superview
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:0.0],
                           // Pin left of _contentView to its superview
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_contentView.superview
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:0.0],
                           // Pin bottom of _contentView to its superview
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_contentView.superview
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:0.0],
                           // Pin right of _contentView to its superview
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_contentView.superview
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0
                                                         constant:0.0],
                           // Make width of _contentView equal to its superview
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_contentView.superview
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1.0
                                                         constant:0.0]]];

    UILabel* streamingSettingsLabel = [[UILabel alloc] init];
    streamingSettingsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    streamingSettingsLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    streamingSettingsLabel.textColor = colorFromHexString(@"505053");
    streamingSettingsLabel.text = @"流设置";
    [_contentView addSubview:streamingSettingsLabel];
    
    [streamingSettingsLabel.superview
     addConstraints:@[// Pin top of streaming settings label to superview with offset
                      [NSLayoutConstraint constraintWithItem:streamingSettingsLabel
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:streamingSettingsLabel.superview
                                                   attribute:NSLayoutAttributeTopMargin
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin left of streaming settings label to superview with offset
                      [NSLayoutConstraint constraintWithItem:streamingSettingsLabel
                                                   attribute:NSLayoutAttributeLeading
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:streamingSettingsLabel.superview
                                                   attribute:NSLayoutAttributeLeadingMargin
                                                  multiplier:1.0
                                                    constant:0.0]]];
    
    UIView* hr1 = createHorizontalRule(1.0);
    hr1.backgroundColor = colorFromHexString(@"#979797");
    [_contentView addSubview:hr1];

    [hr1.superview
     addConstraints:@[// Pin top of hr1 to bottom of streaming settings label with offset
                      [NSLayoutConstraint constraintWithItem:hr1
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:streamingSettingsLabel
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:9.0],
                      // Pin leading edge of hr1 to superview
                      [NSLayoutConstraint constraintWithItem:hr1
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr1.superview
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Set width of hr1 to equal that of the superview
                      [NSLayoutConstraint constraintWithItem:hr1
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr1.superview
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]]];
    
    UIView* streamingSettingsView = [[UIView alloc] init];
    streamingSettingsView.translatesAutoresizingMaskIntoConstraints = NO;
    streamingSettingsView.backgroundColor = colorFromHexString(@"#F1F1F1");
    streamingSettingsView.layoutMargins = UIEdgeInsetsMake(marginSize, marginSize, marginSize, marginSize);
    [_contentView addSubview:streamingSettingsView];
    
    [streamingSettingsView.superview
     addConstraints:@[// Pin top of streamingSettingsView to bottom of hr1
                      [NSLayoutConstraint constraintWithItem:streamingSettingsView
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr1
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin leading edge of streaming settings view to superview
                      [NSLayoutConstraint constraintWithItem:streamingSettingsView
                                                   attribute:NSLayoutAttributeLeading
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:streamingSettingsView.superview
                                                   attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin trailing edge of streaming settings view to superview
                      [NSLayoutConstraint constraintWithItem:streamingSettingsView
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:streamingSettingsView.superview
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]]];

    // Streaming settings
    {
        UILabel* highResolutionColorLabel = [[UILabel alloc] init];
        highResolutionColorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        highResolutionColorLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        highResolutionColorLabel.textColor = colorFromHexString(@"3A3A3C");
        highResolutionColorLabel.text = @"高分辨率颜色";
        [streamingSettingsView addSubview:highResolutionColorLabel];
        
        [highResolutionColorLabel.superview
         addConstraints:@[// Pin top of high-res color label to top of superview with offset
                          [NSLayoutConstraint constraintWithItem:highResolutionColorLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionColorLabel.superview
                                                       attribute:NSLayoutAttributeTopMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin leading edge of high-res color label to superview with offset
                          [NSLayoutConstraint constraintWithItem:highResolutionColorLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionColorLabel.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        
        highResolutionColorSwitch = [[UISwitch alloc] init];
        highResolutionColorSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        highResolutionColorSwitch.userInteractionEnabled = YES;
        highResolutionColorSwitch.onTintColor = colorFromHexString(@"#00C3FF");
        [streamingSettingsView addSubview:highResolutionColorSwitch];
        
        [highResolutionColorSwitch.superview
         addConstraints:@[// Align centre Y of switch to centre Y of corresponding label
                          [NSLayoutConstraint constraintWithItem:highResolutionColorSwitch
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionColorLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin trailing edge of switch to trailing edge of superview
                          [NSLayoutConstraint constraintWithItem:highResolutionColorSwitch
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionColorSwitch.superview
                                                       attribute:NSLayoutAttributeTrailingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        
        UIView* streamingHR1 = createHorizontalRule(1.0);
        streamingHR1.backgroundColor = colorFromHexString(@"#979797");
        [streamingSettingsView addSubview:streamingHR1];
        
        [streamingHR1.superview
         addConstraints:@[// Pin top of hr1 to bottom of streaming settings label with offset
                          [NSLayoutConstraint constraintWithItem:streamingHR1
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionColorLabel
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of hr1 to superview
                          [NSLayoutConstraint constraintWithItem:streamingHR1
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR1.superview
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Set width of hr1 to equal that of 90% of the superview
                          [NSLayoutConstraint constraintWithItem:streamingHR1
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR1.superview
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:0.9
                                                        constant:0.0]]];
        
        UILabel* irAutoExposureLabel = [[UILabel alloc] init];
        irAutoExposureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        irAutoExposureLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        irAutoExposureLabel.textColor = colorFromHexString(@"#3A3A3C");
        irAutoExposureLabel.text = @"红外自动曝光（仅限Mark II）";
        [streamingSettingsView addSubview:irAutoExposureLabel];
        
        [irAutoExposureLabel.superview
         addConstraints:@[// Pin top of IR auto exposure label to bottom of horizontal rule 1 with offset
                          [NSLayoutConstraint constraintWithItem:irAutoExposureLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR1
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of IR auto exposure label to its superview's leading margin
                          [NSLayoutConstraint constraintWithItem:irAutoExposureLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irAutoExposureLabel.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        
        irAutoExposureSwitch = [[UISwitch alloc] init];
        irAutoExposureSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        irAutoExposureSwitch.userInteractionEnabled = YES;
        irAutoExposureSwitch.onTintColor = colorFromHexString(@"#00C3FF");
        [streamingSettingsView addSubview:irAutoExposureSwitch];
        
        [irAutoExposureSwitch.superview
         addConstraints:@[// Align centre Y of switch to centre Y of corresponding label
                          [NSLayoutConstraint constraintWithItem:irAutoExposureSwitch
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irAutoExposureLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin trailing edge of switch to trailing edge of superview
                          [NSLayoutConstraint constraintWithItem:irAutoExposureSwitch
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irAutoExposureSwitch.superview
                                                       attribute:NSLayoutAttributeTrailingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];

        UIView* streamingHR2 = createHorizontalRule(1.0);
        streamingHR2.backgroundColor = colorFromHexString(@"#979797");
        [streamingSettingsView addSubview:streamingHR2];

        [streamingHR2.superview
         addConstraints:@[// Pin top of streamingHR2 to bottom of streaming settings label with offset
                          [NSLayoutConstraint constraintWithItem:streamingHR2
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irAutoExposureLabel
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of streamingHR2 to superview
                          [NSLayoutConstraint constraintWithItem:streamingHR2
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR2.superview
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Set width of streamingHR2 to equal that of 90% of the superview
                          [NSLayoutConstraint constraintWithItem:streamingHR2
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR2.superview
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:0.9
                                                        constant:0.0]]];

        UILabel* irManualExposureLabel = [[UILabel alloc] init];
        irManualExposureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        irManualExposureLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        irManualExposureLabel.textColor = colorFromHexString(@"#3A3A3C");
        irManualExposureLabel.text = @"红外手动曝光（仅限Mark II）";
        [streamingSettingsView addSubview:irManualExposureLabel];

        [irManualExposureLabel.superview
         addConstraints:@[// Pin top of IR manual exposure label to bottom of horizontal rule 1 with offset
                          [NSLayoutConstraint constraintWithItem:irManualExposureLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR2
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of IR manual exposure label to its superview's leading margin
                          [NSLayoutConstraint constraintWithItem:irManualExposureLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irManualExposureLabel.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];

        irManualExposureSlider = [[UISlider alloc] init];
        irManualExposureSlider.translatesAutoresizingMaskIntoConstraints = NO;
        irManualExposureSlider.tintColor = colorFromHexString(@"#00C3FF");
        irManualExposureSlider.minimumValue = 1.0;
        irManualExposureSlider.maximumValue = 16.0;
        irManualExposureSlider.userInteractionEnabled = YES;
        [streamingSettingsView addSubview:irManualExposureSlider];

        UILabel* irExposureMinimumValueLabel = [[UILabel alloc] init];
        irExposureMinimumValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        irExposureMinimumValueLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        irExposureMinimumValueLabel.textColor = colorFromHexString(@"979797");
        irExposureMinimumValueLabel.text = @"1 ms";
        [streamingSettingsView addSubview:irExposureMinimumValueLabel];

        UILabel* irExposureMaximumValueLabel = [[UILabel alloc] init];
        irExposureMaximumValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        irExposureMaximumValueLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        irExposureMaximumValueLabel.textColor = colorFromHexString(@"979797");
        irExposureMaximumValueLabel.text = @"16 ms";
        [streamingSettingsView addSubview:irExposureMaximumValueLabel];
        
        [irManualExposureSlider.superview
         addConstraints:@[// Pin centre Y of IR exposure slider to bottom of IR exposure label with offset
                          [NSLayoutConstraint constraintWithItem:irManualExposureSlider
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irManualExposureLabel
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin centre Y of IR exposure min label to centre Y of IR exposure slider
                          [NSLayoutConstraint constraintWithItem:irExposureMinimumValueLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irManualExposureSlider
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin left edge of IR exposure min label to left margin of superview
                          [NSLayoutConstraint constraintWithItem:irExposureMinimumValueLabel
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irExposureMinimumValueLabel.superview
                                                       attribute:NSLayoutAttributeLeftMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin right edge of IR exposure min label to left edge of IR exposure slider with offset
                          [NSLayoutConstraint constraintWithItem:irManualExposureSlider
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irExposureMinimumValueLabel
                                                       attribute:NSLayoutAttributeRight
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin centre Y of IR exposure max label to centre Y of IR exposure slider
                          [NSLayoutConstraint constraintWithItem:irExposureMaximumValueLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irManualExposureSlider
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin right edge of IR exposure max label to right margin of superview
                          [NSLayoutConstraint constraintWithItem:irExposureMaximumValueLabel
                                                       attribute:NSLayoutAttributeRight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irExposureMaximumValueLabel.superview
                                                       attribute:NSLayoutAttributeRightMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin left edge of IR max exposure to right edge of IR exposure slider with offset
                          [NSLayoutConstraint constraintWithItem:irExposureMaximumValueLabel
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irManualExposureSlider
                                                       attribute:NSLayoutAttributeRight
                                                      multiplier:1.0
                                                        constant:marginSize]]];
        
        UIView* streamingHR3 = createHorizontalRule(1.0);
        streamingHR3.backgroundColor = colorFromHexString(@"#979797");
        [streamingSettingsView addSubview:streamingHR3];

        [streamingHR3.superview
         addConstraints:@[// Pin top of HR2 to bottom of streaming settings label with offset
                          [NSLayoutConstraint constraintWithItem:streamingHR3
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irManualExposureSlider
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of HR2 to superview
                          [NSLayoutConstraint constraintWithItem:streamingHR3
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR3.superview
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Set width of HR2 to equal that of 90% of the superview
                          [NSLayoutConstraint constraintWithItem:streamingHR3
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR3.superview
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:0.9
                                                        constant:0.0]]];
        
        UILabel* irGainLabel = [[UILabel alloc] init];
        irGainLabel.translatesAutoresizingMaskIntoConstraints = NO;
        irGainLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        irGainLabel.textColor = colorFromHexString(@"3A3A3C");
//        irGainLabel.text = @"IR Analog Gain (Mark II only)";
        irGainLabel.text = @"红外模拟增强（仅限Mark II）";
        [streamingSettingsView addSubview:irGainLabel];

        [irGainLabel.superview
         addConstraints:@[// Pin top of IR gain label to bottom of horizontal rule 2 with offset
                          [NSLayoutConstraint constraintWithItem:irGainLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR3
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of IR gain label to its superview's leading margin
                          [NSLayoutConstraint constraintWithItem:irGainLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irGainLabel.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];

        irGainSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1x", @"2x", @"4x", @"8x"]];
        irGainSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        irGainSegmentedControl.clipsToBounds = YES;
        irGainSegmentedControl.userInteractionEnabled = YES;
        irGainSegmentedControl.backgroundColor = colorFromHexString(@"#D2D2D2");
        irGainSegmentedControl.tintColor = colorFromHexString(@"#00C3FF");
        [irGainSegmentedControl setTitleTextAttributes:@{
                                                         NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium],
                                                         NSForegroundColorAttributeName: colorFromHexString(@"#505053")
                                                         }
                                              forState:UIControlStateNormal];
        [irGainSegmentedControl setTitleTextAttributes:@{
                                                         NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium],
                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                                         }
                                              forState:UIControlStateSelected];
        [irGainSegmentedControl setBackgroundImage:imageWithColor(colorFromHexString(@"#DEDEDE"), CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                          forState:UIControlStateNormal
                                        barMetrics:UIBarMetricsDefault];
        [irGainSegmentedControl setBackgroundImage:imageWithColor(colorFromHexString(@"#00C3FF"), CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                          forState:UIControlStateSelected
                                        barMetrics:UIBarMetricsDefault];
        [irGainSegmentedControl setDividerImage:imageWithColor([UIColor clearColor], CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                            forLeftSegmentState:UIControlStateNormal
                              rightSegmentState:UIControlStateNormal
                                     barMetrics:UIBarMetricsDefault];
        [irGainSegmentedControl setDividerImage:imageWithColor([UIColor clearColor], CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                            forLeftSegmentState:UIControlStateNormal
                              rightSegmentState:UIControlStateSelected
                                     barMetrics:UIBarMetricsDefault];
        irGainSegmentedControl.layer.cornerRadius = 8.0f;
        [streamingSettingsView addSubview:irGainSegmentedControl];

        [irGainSegmentedControl.superview
         addConstraints:@[// Pin top of IR gain control to bottom of IR gain label with offset
                          [NSLayoutConstraint constraintWithItem:irGainSegmentedControl
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irGainLabel
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of IR gain control to leading margin of superview
                          [NSLayoutConstraint constraintWithItem:irGainSegmentedControl
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irGainSegmentedControl.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin trailing edge of IR gain control to trailing margin of superview
                          [NSLayoutConstraint constraintWithItem:irGainSegmentedControl
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irGainSegmentedControl.superview
                                                       attribute:NSLayoutAttributeTrailingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        
        UIView* streamingHR4 = createHorizontalRule(1.0);
        streamingHR4.backgroundColor = colorFromHexString(@"#979797");
        [streamingSettingsView addSubview:streamingHR4];
        
        [streamingHR4.superview
         addConstraints:@[// Pin top of HR3 to bottom of streaming settings label with offset
                          [NSLayoutConstraint constraintWithItem:streamingHR4
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:irGainSegmentedControl
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of HR3 to superview
                          [NSLayoutConstraint constraintWithItem:streamingHR4
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR4.superview
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Set width of HR3 to equal that of 90% of the superview
                          [NSLayoutConstraint constraintWithItem:streamingHR4
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR4.superview
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:0.9
                                                        constant:0.0]]];
        
        UILabel* streamPresetLabel = [[UILabel alloc] init];
        streamPresetLabel.translatesAutoresizingMaskIntoConstraints = NO;
        streamPresetLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        streamPresetLabel.textColor = colorFromHexString(@"3A3A3C");
        streamPresetLabel.text = @"深度流设置（仅限Mark II）";
        [streamingSettingsView addSubview:streamPresetLabel];
        
        [streamPresetLabel.superview
         addConstraints:@[// Pin top of depth stream preset label to bottom of horizontal rule 3 with offset
                          [NSLayoutConstraint constraintWithItem:streamPresetLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR4
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of depth stream preset label to its superview's leading margin
                          [NSLayoutConstraint constraintWithItem:streamPresetLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamPresetLabel.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
    
        streamPresetSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"默认", @"身体", @"户外"]];
        streamPresetSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        streamPresetSegmentedControl.clipsToBounds = YES;
        streamPresetSegmentedControl.userInteractionEnabled = YES;
        streamPresetSegmentedControl.backgroundColor = colorFromHexString(@"#D2D2D2");
        streamPresetSegmentedControl.tintColor = colorFromHexString(@"#00C3FF");
        [streamPresetSegmentedControl setTitleTextAttributes:@{
                                                               NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium],
                                                               NSForegroundColorAttributeName: colorFromHexString(@"#505053")
                                                               }
                                                    forState:UIControlStateNormal];
        [streamPresetSegmentedControl setTitleTextAttributes:@{
                                                               NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium],
                                                               NSForegroundColorAttributeName: [UIColor whiteColor]
                                                               }
                                                    forState:UIControlStateSelected];
        [streamPresetSegmentedControl setBackgroundImage:imageWithColor(colorFromHexString(@"#DEDEDE"), CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        [streamPresetSegmentedControl setBackgroundImage:imageWithColor(colorFromHexString(@"#00C3FF"), CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                                forState:UIControlStateSelected
                                              barMetrics:UIBarMetricsDefault];
        [streamPresetSegmentedControl setDividerImage:imageWithColor([UIColor clearColor], CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                  forLeftSegmentState:UIControlStateNormal
                                    rightSegmentState:UIControlStateNormal
                                           barMetrics:UIBarMetricsDefault];
        [streamPresetSegmentedControl setDividerImage:imageWithColor([UIColor clearColor], CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                  forLeftSegmentState:UIControlStateNormal
                                    rightSegmentState:UIControlStateSelected
                                           barMetrics:UIBarMetricsDefault];
        streamPresetSegmentedControl.layer.cornerRadius = 8.0f;
        [streamingSettingsView addSubview:streamPresetSegmentedControl];

        [streamPresetSegmentedControl.superview
         addConstraints:@[// Pin top of IR gain control to bottom of IR gain label with offset
                          [NSLayoutConstraint constraintWithItem:streamPresetSegmentedControl
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamPresetLabel
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of IR gain control to leading margin of superview
                          [NSLayoutConstraint constraintWithItem:streamPresetSegmentedControl
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamPresetSegmentedControl.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin trailing edge of IR gain control to trailing margin of superview
                          [NSLayoutConstraint constraintWithItem:streamPresetSegmentedControl
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamPresetSegmentedControl.superview
                                                       attribute:NSLayoutAttributeTrailingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        // Pin bottom edge of stream preset control to bottom margin of superview
//        [NSLayoutConstraint constraintWithItem:streamPresetSegmentedControl
//                                     attribute:NSLayoutAttributeBottom
//                                     relatedBy:NSLayoutRelationEqual
//                                        toItem:streamPresetSegmentedControl.superview
//                                     attribute:NSLayoutAttributeBottomMargin
//                                    multiplier:1.0
//                                      constant:0.0]
        
        
     
        //距离设置
        UIView* streamingHR5 = createHorizontalRule(1.0);
        streamingHR5.backgroundColor = colorFromHexString(@"#979797");
        [streamingSettingsView addSubview:streamingHR5];

        [streamingHR5.superview
         addConstraints:@[// Pin top of streamingHR2 to bottom of streaming settings label with offset
                          [NSLayoutConstraint constraintWithItem:streamingHR5
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamPresetSegmentedControl
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of streamingHR2 to superview
                          [NSLayoutConstraint constraintWithItem:streamingHR5
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR5.superview
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Set width of streamingHR2 to equal that of 90% of the superview
                          [NSLayoutConstraint constraintWithItem:streamingHR5
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:streamingHR5.superview
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:0.9
                                                        constant:0.0]]];

        UILabel* distanceLabel = [[UILabel alloc] init];
            distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
            distanceLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
            distanceLabel.textColor = colorFromHexString(@"3A3A3C");
            distanceLabel.text = @"扫码距离设置(cm)";
            [streamingSettingsView addSubview:distanceLabel];
            
            [distanceLabel.superview
             addConstraints:@[// Pin top of depth stream preset label to bottom of horizontal rule 3 with offset
                              [NSLayoutConstraint constraintWithItem:distanceLabel
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:streamingHR5
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:marginSize],
                              // Pin leading edge of depth stream preset label to its superview's leading margin
                              [NSLayoutConstraint constraintWithItem:distanceLabel
                                                           attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:distanceLabel.superview
                                                           attribute:NSLayoutAttributeLeadingMargin
                                                          multiplier:1.0
                                                            constant:0.0]]];
        
            distanceSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"40", @"50", @"60",@"70", @"80", @"90"]];
            distanceSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
            distanceSegmentedControl.clipsToBounds = YES;
            distanceSegmentedControl.userInteractionEnabled = YES;
            distanceSegmentedControl.backgroundColor = colorFromHexString(@"#D2D2D2");
            distanceSegmentedControl.tintColor = colorFromHexString(@"#00C3FF");
            [distanceSegmentedControl setTitleTextAttributes:@{
                                                                   NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium],
                                                                   NSForegroundColorAttributeName: colorFromHexString(@"#505053")
                                                                   }
                                                        forState:UIControlStateNormal];
            [distanceSegmentedControl setTitleTextAttributes:@{
                                                                   NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium],
                                                                   NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                   }
                                                        forState:UIControlStateSelected];
            [distanceSegmentedControl setBackgroundImage:imageWithColor(colorFromHexString(@"#DEDEDE"), CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                                    forState:UIControlStateNormal
                                                  barMetrics:UIBarMetricsDefault];
            [distanceSegmentedControl setBackgroundImage:imageWithColor(colorFromHexString(@"#00C3FF"), CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                                    forState:UIControlStateSelected
                                                  barMetrics:UIBarMetricsDefault];
            [distanceSegmentedControl setDividerImage:imageWithColor([UIColor clearColor], CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                      forLeftSegmentState:UIControlStateNormal
                                        rightSegmentState:UIControlStateNormal
                                               barMetrics:UIBarMetricsDefault];
            [distanceSegmentedControl setDividerImage:imageWithColor([UIColor clearColor], CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                      forLeftSegmentState:UIControlStateNormal
                                        rightSegmentState:UIControlStateSelected
                                               barMetrics:UIBarMetricsDefault];
            distanceSegmentedControl.layer.cornerRadius = 8.0f;
            [streamingSettingsView addSubview:distanceSegmentedControl];

            [distanceSegmentedControl.superview
             addConstraints:@[// Pin top of IR gain control to bottom of IR gain label with offset
                              [NSLayoutConstraint constraintWithItem:distanceSegmentedControl
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:distanceLabel
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:marginSize],
                              // Pin leading edge of IR gain control to leading margin of superview
                              [NSLayoutConstraint constraintWithItem:distanceSegmentedControl
                                                           attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:distanceSegmentedControl.superview
                                                           attribute:NSLayoutAttributeLeadingMargin
                                                          multiplier:1.0
                                                            constant:0.0],
                              // Pin trailing edge of IR gain control to trailing margin of superview
                              [NSLayoutConstraint constraintWithItem:distanceSegmentedControl
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:distanceSegmentedControl.superview
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                          multiplier:1.0
                                                            constant:0.0],
                             // Pin bottom edge of stream preset control to bottom margin of superview
                              [NSLayoutConstraint constraintWithItem:distanceSegmentedControl
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:distanceSegmentedControl.superview
                                                           attribute:NSLayoutAttributeBottomMargin
                                                          multiplier:1.0
                                                            constant:0.0]]];
        
    }
    
    
    

    UIView* hr2 = createHorizontalRule(1.0);
    hr2.backgroundColor = colorFromHexString(@"#979797");
    [_contentView addSubview:hr2];
    
    [hr2.superview
     addConstraints:@[// Pin top of hr1 to bottom of streaming settings label with offset
                      [NSLayoutConstraint constraintWithItem:hr2
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:streamingSettingsView
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin leading edge of hr1 to superview
                      [NSLayoutConstraint constraintWithItem:hr2
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr2.superview
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Set width of hr1 to equal that of the superview
                      [NSLayoutConstraint constraintWithItem:hr2
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr2.superview
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]]];

    UILabel* trackerSettingsLabel = [[UILabel alloc] init];
    trackerSettingsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    trackerSettingsLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    trackerSettingsLabel.textColor = colorFromHexString(@"505053");
    trackerSettingsLabel.text = @"跟踪器设置";
    [_contentView addSubview:trackerSettingsLabel];
    
    [trackerSettingsLabel.superview
     addConstraints:@[// Pin top of tracker settings label to hr2 with offset
                      [NSLayoutConstraint constraintWithItem:trackerSettingsLabel
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr2
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:marginSize],
                      // Pin left of tracker settings label to superview with offset
                      [NSLayoutConstraint constraintWithItem:trackerSettingsLabel
                                                   attribute:NSLayoutAttributeLeading
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:trackerSettingsLabel.superview
                                                   attribute:NSLayoutAttributeLeadingMargin
                                                  multiplier:1.0
                                                    constant:0.0]]];
    
    UIView* hr3 = createHorizontalRule(1.0);
    hr3.backgroundColor = colorFromHexString(@"#979797");
    [_contentView addSubview:hr3];
    
    [hr3.superview
     addConstraints:@[// Pin top of hr1 to bottom of streaming settings label with offset
                      [NSLayoutConstraint constraintWithItem:hr3
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:trackerSettingsLabel
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:9.0],
                      // Pin leading edge of hr1 to superview
                      [NSLayoutConstraint constraintWithItem:hr3
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr3.superview
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Set width of hr1 to equal that of the superview
                      [NSLayoutConstraint constraintWithItem:hr3
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr3.superview
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]]];
    
    UIView* trackerSettingsView = [[UIView alloc] init];
    trackerSettingsView.translatesAutoresizingMaskIntoConstraints = NO;
    trackerSettingsView.backgroundColor = colorFromHexString(@"#F1F1F1");
    trackerSettingsView.layoutMargins = UIEdgeInsetsMake(marginSize, marginSize, marginSize, marginSize);
    [_contentView addSubview:trackerSettingsView];
    
    [trackerSettingsView.superview
     addConstraints:@[// Pin top of tracker settings view to bottom of hr3
                      [NSLayoutConstraint constraintWithItem:trackerSettingsView
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr3
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin leading edge of tracker settings view to superview
                      [NSLayoutConstraint constraintWithItem:trackerSettingsView
                                                   attribute:NSLayoutAttributeLeading
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:trackerSettingsView.superview
                                                   attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin trailing edge of tracker settings view to superview
                      [NSLayoutConstraint constraintWithItem:trackerSettingsView
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:trackerSettingsView.superview
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]]];

    // Tracker Settings
    {
        UILabel* trackerTypeLabel = [[UILabel alloc] init];
        trackerTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        trackerTypeLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        trackerTypeLabel.textColor = colorFromHexString(@"3A3A3C");
        trackerTypeLabel.text = @"跟踪器类型";
        [trackerSettingsView addSubview:trackerTypeLabel];
        
        [trackerTypeLabel.superview
         addConstraints:@[// Pin top of high-res color label to top of superview with offset
                          [NSLayoutConstraint constraintWithItem:trackerTypeLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:trackerTypeLabel.superview
                                                       attribute:NSLayoutAttributeTopMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin leading edge of high-res color label to superview with offset
                          [NSLayoutConstraint constraintWithItem:trackerTypeLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:trackerTypeLabel.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        
        trackerTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Color + Depth", @"Depth Only"]];
        trackerTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        trackerTypeSegmentedControl.clipsToBounds = YES;
        trackerTypeSegmentedControl.userInteractionEnabled = YES;
        trackerTypeSegmentedControl.backgroundColor = colorFromHexString(@"#D2D2D2");
        trackerTypeSegmentedControl.tintColor = colorFromHexString(@"#00C3FF");
        [trackerTypeSegmentedControl setTitleTextAttributes:@{
                                                         NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium],
                                                         NSForegroundColorAttributeName: colorFromHexString(@"#505053")
                                                         }
                                              forState:UIControlStateNormal];
        [trackerTypeSegmentedControl setTitleTextAttributes:@{
                                                         NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium],
                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                                         }
                                              forState:UIControlStateSelected];
        [trackerTypeSegmentedControl setBackgroundImage:imageWithColor(colorFromHexString(@"#DEDEDE"), CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                          forState:UIControlStateNormal
                                        barMetrics:UIBarMetricsDefault];
        [trackerTypeSegmentedControl setBackgroundImage:imageWithColor(colorFromHexString(@"#00C3FF"), CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                                          forState:UIControlStateSelected
                                        barMetrics:UIBarMetricsDefault];
        [trackerTypeSegmentedControl setDividerImage:imageWithColor([UIColor clearColor], CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                            forLeftSegmentState:UIControlStateNormal
                              rightSegmentState:UIControlStateNormal
                                     barMetrics:UIBarMetricsDefault];
        [trackerTypeSegmentedControl setDividerImage:imageWithColor([UIColor clearColor], CGRectMake(0.0, 0.0, 1.0, 30.0), 0.0)
                            forLeftSegmentState:UIControlStateNormal
                              rightSegmentState:UIControlStateSelected
                                     barMetrics:UIBarMetricsDefault];
        trackerTypeSegmentedControl.layer.cornerRadius = 8.0f;
        [trackerSettingsView addSubview:trackerTypeSegmentedControl];
        
        [trackerTypeSegmentedControl.superview
         addConstraints:@[// Pin top of IR gain control to bottom of IR gain label with offset
                          [NSLayoutConstraint constraintWithItem:trackerTypeSegmentedControl
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:trackerTypeLabel
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of IR gain control to leading margin of superview
                          [NSLayoutConstraint constraintWithItem:trackerTypeSegmentedControl
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:trackerTypeSegmentedControl.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin trailing edge of IR gain control to trailing margin of superview
                          [NSLayoutConstraint constraintWithItem:trackerTypeSegmentedControl
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:trackerTypeSegmentedControl.superview
                                                       attribute:NSLayoutAttributeTrailingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        
        UIView* trackerHR1 = createHorizontalRule(1.0);
        trackerHR1.backgroundColor = colorFromHexString(@"#979797");
        [trackerSettingsView addSubview:trackerHR1];
        
        [trackerHR1.superview
         addConstraints:@[// Pin top of trackerHR1 to bottom of streaming settings label with offset
                          [NSLayoutConstraint constraintWithItem:trackerHR1
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:trackerTypeSegmentedControl
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of trackerHR1 to superview
                          [NSLayoutConstraint constraintWithItem:trackerHR1
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:trackerHR1.superview
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Set width of trackerHR1 to equal that of 90% of the superview
                          [NSLayoutConstraint constraintWithItem:trackerHR1
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:trackerHR1.superview
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:0.9
                                                        constant:0.0]]];
        
        UILabel* improvedTrackerLabel = [[UILabel alloc] init];
        improvedTrackerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        improvedTrackerLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        improvedTrackerLabel.textColor = colorFromHexString(@"3A3A3C");
        improvedTrackerLabel.text = @"增强跟踪器（SDK 0.8+）";
        [trackerSettingsView addSubview:improvedTrackerLabel];
        
        [improvedTrackerLabel.superview
         addConstraints:@[// Pin top of high-res color label to top of superview with offset
                          [NSLayoutConstraint constraintWithItem:improvedTrackerLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:trackerHR1
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of high-res color label to superview with offset
                          [NSLayoutConstraint constraintWithItem:improvedTrackerLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:improvedTrackerLabel.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin improved tracker label bottom to bottom of superview margin
                          [NSLayoutConstraint constraintWithItem:improvedTrackerLabel
                                                       attribute:NSLayoutAttributeBottom
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:improvedTrackerLabel.superview
                                                       attribute:NSLayoutAttributeBottomMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];

        improvedTrackerSwitch = [[UISwitch alloc] init];
        improvedTrackerSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        improvedTrackerSwitch.userInteractionEnabled = YES;
        improvedTrackerSwitch.onTintColor = colorFromHexString(@"#00C3FF");
        [trackerSettingsView addSubview:improvedTrackerSwitch];
        
        [improvedTrackerSwitch.superview
         addConstraints:@[// Align centre Y of switch to centre Y of corresponding label
                          [NSLayoutConstraint constraintWithItem:improvedTrackerSwitch
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:improvedTrackerLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin trailing edge of switch to trailing edge of superview
                          [NSLayoutConstraint constraintWithItem:improvedTrackerSwitch
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:improvedTrackerSwitch.superview
                                                       attribute:NSLayoutAttributeTrailingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
    }
    
    UIView* hr4 = createHorizontalRule(1.0);
    hr4.backgroundColor = colorFromHexString(@"#979797");
    [_contentView addSubview:hr4];
    
    [hr4.superview
     addConstraints:@[// Pin top of hr1 to bottom of streaming settings label with offset
                      [NSLayoutConstraint constraintWithItem:hr4
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:trackerSettingsView
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin leading edge of hr1 to superview
                      [NSLayoutConstraint constraintWithItem:hr4
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr4.superview
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Set width of hr1 to equal that of the superview
                      [NSLayoutConstraint constraintWithItem:hr4
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr4.superview
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]]];

    UILabel* mapperSettingsLabel = [[UILabel alloc] init];
    mapperSettingsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    mapperSettingsLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    mapperSettingsLabel.textColor = colorFromHexString(@"505053");
    mapperSettingsLabel.text = @"映射器设置";
    [_contentView addSubview:mapperSettingsLabel];
    
    [mapperSettingsLabel.superview
     addConstraints:@[// Pin top of mapper settings label to hr4 with offset
                      [NSLayoutConstraint constraintWithItem:mapperSettingsLabel
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr4
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:marginSize],
                      // Pin left of mapper settings label to superview with offset
                      [NSLayoutConstraint constraintWithItem:mapperSettingsLabel
                                                   attribute:NSLayoutAttributeLeading
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:mapperSettingsLabel.superview
                                                   attribute:NSLayoutAttributeLeadingMargin
                                                  multiplier:1.0
                                                    constant:0.0]]];

    UIView* hr5 = createHorizontalRule(1.0);
    hr5.backgroundColor = colorFromHexString(@"#979797");
    [_contentView addSubview:hr5];
    
    [hr5.superview
     addConstraints:@[// Pin top of hr1 to bottom of streaming settings label with offset
                      [NSLayoutConstraint constraintWithItem:hr5
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:mapperSettingsLabel
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:9.0],
                      // Pin leading edge of hr1 to superview
                      [NSLayoutConstraint constraintWithItem:hr5
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr5.superview
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Set width of hr1 to equal that of the superview
                      [NSLayoutConstraint constraintWithItem:hr5
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr5.superview
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]]];
    
    UIView* mapperSettingsView = [[UIView alloc] init];
    mapperSettingsView.translatesAutoresizingMaskIntoConstraints = NO;
    mapperSettingsView.backgroundColor = colorFromHexString(@"#F1F1F1");
    mapperSettingsView.layoutMargins = UIEdgeInsetsMake(marginSize, marginSize, marginSize, marginSize);
    [_contentView addSubview:mapperSettingsView];
    
    [trackerSettingsView.superview
     addConstraints:@[// Pin top of tracker settings view to bottom of hr5
                      [NSLayoutConstraint constraintWithItem:mapperSettingsView
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr5
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin leading edge of tracker settings view to superview
                      [NSLayoutConstraint constraintWithItem:mapperSettingsView
                                                   attribute:NSLayoutAttributeLeading
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:mapperSettingsView.superview
                                                   attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin trailing edge of tracker settings view to superview
                      [NSLayoutConstraint constraintWithItem:mapperSettingsView
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:mapperSettingsView.superview
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]]];
    
    // Mapper Settings
    {
        UILabel* highResolutionMeshLabel = [[UILabel alloc] init];
        highResolutionMeshLabel.translatesAutoresizingMaskIntoConstraints = NO;
        highResolutionMeshLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        highResolutionMeshLabel.textColor = colorFromHexString(@"3A3A3C");
        highResolutionMeshLabel.text = @"高分辨率网格";
        [mapperSettingsView addSubview:highResolutionMeshLabel];
        
        [highResolutionMeshLabel.superview
         addConstraints:@[// Pin top of high-res mesh label to top of superview with offset
                          [NSLayoutConstraint constraintWithItem:highResolutionMeshLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionMeshLabel.superview
                                                       attribute:NSLayoutAttributeTopMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin leading edge of high-res mesh label to superview with offset
                          [NSLayoutConstraint constraintWithItem:highResolutionMeshLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionMeshLabel.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        
        highResolutionMeshSwitch = [[UISwitch alloc] init];
        highResolutionMeshSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        highResolutionMeshSwitch.userInteractionEnabled = YES;
        highResolutionMeshSwitch.onTintColor = colorFromHexString(@"#00C3FF");
        [mapperSettingsView addSubview:highResolutionMeshSwitch];
        
        [highResolutionMeshSwitch.superview
         addConstraints:@[// Align centre Y of switch to centre Y of corresponding label
                          [NSLayoutConstraint constraintWithItem:highResolutionMeshSwitch
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionMeshLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin trailing edge of switch to trailing edge of superview
                          [NSLayoutConstraint constraintWithItem:highResolutionMeshSwitch
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionMeshSwitch.superview
                                                       attribute:NSLayoutAttributeTrailingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        
        UIView* mapperHR1 = createHorizontalRule(1.0);
        mapperHR1.backgroundColor = colorFromHexString(@"#979797");
        [mapperSettingsView addSubview:mapperHR1];
        
        [mapperHR1.superview
         addConstraints:@[// Pin top of mapperHR1 to bottom of streaming settings label with offset
                          [NSLayoutConstraint constraintWithItem:mapperHR1
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:highResolutionMeshLabel
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of mapperHR1 to superview
                          [NSLayoutConstraint constraintWithItem:mapperHR1
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:mapperHR1.superview
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Set width of mapperHR1 to equal that of 90% of the superview
                          [NSLayoutConstraint constraintWithItem:mapperHR1
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:mapperHR1.superview
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:0.9
                                                        constant:0.0]]];

        UILabel* improvedMapperLabel = [[UILabel alloc] init];
        improvedMapperLabel.translatesAutoresizingMaskIntoConstraints = NO;
        improvedMapperLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        improvedMapperLabel.textColor = colorFromHexString(@"3A3A3C");
        improvedMapperLabel.text = @"增强映射器";
        [mapperSettingsView addSubview:improvedMapperLabel];
        
        [improvedMapperLabel.superview
         addConstraints:@[// Pin top of improved mapper label to top of superview with offset
                          [NSLayoutConstraint constraintWithItem:improvedMapperLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:mapperHR1
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:marginSize],
                          // Pin leading edge of improved mapper label to superview with offset
                          [NSLayoutConstraint constraintWithItem:improvedMapperLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:improvedMapperLabel.superview
                                                       attribute:NSLayoutAttributeLeadingMargin
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin bottom edge of improved mapper label to bottom superview margin
                          [NSLayoutConstraint constraintWithItem:improvedMapperLabel
                                                       attribute:NSLayoutAttributeBottom
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:improvedMapperLabel.superview
                                                       attribute:NSLayoutAttributeBottomMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
        
        improvedMapperSwitch = [[UISwitch alloc] init];
        improvedMapperSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        improvedMapperSwitch.userInteractionEnabled = YES;
        improvedMapperSwitch.onTintColor = colorFromHexString(@"#00C3FF");
        [mapperSettingsView addSubview:improvedMapperSwitch];
        
        [improvedMapperSwitch.superview
         addConstraints:@[// Align centre Y of switch to centre Y of corresponding label
                          [NSLayoutConstraint constraintWithItem:improvedMapperSwitch
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:improvedMapperLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0],
                          // Pin trailing edge of switch to trailing edge of superview
                          [NSLayoutConstraint constraintWithItem:improvedMapperSwitch
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:improvedMapperSwitch.superview
                                                       attribute:NSLayoutAttributeTrailingMargin
                                                      multiplier:1.0
                                                        constant:0.0]]];
    }
    
    UIView* hr6 = createHorizontalRule(1.0);
    hr6.backgroundColor = colorFromHexString(@"#979797");
    [_contentView addSubview:hr6];

    [hr6.superview
     addConstraints:@[// Pin top of hr6 to bottom of streaming settings label with offset
                      [NSLayoutConstraint constraintWithItem:hr6
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:mapperSettingsView
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Pin leading edge of hr6 to superview
                      [NSLayoutConstraint constraintWithItem:hr6
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr6.superview
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:0.0],
                      // Set width of hr6 to equal that of the superview
                      [NSLayoutConstraint constraintWithItem:hr6
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:hr6.superview
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:0.0]]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:hr6
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeBottomMargin
                                                            multiplier:1.0
                                                              constant:0.0]];
}

- (void) addTouchResponders
{
    [highResolutionColorSwitch addTarget:self
                                  action:@selector(streamingOptionsDidChange:)
                        forControlEvents:UIControlEventValueChanged];

    [irAutoExposureSwitch addTarget:self
                             action:@selector(streamingPropertiesDidChange:)
                   forControlEvents:UIControlEventValueChanged];

    [irManualExposureSlider addTarget:self
                               action:@selector(streamingPropertiesDidChange:)
                     forControlEvents:UIControlEventTouchUpInside];

    [irGainSegmentedControl addTarget:self
                               action:@selector(streamingPropertiesDidChange:)
                     forControlEvents:UIControlEventValueChanged];

    [streamPresetSegmentedControl addTarget:self
                                     action:@selector(streamingOptionsDidChange:)
                           forControlEvents:UIControlEventValueChanged];
    
    [distanceSegmentedControl addTarget:self
              action:@selector(distanceSegmentedDidChange:)
                           forControlEvents:UIControlEventValueChanged];

    [trackerTypeSegmentedControl addTarget:self
                                    action:@selector(trackerSettingsDidChange:)
                          forControlEvents:UIControlEventValueChanged];

    [improvedTrackerSwitch addTarget:self
                              action:@selector(trackerSettingsDidChange:)
                    forControlEvents:UIControlEventValueChanged];

    [highResolutionMeshSwitch addTarget:self
                                 action:@selector(mapperSettingsDidChange:)
                       forControlEvents:UIControlEventValueChanged];

    [improvedMapperSwitch addTarget:self
                             action:@selector(mapperSettingsDidChange:)
                   forControlEvents:UIControlEventValueChanged];

}

- (void) streamingOptionsDidChange:(id)sender
{
    
    STCaptureSessionPreset presetMode = STCaptureSessionPresetDefault;
    [RrUserDefaults saveIntValueInUD:streamPresetSegmentedControl.selectedSegmentIndex forKey:StreamPresetSegmentedIndex];
    switch (streamPresetSegmentedControl.selectedSegmentIndex)
    {
        case 0:
            presetMode = STCaptureSessionPresetDefault;
            break;
        case 1:
            presetMode = STCaptureSessionPresetBodyScanning;
            break;
        case 2:
            presetMode = STCaptureSessionPresetOutdoor;
            break;
        default:
            @throw [NSException exceptionWithName:@"SettingsPopupView"
                                           reason:@"Unknown index found on preset setting."
                                         userInfo:nil];
            break;
    }

    if (!_delegate) return;
    [_delegate streamingSettingsDidChange:highResolutionColorSwitch.on
                    depthStreamPresetMode:presetMode];

    // NOTE: Everytime we restart streaming we should re-apply the properties.
    // The exposure / gain settings that are default to a preset will get reset
    // if the STCaptureSession stream config is reset as well, so we want to re-apply
    // these every time we restart streaming for consistency's sake.
    [self streamingPropertiesDidChange:sender];
}

- (void) distanceSegmentedDidChange:(id)sender
{
    int distanceValue = 50;
    switch (distanceSegmentedControl.selectedSegmentIndex)
    {
        case 0:
            distanceValue = 40;
            break;
        case 1:
            distanceValue = 50;
            break;
        case 2:
            distanceValue = 60;
            break;
        case 3:
            distanceValue = 70;
            break;
        case 4:
            distanceValue = 80;
            break;
        case 5:
            distanceValue = 90;
            break;
        default:
            @throw [NSException exceptionWithName:@"SettingsPopupView"
                                           reason:@"Unknown index found on preset setting."
                                         userInfo:nil];
            break;
    }

    [RrUserDefaults saveIntValueInUD:distanceSegmentedControl.selectedSegmentIndex forKey:DistanceSegmentedIndex];
    
    if (!_delegate) return;
    [_delegate distanceDidChange:distanceValue];

    // NOTE: Everytime we restart streaming we should re-apply the properties.
    // The exposure / gain settings that are default to a preset will get reset
    // if the STCaptureSession stream config is reset as well, so we want to re-apply
    // these every time we restart streaming for consistency's sake.
//    [self distanceSegmentedDidChange:sender];
}

- (void) streamingPropertiesDidChange:(id)sender
{
    // Disable manual exposure if the IR AutoExposureSwitch is on
    irManualExposureSlider.enabled = !irAutoExposureSwitch.on;
    irManualExposureSlider.tintColor = (irManualExposureSlider.enabled ?
                                        colorFromHexString(@"#00C3FF") : colorFromHexString(@"#979797"));
    
    STCaptureSessionSensorAnalogGainMode gainMode = STCaptureSessionSensorAnalogGainMode8_0;
    [RrUserDefaults saveIntValueInUD:irGainSegmentedControl.selectedSegmentIndex forKey:IrGainSegmentedIndex];
    switch (irGainSegmentedControl.selectedSegmentIndex)
    {
        case 0:
            gainMode = STCaptureSessionSensorAnalogGainMode1_0;
            break;
        case 1:
            gainMode = STCaptureSessionSensorAnalogGainMode2_0;
            break;
        case 2:
            gainMode = STCaptureSessionSensorAnalogGainMode4_0;
            break;
        case 3:
            gainMode = STCaptureSessionSensorAnalogGainMode8_0;
            break;
        default:
            @throw [NSException exceptionWithName:@"SettingsPopupView"
                                           reason:@"Unknown index found on gain setting."
                                         userInfo:nil];
            break;
    }
    
    if (!_delegate) return;

    [RrUserDefaults saveIntValueInUD:irManualExposureSlider.value forKey:IrManualExposureValue];
    [_delegate streamingPropertiesDidChange:irAutoExposureSwitch.on
                      irManualExposureValue:irManualExposureSlider.value / 1000 // send value in seconds
                          irAnalogGainValue:gainMode];
}

- (void) trackerSettingsDidChange:(id)sender
{
    if (!_delegate) return;
    [RrUserDefaults saveIntValueInUD:trackerTypeSegmentedControl.selectedSegmentIndex forKey:TrackerTypeSegmentedIndex];
    [_delegate trackerSettingsDidChange:(trackerTypeSegmentedControl.selectedSegmentIndex == 0)
                 improvedTrackerEnabled:improvedTrackerSwitch.on];
}

- (void) mapperSettingsDidChange:(id)sender
{
    if (!_delegate) return;
    [_delegate mapperSettingsDidChange:highResolutionMeshSwitch.on
                 improvedMapperEnabled:improvedMapperSwitch.on];
}

- (void) disableNonDynamicSettingsDuringScanning
{
    highResolutionColorSwitch.enabled = NO;
    streamPresetSegmentedControl.enabled = NO;
    trackerTypeSegmentedControl.enabled = NO;
    improvedTrackerSwitch.enabled = NO;
    highResolutionMeshSwitch.enabled = NO;
    improvedMapperSwitch.enabled = NO;
}

- (void) enableAllSettingsDuringCubePlacement
{
    highResolutionColorSwitch.enabled = YES;
    irAutoExposureSwitch.enabled = YES;
    irManualExposureSlider.enabled = YES;
    irGainSegmentedControl.enabled = YES;
    streamPresetSegmentedControl.enabled = YES;
    trackerTypeSegmentedControl.enabled = YES;
    improvedTrackerSwitch.enabled = YES;
    highResolutionMeshSwitch.enabled = YES;
    improvedMapperSwitch.enabled = YES;
}

@end

@implementation SettingsPopupView
{
    UIButton* _settingsIcon;
    SettingsListModal* _settingsListModal;
    
    BOOL _isSettingsListModalHidden;

    NSLayoutConstraint* widthConstraintWhenListModalIsShown;
    NSLayoutConstraint* heightConstraintWhenListModalIsShown;
    NSLayoutConstraint* widthConstraintWhenListModalIsHidden;
    NSLayoutConstraint* heightConstraintWhenListModalIsHidden;
}

- (instancetype) initWithSettingsPopupViewDelegate:(id<SettingsPopupViewDelegate>)delegate
{
    self = [super init];

    if (self) {
        [self setupComponentsWithDelegate:delegate];
    }
    return self;
}

- (void) setupComponentsWithDelegate:(id<SettingsPopupViewDelegate>)delegate
{
    // Attributes that apply to the whole content view
    self.backgroundColor = [UIColor clearColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = NO;
    
    // Settings Icon
    _settingsIcon = [[UIButton alloc] init];
    [_settingsIcon setImage:[UIImage imageNamed:@"settings-icon.png"]
                   forState:UIControlStateNormal];
    [_settingsIcon setImage:[UIImage imageNamed:@"settings-icon.png"]
                   forState:UIControlStateHighlighted];
    _settingsIcon.translatesAutoresizingMaskIntoConstraints = NO;
    _settingsIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_settingsIcon addTarget:self
                      action:@selector(settingsIconPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_settingsIcon];
    
    [self addConstraints:@[// Pin settings icon to top of superview
                           [NSLayoutConstraint constraintWithItem:_settingsIcon
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_settingsIcon.superview
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:0.0],
                           // Pin settings icon to left of superview
                           [NSLayoutConstraint constraintWithItem:_settingsIcon
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_settingsIcon.superview
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:0.0],
                           // Set width to 45
                           [NSLayoutConstraint constraintWithItem:_settingsIcon
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:45.0],
                           // Set height to 45
                           [NSLayoutConstraint constraintWithItem:_settingsIcon
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:45.0]]];
    
    // Full Settings List Modal
    _settingsListModal = [[SettingsListModal alloc] initWithSettingsPopupViewDelegate:delegate];
    
    widthConstraintWhenListModalIsShown = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:420.0];
    
    const CGRect screenBounds = [[UIScreen mainScreen] bounds];
    heightConstraintWhenListModalIsShown = [NSLayoutConstraint constraintWithItem:self
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:screenBounds.size.height - 140];
    
    widthConstraintWhenListModalIsHidden = [NSLayoutConstraint constraintWithItem:self
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_settingsIcon
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    heightConstraintWhenListModalIsHidden = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_settingsIcon
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    // By default, we'll have the list modal hidden
    [self addConstraints:@[widthConstraintWhenListModalIsHidden,
                           heightConstraintWhenListModalIsHidden]];
    _isSettingsListModalHidden = YES;
}

- (void) showSettingsListModal
{
    [self addSubview:_settingsListModal];

    [self addConstraints:@[// Pin top settings list modal to bottom of settings icon
                           [NSLayoutConstraint constraintWithItem:_settingsListModal
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_settingsIcon
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:0.0],
                           // Pin left edge of settings list modal to superview
                           [NSLayoutConstraint constraintWithItem:_settingsListModal
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_settingsIcon
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0
                                                         constant:20.0],
                           // Set width of settings list modal to be 350
                           [NSLayoutConstraint constraintWithItem:_settingsListModal
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:350.0],
                           // Set height of settings list modal less than or equal to superview
                           [NSLayoutConstraint constraintWithItem:_settingsListModal
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                                           toItem:_settingsListModal.superview
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0
                                                         constant:0.0]]];
    [self bringSubviewToFront:_settingsListModal];
}

- (void) hideSettingsListModal
{
    [_settingsListModal removeFromSuperview];
}

- (void) settingsIconPressed:(UIButton*)sender
{
    if (_isSettingsListModalHidden)
    {
        _isSettingsListModalHidden = NO;
        [self removeConstraints:@[widthConstraintWhenListModalIsHidden,
                                  heightConstraintWhenListModalIsHidden]];
        [self addConstraints:@[widthConstraintWhenListModalIsShown,
                               heightConstraintWhenListModalIsShown]];
        [self showSettingsListModal];
        return;
    }

    _isSettingsListModalHidden = YES;
    [self removeConstraints:@[widthConstraintWhenListModalIsShown,
                              heightConstraintWhenListModalIsShown]];
    [self addConstraints:@[widthConstraintWhenListModalIsHidden,
                           heightConstraintWhenListModalIsHidden]];
    [self hideSettingsListModal];
}

- (void) disableNonDynamicSettingsDuringScanning
{
    [_settingsListModal disableNonDynamicSettingsDuringScanning];
}

- (void) enableAllSettingsDuringCubePlacement
{
    [_settingsListModal enableAllSettingsDuringCubePlacement];
}

@end
