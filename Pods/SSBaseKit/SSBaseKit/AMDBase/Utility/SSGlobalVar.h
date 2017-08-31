//
//  SSGlobalVar.h
//  SSBaseKit
//
//  Created by SunSet on 2017/5/19.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#ifndef SSGlobalVar_h
#define SSGlobalVar_h


#define SSColorWithRGB(r,g,b,a) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:a]

//字体
#define SSFontWithName(n,s) [UIFont fontWithName:@"HiraginoSansGB-W3" size:s]
//#define SSFontWithName(n,s) [UIFont systemFontOfSize:s]
#define SSFontBoldWithName(n,s) [UIFont fontWithName:@"HiraginoSansGB-W3" size:s]


// bundle名称
#define SSBundleName @"SSBaseKit.bundle"

// 从本地获取
#define SSGetFilePath(a) [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:a]
#define SSGetFilePathFromBundle(b,n) [[[NSBundle bundleWithPath:SSGetFilePath(b)] resourcePath] stringByAppendingPathComponent:n]
#define SSImageFromName(a) [[UIImage alloc]initWithContentsOfFile:SSGetFilePathFromBundle(SSBundleName,a)]


// - NSUserDefaults
//获取NSUserDefaults中的值
#define GetDefaults(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]
//设置NSUserDefaults中的键值对
#define SetDefaults(key,value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define SetDefaultsSynchronize() [[NSUserDefaults standardUserDefaults] synchronize]
#define RemoveDefaults(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]


//屏幕宽高
#define SScreenWidth [UIScreen mainScreen].bounds.size.width
#define SScreenHeight [UIScreen mainScreen].bounds.size.height



// 统一配置
// 线条高度
#define SSLineHeight 0.5
// 线条颜色
#define SSLineColor SSColorWithRGB(230, 230, 230, 1)
// 默认圆角
#define SSCornerRadius 3



#endif /* SSGlobalVar_h */
