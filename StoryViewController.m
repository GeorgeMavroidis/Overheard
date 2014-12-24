//
//  StoryViewController.m
//  Overheard
//
//  Created by George on 2014-12-07.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import "StoryViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface StoryViewController (){
    int timeS, curTime;
    UILabel *timerLabel;
    UIView *mainView;
    
    NSArray* reversedArray;
    int rIndex;
    NSMutableArray *lengthArray;
    BOOL first;
    
    NSTimer *timer;
}

@end

@implementation StoryViewController
@synthesize array, removed;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRegistered)];
    [self.view addGestureRecognizer:tap];
    
    mainView = [[UIView alloc] init];
    [mainView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:mainView];
    first = true;
    rIndex = 0;
    removed = @"";
    lengthArray = [[NSMutableArray alloc] init];
    if(array != nil){
        [self provisionStory];
        [NSTimer scheduledTimerWithTimeInterval:1.0  target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    }
}
-(void)tapRegistered{
    NSLog(@"Registered");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)provisionStory{
    reversedArray = [[array reverseObjectEnumerator] allObjects];
        reversedArray = array;
//    [self draw:reversedArray atIndex:0 withTime:timeS];

    
    timeS = 0;
    for(NSDictionary *each in reversedArray){
        NSString *length = [each objectForKey:@"length"];
        if(length.length > 1){
            length = [length substringFromIndex:[length length] -1];
        }
        timeS += [length intValue];
        [lengthArray addObject:length];
    }
    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-50, 10, 50, 50)];
    timerLabel.textColor = [UIColor whiteColor];
    timerLabel.text = [NSString stringWithFormat:@"%d", timeS];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    [timerLabel setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:17]];
    
    [self.view addSubview:timerLabel];
    curTime = timeS;
    
}
-(void)countdown{
    
    if([removed isEqualToString:@"true"]){
        [timer invalidate];
    }else{
        if(rIndex < [reversedArray count]){
            if(curTime == timeS){
                [self draw:reversedArray atIndex:rIndex withTime:timeS];
                curTime = timeS - [[lengthArray objectAtIndex:rIndex] intValue];
                rIndex ++;
                
            }
        }
        
        timeS --;
        timerLabel.text = [NSString stringWithFormat:@"%d", timeS];
        if(timeS == 0){
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            [timer invalidate];
            
        }
    }
    
}
-(void)draw:(NSArray *)rarray atIndex:(int)index withTime:(int)time{
//    for(NSDictionary *each in rarray){
    NSDictionary *each = [rarray objectAtIndex:index];
        NSString *type = [each objectForKey:@"type"];
        NSString *length = [each objectForKey:@"length"];
        NSString *filename = [each objectForKey:@"filename"];
    
        if([type isEqualToString:@"video"]){
            
            NSArray *directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *videoPath =  [directoryPath objectAtIndex:0];
            videoPath= [videoPath stringByAppendingPathComponent:filename];

            [self Play:videoPath];
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            NSArray *directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *imagePath =  [directoryPath objectAtIndex:0];
            imagePath= [imagePath stringByAppendingPathComponent:filename];
            
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            UIImage *img = [UIImage imageWithData:data];
            
            imageView.image = img;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [mainView addSubview:imageView];
        }
//    }
}
-(void)Play:(NSString *)vid
{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //    AVAsset *avAsset = [AVAsset assetWithURL:vid];
    AVAsset *avAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:vid]];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    AVPlayer *avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer * avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:avPlayer];
    
    CGFloat ratio = screenHeight *3 / 4;
    CGFloat new_ratio = screenWidth *4/3;
    
    CGFloat new_minus = (screenWidth - new_ratio)/2;
    CGFloat minus = (screenHeight - ratio)/2;
    
    
    UIView *apl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [avAsset naturalSize].width, screenHeight)];
    [apl setBackgroundColor:[UIColor blackColor]];
    [mainView addSubview:apl];
    [apl setUserInteractionEnabled:YES];
    
//    
    float   angle = M_PI+M_PI;  //rotate 180°, or 1 π radian
    avPlayerLayer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResize];
    [avPlayerLayer setFrame:CGRectMake(0, 0, apl.frame.size.width, screenHeight)];
    
    
    [apl.layer addSublayer:avPlayerLayer];
    //[avPlayerLayer setBackgroundColor:[[UIColor redColor]CGColor]];
    [avPlayer seekToTime:kCMTimeZero];
    [avPlayer play];
    
    
    
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
