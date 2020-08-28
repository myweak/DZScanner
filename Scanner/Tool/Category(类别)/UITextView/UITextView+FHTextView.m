//
//  UITextView+FHTextView.m
//  Scanner
//
//  Created by edz on 2020/7/14.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "UITextView+FHTextView.h"
#import <objc/runtime.h>
@interface UITextView ()

@end
@implementation UITextView (FHTextView)

static NSString *PLACEHOLDLABEL = @"placelabel";
static NSString *PLACEHOLD = @"placehold";
static NSString *WORDCOUNTLABEL = @"wordcount";
static const void *limitLengthKey = &limitLengthKey;


#pragma mark -- set/get...

-(void)setPlaceholderLabel:(UILabel *)placeholderLabel {

    objc_setAssociatedObject(self, &PLACEHOLDLABEL, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)placeholderLabel {

    return objc_getAssociatedObject(self, &PLACEHOLDLABEL);

}

- (void)setPlaceholder:(NSString *)placeholder {
    
   
    objc_setAssociatedObject(self, &PLACEHOLD, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setPlaceHolderLabel:placeholder];
}

- (NSString *)placeholder {

    return objc_getAssociatedObject(self, &PLACEHOLD);
}


- (UILabel *)wordCountLabel {

    return objc_getAssociatedObject(self, &WORDCOUNTLABEL);

}
- (void)setWordCountLabel:(UILabel *)wordCountLabel {

    objc_setAssociatedObject(self, &WORDCOUNTLABEL, wordCountLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}


- (NSNumber *)limitLength {

    return objc_getAssociatedObject(self, limitLengthKey);
}

- (void)setLimitLength:(NSNumber *)limitLength {
    objc_setAssociatedObject(self, limitLengthKey, limitLength, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addLimitLengthObserver:[limitLength intValue]];

    [self setWordcountLable:limitLength];
    
}

#pragma mark -- 配置占位符标签

- (void)setPlaceHolderLabel:(NSString *)placeholder {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextViewTextDidChangeNotification object:self];
    /*
     *  占位字符
     */
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.text = placeholder;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.placeholderLabel.textColor = [self defaultPlaceholderColor];
    CGRect rect = [placeholder boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-7, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
    self.placeholderLabel.frame = CGRectMake(7, 9, rect.size.width, rect.size.height);
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.hidden = self.text.length > 0 ? YES : NO;

}

#pragma mark -- 配置字数限制标签

- (void)setWordcountLable:(NSNumber *)limitLength {
    
    /*
     *  字数限制
     */
    self.wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 65, CGRectGetHeight(self.frame) - 20, 60, 20)];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    self.wordCountLabel.textColor = [UIColor lightGrayColor];
    self.wordCountLabel.font = [UIFont systemFontOfSize:13.];
    if (self.text.length > [limitLength integerValue]) {
        self.text = [self.text substringToIndex:[self.limitLength intValue]];
    }
    self.wordCountLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.text.length,limitLength];
    [self addSubview:self.wordCountLabel];
    
}


#pragma mark -- 增加限制位数的通知
- (void)addLimitLengthObserver:(int)length {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitLengthEvent) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark -- 限制输入的位数
- (void)limitLengthEvent {

    if ([self.text length] > [self.limitLength intValue]) {

        self.text = [self.text substringToIndex:[self.limitLength intValue]];
    }
}



#pragma mark -- NSNotification

- (void)textFieldChanged:(NSNotification *)notification {
    if (self.placeholder) {
        self.placeholderLabel.hidden = YES;
        
        if (self.text.length == 0) {
            
            self.placeholderLabel.hidden = NO;
        }
    }
    if (self.limitLength) {
        
        NSInteger wordCount = self.text.length;
        if (wordCount > [self.limitLength integerValue]) {
            wordCount = [self.limitLength integerValue];
        }
        self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/%@",wordCount,self.limitLength];
    }

}

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}
- (UIColor *)defaultPlaceholderColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       __autoreleasing UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        @try{
            color = [textField valueForKeyPath:@"placeholderLabel.textColor"];
        }@catch (NSException *exception){
            color = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
        }
    });
    return color;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
}




- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   return  [self shouldChangeCharactersInRange:range replacementString:string number:7];
}

// begin 金额输入限制位数，可自定义整数位

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string number:(int)number
{
    if ([self isFirstResponder])
    {
        NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *limitSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
        
        NSString *tempStr = [self.text stringByReplacingCharactersInRange:range withString:string];
        
        if (tempStr.length == 1)
        {
            // 首个输入不能为0或小数点
            // 但可以输入数字
            NSRange numberRange = [tempStr rangeOfCharacterFromSet:numberSet];
            if (numberRange.location == NSNotFound)
            {
                return NO;
            }
        }
        else if (tempStr.length > 1)
        {
            for (int i = 0; i < tempStr.length; i++)
            {
                NSString *subString = [tempStr substringWithRange:NSMakeRange(i, 1)];
                
                // 只能输入数字和小数点
                NSRange numberRange = [subString rangeOfCharacterFromSet:limitSet];
                if (numberRange.location == NSNotFound)
                {
                    return NO;
                }
            }
            
            // 无小数点时，只能输入number个数字，0时无限制
            NSRange pointRange = [tempStr rangeOfString:@"."];
            if (number != 0)
            {
                if (pointRange.location == NSNotFound && number + 1 == tempStr.length)
                {
                    return NO;
                }
            }
            
            // 存在小数点时，只能再输入两位小数，不能再输入小数点
            if (pointRange.location != NSNotFound)
            {
                // 只能有一个小数点
                CGFloat limitlength = pointRange.location + pointRange.length;
                NSString *temp = [tempStr substringFromIndex:limitlength];
                NSRange hasPointRange = [temp rangeOfString:@"."];
                if (hasPointRange.location != NSNotFound)
                {
                    return NO;
                }
                
                // 小数点后两位
                if (limitlength + 3 == tempStr.length)
                {
                    return NO;
                }
                
                // 存在小数时点，整数不足五位时，最多只能输入6位，0时无限制
                if (number != 0)
                {
                    NSString *subTemp = [tempStr substringToIndex:pointRange.location];
                    if (number + 1 == subTemp.length)
                    {
                        return NO;
                    }
                }
            }
        }
        
        return YES;
    }
    return YES;
}




@end
