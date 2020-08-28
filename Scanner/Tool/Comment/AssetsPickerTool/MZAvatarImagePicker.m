//
//  LSAvatarImagePicker.m
//  Lifesense
//
//  Created by Nathan Ou on 9/23/13.
//  Copyright (c) 2013 Xtreme Programming Group. All rights reserved.
//

#import "MZAvatarImagePicker.h"

#define TAKE_PHOTO_VIEW 666

@implementation MZAvatarImagePicker

+ (instancetype)sharedInstance
{
    static MZAvatarImagePicker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.canEdit = YES;
    });
    return sharedInstance;
}

- (void)getImageFromCameraInIphone:(UIViewController *)controller
{
    self.rootViewController = controller;
    [self loadImagePick:UIImagePickerControllerSourceTypeCamera];
}

- (void)getImageFromAlbumInIphone:(UIViewController *)controller
{
    self.rootViewController = controller;
    [self loadImagePick:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (UIView *)findView:(UIView *)aView withName:(NSString *)name
{
    Class cl = [aView class];
    NSString *desc = [cl description];

    if ([name isEqualToString:desc])
        return aView;

    for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}

- (void)loadImagePick:(UIImagePickerControllerSourceType)sourceType
{
//    applySystemDefaultApprence();
    
    if (!self.picker) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.allowsEditing = self.canEdit;
        [self.picker setDelegate:self];
    }
    //需要检测  flash 能否用， 有没相机。。。
    if (UIImagePickerControllerSourceTypeCamera == sourceType) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            [self.picker setSourceType:sourceType];
            [self.picker setAllowsEditing:self.canEdit];
            self.picker.view.top = 64.f;
            [self.rootViewController presentViewController:self.picker animated:YES completion:^{}];
        }
    } else {
        [self.picker setSourceType:sourceType];
        [self.picker setAllowsEditing:self.canEdit];
        [self.picker.navigationBar setTranslucent:NO];
        if (@available(iOS 11, *)) {
                UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;

        }
        [self.rootViewController presentViewController:self.picker animated:YES completion:^{}];
    }
    
    self.canEdit = YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (@available(iOS 11, *)) {

            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    }


//    [UINavigationController applyDefaultApprence];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!image) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if ([self.delegate respondsToSelector:@selector(getImageFromWidget:)]) {
            if (self.shouldSave && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                self.shouldSave = NO;
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
            [self->_delegate getImageFromWidget:image];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [UINavigationController applyDefaultApprence];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
