//
//  LyricModel.m
//  音乐播放器
//
//  Created by 高升 on 15/11/10.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel
// 初始化
-(instancetype)initWithTime:(NSTimeInterval)time lyric:(NSString * )lyric{
    if (self = [super init]) {
        _time = time;
        _lyricComtext = lyric;
    }
    return self;
}








@end
