//
//  LyricManager.m
//  音乐播放器
//
//  Created by 高升 on 15/11/10.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"
@interface LyricManager()
// 用来存放数组
@property (nonatomic,strong) NSMutableArray * lyrics;

@end
static LyricManager * manager = nil;
@implementation LyricManager
// 实现单例
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LyricManager new];
    });
    return manager;
}
- (void)loadLyricWith:(NSString *)lyicStr{
    // 分行
    NSMutableArray * lyricStringArray = [[lyicStr componentsSeparatedByString:@"\n"]mutableCopy];
    // 最后一行@""
    [lyricStringArray removeLastObject];
    // 要先将歌词移除
    [self.lyrics removeAllObjects];
    
    for (NSString * str  in lyricStringArray) {
        // 分开时间和歌词
        NSArray * timeAndLyric = [str componentsSeparatedByString:@"]"];
        NSString * time = [timeAndLyric[0] substringFromIndex:1];// 从第一行开始截取到最后一行
        // 截取时间，获取分和秒
        NSArray * minuteAndSecond = [time componentsSeparatedByString:@":"];
        // 分
        NSInteger minute = [minuteAndSecond[0] integerValue];
        // 秒
        double second = [minuteAndSecond[1] doubleValue];
        LyricModel * model = [[LyricModel alloc]initWithTime:(minute * 60 + second) lyric:timeAndLyric[1]];
        // 添加到数组上
        [self.lyrics addObject:model];
    }
    
    
 }
// 实现接口

- (NSInteger)indexWith:(NSTimeInterval)time{
    NSInteger index = 0;
    // 遍历数组 。找到没有播放的哪一句歌词
    for (int i = 0; i < self.lyrics.count; i++) {
        LyricModel * model = self.lyrics[i];
        
        if (model.time > time) {
            // 注意如果第0个元素，而且元素时间比要播放的时间大i-1,就会效益零，这样tabel就是错误
            index = (i-1>0)?i-1:0;
            break;
        }
    }
    return index;
}

// 赖加载
- (NSMutableArray *)lyrics{
    if (!_lyrics) {
        _lyrics = [NSMutableArray new];
    }
    return _lyrics;
}
// get方法
- (NSArray *)allLyrric{
    return self.lyrics;
}














@end
