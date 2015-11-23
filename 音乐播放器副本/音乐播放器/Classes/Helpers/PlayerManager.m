//
//  PlayerManager.m
//  音乐播放器
//
//  Created by 高升 on 15/11/5.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerManager()
@property (nonatomic,strong) AVPlayer * player;
@property (nonatomic,strong) NSTimer * timer;
@end





@implementation PlayerManager
static PlayerManager * manager = nil;
// 单例方法
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PlayerManager new];
    });
    return manager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidPiayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
- (void)playerDidPiayEnd:(NSNotification *)not{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
        [self.delegate playerDidPlayEnd];
    }
}



- (void)playWithUrlString:(NSString *)urlStr{
    //判断是否播放当前的音乐，不是 将其移除
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 创建一个item
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    // 添加观察者
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 替换当前的这首歌
    [self.player replaceCurrentItemWithPlayerItem:item];
    }
- (void)play{
    // 若果播放执行这个方法
    if (_isPlaying) {
        return;
    }
    [self.player play];
    _isPlaying = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
}
- (void)playingWithSeconds{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayingWithTime:)]) {
        NSTimeInterval time = self.player.currentTime.value/self.player.currentTime.timescale;
        [self.delegate playerPlayingWithTime:time];
    }
}
- (void)pause{
    [self.player pause];
    [self.timer invalidate];
    // 暂停播放后标记一下
    _isPlaying = NO;
}
- (void)seekToTime:(NSTimeInterval)time{
    // 先暂停
    [self pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        // 拖拽成功后再播放
        if (finished) {
            [self play];
        }
    }];
}
// 改变音量
- (void)changeToVolume:(CGFloat)volume{
    self.player.volume = volume;
}




- (CGFloat)volume{
    return self.player.volume;
}



// 懒加载
- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}
#pragma mark - 实现响应者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@",keyPath);
    NSLog(@"%@",change);
    AVPlayerStatus status = [change[@"new"] integerValue];
    // 用switch来判断
    switch (status) {
        case AVPlayerStatusFailed:
            NSLog(@"加载失败");
            break;
            case AVPlayerStatusUnknown:
            NSLog(@"资源不对");
            case AVPlayerStatusReadyToPlay:
            NSLog(@"准备好了，可以播放");
            [self pause];
            [self play];
        default:
            break;
    }
}



@end
