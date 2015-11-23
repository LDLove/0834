//
//  PlayingController.m
//  音乐播放器
//
//  Created by 高升 on 15/11/5.
//  Copyright © 2015年 gaosheng. All rights reserved.
//

#import "PlayingController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "LyricModel.h"
#import "LyricManager.h"

@interface PlayingController ()<playerManagerDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) MusicModel * currentModel;
#pragma mark -- 控件
@property (weak, nonatomic) IBOutlet UILabel *lab4SongName;
@property (weak, nonatomic) IBOutlet UILabel *lab4SingerName;
@property (weak, nonatomic) IBOutlet UIImageView *imh4Pic;
@property (weak, nonatomic) IBOutlet UILabel *lab4PlayedTime;
@property (weak, nonatomic) IBOutlet UILabel *lab4LastTime;
@property (weak, nonatomic) IBOutlet UISlider *slider4Time;
@property (weak, nonatomic) IBOutlet UISlider *slider4Volume;
@property (weak, nonatomic) IBOutlet UIButton *but4PlayPrPause;
@property (weak, nonatomic) IBOutlet UITableView *tabelView4Lyric;

#pragma mark --控件事件
- (IBAction)action4Prev:(UIButton *)sender;
- (IBAction)action4PlayPrPause:(id)sender;
- (IBAction)action4Next:(id)sender;
- (IBAction)action4ChangeTime:(id)sender;
- (IBAction)action4ChangeVoluem:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;





@end
@implementation PlayingController
static NSString * cellImdentifier = @"cell";

static PlayingController * playingVC = nil;
// 单例实现
+(instancetype)sharedPlayingPVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 拿到main sb
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 用playingVC接受 在main sb 拿到我们要用试图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
    });
    return playingVC;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_index == _currentIndex) {
        return;
    }
    _currentIndex = _index;
    [self starPlay];
}
// 播放事件
- (void)starPlay{
    // 去到要播放的model
   MusicModel * model = [[DataManager sharedManager]musicModelWithIndex:self.currentIndex];
    [[PlayerManager sharedManager]playWithUrlString:model.mp3Url];
    [self buildUI];
}
- (void)buildUI{
    // 开始播放的时候调用这个方法
    self.lab4SingerName.text = self.currentModel.name;
    self.lab4SongName.text = self.currentModel.singer;
    [self.imh4Pic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
    // 更改but
    [self.but4PlayPrPause setTitle:@"暂停" forState:UIControlStateNormal];
    // 改变进度条的最大值
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue]/1000;
    self.slider4Time.value = 0;
    // 更改旋转得角度
    self.imh4Pic.transform = CGAffineTransformMakeRotation(0);
    // 调用歌词的方法
    
    [[LyricManager sharedManager] loadLyricWith:self.currentModel.lyric];
    [self.tabelView4Lyric reloadData];
//    self.tabelView4Lyric.backgroundColor = [UIColor clearColor];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = -1;
   // 设置自己为播放器的代理，帮播放器干一些事情
    [PlayerManager sharedManager].delegate = self;
    
    // 添加圆角
    self.imh4Pic.layer.masksToBounds = YES;
    self.imh4Pic.layer.cornerRadius = 120;
    // 注册
    [self.tabelView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:cellImdentifier];
    self.slider4Volume.value = [[PlayerManager sharedManager]volume];
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)action4Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (IBAction)action4Prev:(UIButton *)sender {
    _currentIndex--;
    if (_currentIndex == -1) {
        _currentIndex = [DataManager sharedManager].allMusic.count-1;
    }
    [self starPlay];
}
// 暂停播放事件
- (IBAction)action4PlayPrPause:(id)sender {
    // 判断是否正在播放
    if ([PlayerManager sharedManager].isPlaying) {
        // 如果正在播放，就让当前的歌曲暂停，同时改变but的text
        [[PlayerManager sharedManager]pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }else{
        // 暂停状态：改变but 为暂停
        [[PlayerManager sharedManager]play];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }
}

- (IBAction)action4Next:(id)sender {
    _currentIndex++;
    if (_currentIndex == [DataManager sharedManager].allMusic.count) {
        _currentIndex = 0;
    }
    [self starPlay];
}

- (IBAction)action4ChangeTime:(id)sender {
    UISlider * slider = sender;
    // 调用接口
    [[PlayerManager sharedManager] seekToTime:slider.value];
}

- (IBAction)action4ChangeVoluem:(id)sender {
    UISlider * slider = sender;
    [[PlayerManager sharedManager]changeToVolume:slider.value];
}
#pragma mark -playerManagerDelegate
// 播放下一首，播放完了就播放下一首
- (void)playerDidPlayEnd{
    // 直接调用这个方法
    [self action4Next:nil];
}
// 播放器每0.1秒会让代理（也就是这个页面）执行一下这个事件
- (void)playerPlayingWithTime:(NSTimeInterval)time{
    self.slider4Time.value = time;
    self.lab4PlayedTime.text = [self stringWithTime:time];
    // 剩余时间
    NSTimeInterval time2 = [self.currentModel.duration integerValue]/1000 - time;
    self.lab4LastTime.text = [self stringWithTime:time2];
    // 每0.1秒旋转一度
    self.imh4Pic.transform = CGAffineTransformRotate(self.imh4Pic.transform, M_PI/180);
    // 根据当前播放时间获取当前歌词
    NSInteger index = [[LyricManager sharedManager]indexWith:time];
    NSIndexPath * path = [NSIndexPath indexPathForRow:index inSection:0];
    // 让tableView选中当前播放的歌词
    [self.tabelView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    
    
    
    
    
    
}
// 根据时间获取字符串
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger miuntes = time/60;
    NSInteger sconds = (int)time%60;
    return [NSString stringWithFormat:@"%ld:%ld",(long)miuntes,(long)sconds];
}
#pragma mark - getter
- (MusicModel *)currentModel{
    // 确保当前播放的音乐是不是新的
    MusicModel * model = [[DataManager sharedManager]musicModelWithIndex:self.currentIndex];
    return model;
}
#pragma mark -UITableViewDataSource
//协议的方法，要用控件的名开头
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LyricManager sharedManager].allLyrric.count;
}
// 返回
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellImdentifier forIndexPath:indexPath];
    // 取出
    LyricModel * lyric = [LyricManager sharedManager].allLyrric[indexPath.row];
    // 设置歌词
    cell.textLabel.text = lyric.lyricComtext;
    // 设置居中
    cell.textLabel.textAlignment =NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor orangeColor];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image1"]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}







@end
