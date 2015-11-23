//
//  LyricManager.h
//  音乐播放器
//
//  Created by 高升 on 15/11/10.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject
// 对外的哥词数组
@property (nonatomic, strong) NSArray * allLyrric;
// 单例
+ (instancetype)sharedManager;
-(void)loadLyricWith:(NSString *)lyicStr;
// 接口
/**
 *  根据播放时间获取到该播放的歌词的索引
 */
- (NSInteger)indexWith:(NSTimeInterval)time;





@end
