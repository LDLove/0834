//
//  DataManager.m
//  音乐播放器
//
//  Created by 高升 on 15/11/4.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import "DataManager.h"
#import "MusicModel.h"
@interface DataManager()
@property (nonatomic,strong)NSMutableArray * musicArray;
@end


@implementation DataManager
// 创建单例
static DataManager * manager = nil;
+ (DataManager *)sharedManager{
    // GCD 提供的一种单例方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];//?
        [manager requestData];
    });
    return manager;
}
// 需要将这个方法放到单例中，用单例来承接  
- (void)requestData{
    //在子线程中请求数据，防止假死
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //数据链接
        NSURL * url = [NSURL URLWithString:kMusicListURL];
        //请求数据
        NSArray * dataArray = [NSArray arrayWithContentsOfURL:url];
        for (int i = 0; i < dataArray.count; i++) {
            NSLog(@"%@",dataArray[i]);//?
            // 构建model
            MusicModel * model = [MusicModel new];
            [model setValuesForKeysWithDictionary:dataArray[i]];
            [self.musicArray addObject:model];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.myUpdataUI) {
                NSLog(@"black 没有代码");
            }else{
                self.myUpdataUI();
            }
        });
    });
}
- (MusicModel *)musicModelWithIndex:(NSInteger)index{
    return self.allMusic[index];
}
#pragma mark -- lazy load 
- (NSMutableArray *)musicArray{
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}
- (NSArray *)allMusic{
    return self.musicArray;
}






@end
