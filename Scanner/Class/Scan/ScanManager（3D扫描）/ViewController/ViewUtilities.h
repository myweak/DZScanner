/*
 This file is part of the Structure SDK.
 Copyright © 2019 rrd, Inc. All rights reserved.
 http://structure.io
 */

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIColor* colorFromHexString(NSString* hexString);

UIImage* imageWithColor(UIColor* color, CGRect rect, CGFloat cornerRadius);

UIView* createHorizontalRule(CGFloat height);
