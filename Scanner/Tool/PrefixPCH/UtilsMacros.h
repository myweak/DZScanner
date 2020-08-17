//
//  UtilsMacros.h
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h


//#define KBottom_Btn_H iPH(50)   //底部按钮的高
#define  KCell_H  ceil(iPH(73))  // cell 高度
#define  KTabar_Width 80 //splist左视图宽度



// 导航栏 +状态栏 高度
#define app_naviBar_Height  ([[UIApplication sharedApplication] statusBarFrame].size.height +44)

#define KScreen       [[UIScreen mainScreen] bounds]
#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height

#define KFrameWidth   [UserDataManager sharedManager].frame_width
#define KFrameHeight  [[UIScreen mainScreen] bounds].size.height

#define KWindow       [[UIApplication sharedApplication].delegate window]
#define KAppDelegate  [UIApplication sharedApplication].delegate 

// 以iPad mini2为标准进行缩放  横屏 width 1024, height = 768
#define iPH(asd) (((asd)/768.000f)*[UIScreen mainScreen].bounds.size.height)
#define iPW(asd) (((asd)/1024.000f)*[UIScreen mainScreen].bounds.size.width)



/// 7号粗字体
#define KFont7 [UIFont systemFontOfSize:iPW(7.0)]

/// 8号粗字体
#define KFont8 [UIFont systemFontOfSize:iPW(8.0)]

/// 9号粗字体
#define KFont9 [UIFont systemFontOfSize:iPW(9.0)]

/// 10号粗字体
#define KFont10 [UIFont systemFontOfSize:iPW(10.0)]

/// 11号粗字体
#define KFont11 [UIFont systemFontOfSize:iPW(11.0)]

/// 12号粗字体
#define KFont12 [UIFont systemFontOfSize:iPW(12.0)]

/// 13号粗字体
#define KFont13 [UIFont systemFontOfSize:iPW(13.0)]

/// 14号粗字体
#define KFont14 [UIFont systemFontOfSize:iPW(14.0)]

/// 15号粗字体
#define KFont15 [UIFont systemFontOfSize:iPW(15.0)]

/// 16号粗字体
#define KFont16 [UIFont systemFontOfSize:iPW(16.0)]

/// 17号粗字体
#define KFont17 [UIFont systemFontOfSize:iPW(17.0)]

/// 18号粗字体
#define KFont18 [UIFont systemFontOfSize:iPW(18.0)]
/// 19号字粗体
#define KFont19 [UIFont systemFontOfSize:iPW(19.0)]
/// 20号字粗体
#define KFont20 [UIFont systemFontOfSize:iPW(20.0)]
/// 25号字粗体
#define KFont25 [UIFont systemFontOfSize:iPW(25.0)]
/// 35号字粗体
#define KFont35 [UIFont systemFontOfSize:iPW(35.0)]




#endif /* UtilsMacros_h */
