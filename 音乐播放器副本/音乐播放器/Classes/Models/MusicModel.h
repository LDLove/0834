//
//  MusicModel.h
//  音乐播放器
//
//  Created by 高升 on 15/11/4.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (nonatomic,strong) NSString * mp3Url;
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * picUrl;
@property (nonatomic,strong) NSString * blurPicUrl;
@property (nonatomic,strong) NSString * album;
@property (nonatomic,strong) NSString * singer;
@property (nonatomic,strong) NSString * duration;
@property (nonatomic,strong) NSString * artists_name;
@property (nonatomic,strong) NSString * lyric;

@end
