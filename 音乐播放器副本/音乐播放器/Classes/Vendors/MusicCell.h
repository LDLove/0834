//
//  MusicCell.h
//  音乐播放器
//
//  Created by 高升 on 15/11/4.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
@interface MusicCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgeView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *name1Label;

@property (nonatomic,retain) MusicModel * musicModel;
@end
