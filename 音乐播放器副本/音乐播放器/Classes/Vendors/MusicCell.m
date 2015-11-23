//
//  MusicCell.m
//  音乐播放器
//
//  Created by 高升 on 15/11/4.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import "MusicCell.h"
#import "UIImageView+WebCache.h"
@implementation MusicCell
- (void)setMusicModel:(MusicModel *)musicModel{
    self.nameLabel.text = musicModel.name;
    self.name1Label.text = musicModel.singer;
    [self.imgeView sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
