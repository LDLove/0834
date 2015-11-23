//
//  DataManager.h
//  音乐播放器
//
//  Created by 高升 on 15/11/4.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
typedef void(^UpdataUI)();//?
@interface DataManager : NSObject
@property (nonatomic,copy) UpdataUI myUpdataUI;
@property (nonatomic,strong) NSArray * allMusic;

/**
 *  单例方法
 @ return 单例
 */
+ (DataManager *)sharedManager;

/**
 *  根据cell的索引返回一model
 */
-(MusicModel *)musicModelWithIndex:(NSInteger)index;





@end
