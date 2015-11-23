//
//  PlayingController.h
//  音乐播放器
//
//  Created by 高升 on 15/11/5.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingController : UIViewController
// 要播放第几首
@property (nonatomic,assign) NSInteger  index;

// 创建单例
+(instancetype)sharedPlayingPVC;
@end
