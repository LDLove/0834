//
//  PlayerManager.h
//  音乐播放器
//
//  Created by 高升 on 15/11/5.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol playerManagerDelegate <NSObject>
 /**
 *  播放一首结束后自动播放下一首
 */
- (void)playerDidPlayEnd;
/**
 * 播放中间一直在重复执行的一个方法
 
 */
- (void)playerPlayingWithTime:(NSTimeInterval)time;
@end





@interface PlayerManager : NSObject
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) id<playerManagerDelegate>delegate;
// 创建一个单例
+ (instancetype)sharedManager;


// 创建一个方法
- (void)playWithUrlString:(NSString *)urlStr;
// 播放
- (void)play;

// 暂停
- (void)pause;
// 改变进度
- (void)seekToTime:(NSTimeInterval)time;
// 改变音量
- (void)changeToVolume:(CGFloat)volume;
// 用来访问音量
- (CGFloat)volume;







@end
