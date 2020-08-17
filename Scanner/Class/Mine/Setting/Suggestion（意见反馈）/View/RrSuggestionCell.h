//
//  RrSuggestionCell.h
//  Scanner
//
//  Created by edz on 2020/8/13.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KRrSuggestionCell_ID @"KRrSuggestionCell_ID"
#import <UIKit/UIKit.h>
#import "AddPhotoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RrSuggestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numbTextLabel;

@property (weak, nonatomic) IBOutlet UIView *contentViewBg;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet AddPhotoView *addPhotoView;
@property (weak, nonatomic) IBOutlet UIView *textFieldBgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

NS_ASSUME_NONNULL_END
