//
//  LSAvatarImagePicker.h
//  Lifesense
//
//  Created by Nathan Ou on 9/23/13.
//  Copyright (c) 2013 Xtreme Programming Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OTAvatarImagePickerDelegate;

@interface MZAvatarImagePicker : NSObject <UIImagePickerControllerDelegate, UINavigationBarDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) id <OTAvatarImagePickerDelegate> delegate;

@property (nonatomic, strong) UIImage *Image;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) BOOL shouldSave;

+ (instancetype)sharedInstance;

- (void)getImageFromCameraInIphone:(UIViewController *)controller;
- (void)getImageFromAlbumInIphone:(UIViewController *)controller;

@end

@protocol OTAvatarImagePickerDelegate <NSObject>

- (void)getImageFromWidget:(UIImage *)image;

@end
