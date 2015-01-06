//
//  StoryCreatorViewController.m
//  Overheard
//
//  Created by George on 2014-12-02.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import "StoryCreatorViewController.h"
#import <Parse/Parse.h>
#import "SnapchatSelectViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface StoryCreatorViewController (){
    UIImagePickerController *storyPicker;
    UIImageView *imageView;
    UIView *sendView;
    UITextView *sendTextView;
//    UITextView *sendTextView;
    BOOL showTextView;
    UIImageView *send_icon;
    UIView *send_icon_view;
    UIView *selectTime;
    UITextField *myTextField;
    UIPickerView *myPickerView;
    NSArray *pickerArray;
    NSString *ti;
    UILabel *timeL, *closeLabel;
    SnapchatSelectViewController *s;
    UITapGestureRecognizer *text;
    NSString *typeOf;
    UIView *apl;
    NSData *videoData;
    AVPlayerLayer *avPlayerLayer;
    NSString *resultTime;
    AVAsset *avAsset;
    NSURL *videoURL;
    AVPlayer *avPlayer;
}

@end

@implementation StoryCreatorViewController
@synthesize imageURL;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationFade];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
}
- (BOOL)shouldAutorotate{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    storyPicker = nil;
    storyPicker = [[UIImagePickerController alloc] init];
    
    storyPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    storyPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    storyPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    storyPicker.showsCameraControls = NO;
    storyPicker.navigationBarHidden = YES;
    storyPicker.toolbarHidden = YES;
    storyPicker.wantsFullScreenLayout = YES;
//    storyPicker.allowsEditing = YES;
    storyPicker.delegate = self;
    storyPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    
    storyPicker.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    
    float cameraAspectRatio = 4.0 / 3.0;
    float imageWidth = floorf(screenWidth * cameraAspectRatio);
    float scale = ceilf((screenHeight / imageWidth)*10)/10;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0f, 50.0f);
    transform = CGAffineTransformScale(transform, 1.5f, 1.5f);
    storyPicker.cameraViewTransform = transform;
    

    storyPicker.mediaTypes =[NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
    
//    storyPicker.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
    
//    storyPicker.cameraViewTransform= CGAffineTransformMakeScale(scale, scale);
    
//    storyPicker.cameraViewTransform = CGAffineTransformMakeScale(screenWidth, screenHeight);
//    storyPicker.cameraViewTransform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    [self.view addSubview:storyPicker.view];
    
    
    UIImageView *closeVC = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    closeVC.image = [UIImage imageNamed:@"close_ffffff_50.png"];
    [closeVC setUserInteractionEnabled:YES];
//    [self.view addSubview:closeVC];
    
    UILabel *closeLabels = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 50, 50)];
    closeLabels.text = @"X";
    closeLabels.textAlignment  = NSTextAlignmentCenter;
    closeLabels.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:25];
    [closeLabels setTextColor:[UIColor whiteColor]];
    [closeLabels setUserInteractionEnabled:YES];
//    [closeLabel addGestureRecognizer:closeV];
    [self.view addSubview:closeLabels];
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeV)];
    [closeLabels addGestureRecognizer:closeTap];
    
    UIImageView *image_icon = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2-50, screenHeight-150, 100, 100)];
    image_icon.image = [UIImage imageNamed:@"circle_picture_new.png"];
    [self.view addSubview:image_icon];
    
    UITapGestureRecognizer *storyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordStory)];
    [image_icon addGestureRecognizer:storyTap];
    [image_icon setUserInteractionEnabled:YES];
    
    UILongPressGestureRecognizer *videoTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordVideo:)];
    [image_icon addGestureRecognizer:videoTap];
    videoTap.minimumPressDuration = 1.0;
    videoTap.delegate = self;
    
    UILongPressGestureRecognizer *videoTaps = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordVideos:)];
    [image_icon addGestureRecognizer:videoTaps];
    videoTaps.minimumPressDuration = 0.2;
    videoTap.delegate = self;
    
    // Do any additional setup after loading the view.
    
    UIImageView *image_icon_flip = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-70, 10, 50, 50)];
    image_icon_flip.image = [UIImage imageNamed:@"flip_camera.png"];
    [self.view addSubview:image_icon_flip];
    [image_icon_flip setUserInteractionEnabled:YES];
    
    
    UITapGestureRecognizer *flipCam = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCamera)];
    [image_icon_flip addGestureRecognizer:flipCam];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
-(void)recordVideos:(UILongPressGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        
        storyPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
//        storyPicker.videoQuality = UIImagePickerControllerQualityType
        
        CGRect screenRect = self.view.bounds;
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        storyPicker.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
        transform = CGAffineTransformScale(transform, 1.0f, 1.0f);
                storyPicker.cameraViewTransform = transform;
    }
}
-(void)recordVideo:(UILongPressGestureRecognizer *)recognizer{
    typeOf= @"video";
    if(recognizer.state == UIGestureRecognizerStatePossible){
        storyPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    }
    if(recognizer.state == UIGestureRecognizerStateBegan){
        
        storyPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        [storyPicker startVideoCapture];
        
       
        
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        [storyPicker stopVideoCapture];
    }

    
}
-(void)cameraIsReady{
    NSLog(@"read");
}
-(void)flipCamera{
    if(storyPicker.cameraDevice == UIImagePickerControllerCameraDeviceRear){
        storyPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else{
        storyPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        
    }
    
}
-(void)recordStory{
    typeOf = @"picture";
    [storyPicker takePicture];
    
}
-(void)closeV{
    NSLog(@"here");
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat ratio = screenHeight *3 / 4;
    CGFloat new_ratio = screenWidth *4/3;
    
    CGFloat new_minus = (screenWidth - new_ratio)/2;
    CGFloat minus = (screenHeight - ratio)/2;
    
    
    if ([typeOf isEqualToString:@"video"]){
        NSLog(@"here");
        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        videoData = [NSData dataWithContentsOfURL:videoURL];
        [self Play:videoURL];
        
    }else{
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(new_minus, 0, new_ratio, screenHeight)];
        imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if(imageView.image.size.height > imageView.image.size.width){
            
        }else{
            
            imageView.image = [self rotateUIImage:imageView.image clockwise:TRUE];
            
        }
        
        UIImage * flippedImage = [UIImage imageWithCGImage:imageView.image.CGImage scale:imageView.image.scale orientation:UIImageOrientationLeftMirrored];
        if(storyPicker.cameraDevice == UIImagePickerControllerCameraDeviceFront){
            imageView.image = flippedImage;
        }
        
        [self.view addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        
        [self drawSendView];
    }
    
    
}
- (UIImage*)rotateUIImage:(UIImage*)sourceImage clockwise:(BOOL)clockwise
{
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft] drawInRect:CGRectMake(0,0,size.height ,size.width)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}
-(UIInterfaceOrientation)orientationForTrack:(AVAsset *)asset
{
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIInterfaceOrientationPortrait;
}
-(void)Play:(NSURL *)vid
{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    avAsset = [AVAsset assetWithURL:vid];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:avPlayer];
    
    CGFloat ratio = screenHeight *3 / 4;
    CGFloat new_ratio = screenWidth *4/3;
    
    CGFloat new_minus = (screenWidth - new_ratio)/2;
    CGFloat minus = (screenHeight - ratio)/2;
    
    
    apl = [[UIView alloc] initWithFrame:CGRectMake(new_minus, 0, new_ratio, screenHeight)];
    [self.view addSubview:apl];
    [apl setUserInteractionEnabled:YES];
    
    
    
    if([self orientationForTrack:avAsset] != UIInterfaceOrientationPortrait){
        float   angle = M_PI/2;  //rotate 180°, or 1 π radian
        avPlayerLayer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
        [avPlayerLayer setFrame:CGRectMake(0, 0, apl.frame.size.width, apl.frame.size.height)];


    }else{
        [avPlayerLayer setFrame:CGRectMake(0, 0, apl.frame.size.width, apl.frame.size.height)];
    }
    
    [apl.layer addSublayer:avPlayerLayer];
    //[avPlayerLayer setBackgroundColor:[[UIColor redColor]CGColor]];
    [avPlayer seekToTime:kCMTimeZero];
    [avPlayer play];
    
    
    CMTime videoDuration = avAsset.duration;
    float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:videoDurationSeconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"s"];  //you can vary the date string. Ex: "mm:ss"
    resultTime = [dateFormatter stringFromDate:date];

    
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    [self drawSendVideoView];
    
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:vid];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnDone_Press) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
//    player.shouldAutoplay = YES;
//    
//    player.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
//
//    [self.view addSubview:player.view];
//    player.scalingMode = MPMovieScalingModeAspectFit;
//    player.fullscreen = YES;
//    
//    [player play];
}
-(void)drawSendVideoView{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    text = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendText)];
    [apl addGestureRecognizer:text];
    showTextView = YES;
    
    UIView *send_icon_view =[[UIView alloc] initWithFrame:CGRectMake(screenWidth-50, screenHeight-50, 50, 50)];
    send_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    send_icon.image = [UIImage imageNamed:@"paper-plane_ffffff_50.png"];
    [send_icon setUserInteractionEnabled:YES];
    [send_icon_view setUserInteractionEnabled:YES];
    [send_icon_view addSubview:send_icon];
    [self.view addSubview:send_icon_view];
    
    UITapGestureRecognizer *sendIt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectChannel)];
    [send_icon_view addGestureRecognizer:sendIt];
    
    closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 50, 50)];
    closeLabel.text = @"X";
    closeLabel.textAlignment  = NSTextAlignmentCenter;
    closeLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:25];
    [closeLabel setTextColor:[UIColor whiteColor]];
    [closeLabel setUserInteractionEnabled:YES];
    //        [closeLabel addGestureRecognizer:closeV];
    [self.view addSubview:closeLabel];
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSelectedImage)];
    [closeLabel addGestureRecognizer:closeTap];
    
}
-(void)drawSendView{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    text = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendText)];
    [imageView addGestureRecognizer:text];
    showTextView = YES;
    
    UIView *send_icon_view =[[UIView alloc] initWithFrame:CGRectMake(screenWidth-50, screenHeight-50, 50, 50)];
    send_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    send_icon.image = [UIImage imageNamed:@"paper-plane_ffffff_50.png"];
    [send_icon setUserInteractionEnabled:YES];
    [send_icon_view setUserInteractionEnabled:YES];
    [send_icon_view addSubview:send_icon];
    [self.view addSubview:send_icon_view];
    
    UITapGestureRecognizer *sendIt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectChannel)];
    [send_icon_view addGestureRecognizer:sendIt];
    
    selectTime = [[UIView alloc] initWithFrame:CGRectMake(10, screenHeight-60, 40, 40)];
    selectTime.layer.cornerRadius = 5;
    selectTime.layer.masksToBounds = YES;
    CGFloat borderWidth = 2.0f;
    selectTime.frame = CGRectInset(selectTime.frame, -borderWidth, -borderWidth);
    selectTime.layer.borderColor = [UIColor whiteColor].CGColor;
    selectTime.layer.borderWidth = borderWidth;
    
    timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ti = @"10";
    timeL.text = ti;
    timeL.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
    [selectTime addSubview:timeL];
    timeL.textAlignment = NSTextAlignmentCenter;
    [timeL setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:selectTime];
    UITapGestureRecognizer *selT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selTime)];
    [selectTime addGestureRecognizer:selT];
    
    
    closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 50, 50)];
    closeLabel.text = @"X";
    closeLabel.textAlignment  = NSTextAlignmentCenter;
    closeLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:25];
    [closeLabel setTextColor:[UIColor whiteColor]];
    [closeLabel setUserInteractionEnabled:YES];
    //        [closeLabel addGestureRecognizer:closeV];
    [self.view addSubview:closeLabel];
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSelectedImage)];
    [closeLabel addGestureRecognizer:closeTap];

}

-(void)closeSelectedImage{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    float cameraAspectRatio = 4.0 / 3.0;
    float imageWidth = floorf(screenWidth * cameraAspectRatio);
    float scale = ceilf((screenHeight / imageWidth)*10)/10;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0f, 50.0f);
    transform = CGAffineTransformScale(transform, 1.5f, 1.5f);
    storyPicker.cameraViewTransform = transform;
    
    storyPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [imageView removeFromSuperview];
    [sendTextView resignFirstResponder];
    [send_icon removeFromSuperview];
    [send_icon_view removeFromSuperview];
    [myPickerView removeFromSuperview];
    [closeLabel removeFromSuperview];
    [s.view removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
    [apl removeFromSuperview];
    [selectTime removeFromSuperview];
    [sendView removeFromSuperview];
    

}
-(void)selTime{
    [self addPickerView];
}
-(void)sendText{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(showTextView){
        sendView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight/2-50, screenWidth, 40)];
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 35)];
        [blackView setBackgroundColor:[UIColor blackColor]];
        [blackView setAlpha:0.5];
        sendTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 35)];
        [sendTextView setBackgroundColor:[UIColor clearColor]];
        [sendTextView setUserInteractionEnabled:YES];
        [sendTextView setTextColor:[UIColor whiteColor]];
        [sendTextView setScrollEnabled:NO];
        [sendTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]];
        sendTextView.delegate = self;
        [sendTextView setBounces:NO];
        
        [sendTextView becomeFirstResponder];
        
        [sendView addSubview:blackView];
        [sendView addSubview:sendTextView];
        [self.view addSubview:sendView];
        showTextView = NO;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        [sendView addGestureRecognizer:pan];
        
       
        
    }else{
        if(sendTextView.text.length != 0){
            sendTextView.textAlignment = NSTextAlignmentCenter;
            [sendTextView resignFirstResponder];
        }else{
            [sendTextView resignFirstResponder];
            [sendView removeFromSuperview];
            showTextView = YES;
        }
    }
}
-(void)selectChannel{
    [imageView removeGestureRecognizer:text];
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    s = [[SnapchatSelectViewController alloc] init];
    [self addChildViewController:s];
    
    s.view.frame = CGRectMake(0, 50, screenWidth, screenHeight-50);
    [self.view addSubview:s.view];
    s.view.layer.cornerRadius = 10;
    s.view.clipsToBounds = YES;
    
    UIView *sendItView = [[UIView alloc] initWithFrame:CGRectMake(50, s.view.frame.size.height-70, screenWidth-100, 50)];
    [sendItView setBackgroundColor:[UIColor blackColor]];
    [s.view addSubview:sendItView];
    
    UILabel *send = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, sendItView.frame.size.width, 30)];
    send.text = @"Send";
    send.textAlignment = NSTextAlignmentCenter;
    [sendItView addSubview:send];
    send.textColor = [UIColor whiteColor];
    [send setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:17]];
    
    UITapGestureRecognizer *a = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendItt)];
    [sendItView addGestureRecognizer:a];
    
}
-(void)exportDidFinish:(AVAssetExportSession*)session{
    //Play the New Cropped video
    NSURL *outputURL = session.outputURL;
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:outputURL options:nil];
    AVPlayerItem * newPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    videoData = [NSData dataWithContentsOfURL:outputURL];
//    [self Play:outputURL];
    
    PFFile *videoFile = [PFFile fileWithName:@"video.mp4" data:videoData];
    
    [videoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            PFObject *userVideo= [PFObject objectWithClassName:@"UserVideo"];
            //    [userPhoto setObject:@"" forKey:@"imageName"];
            [userVideo setObject:videoFile             forKey:@"imageFile"];
            [userVideo setObject:[PFUser currentUser]  forKey:@"user"];
            [userVideo setObject:[PFInstallation currentInstallation]  forKey:@"installation"];
            
            [userVideo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self downloadAllVideos];
                    
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        
    }];

    
    
}
-(void)sendItt{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIImage *myImage = imageView.image;
    UIImage *watermarkedImage = nil;
    UIImage *im = [self getUIImageFromThisUIView:sendView];
    
    
    CGFloat ratio = screenHeight *3 / 4;
    CGFloat new_ratio = screenWidth *4/3;
    
    CGFloat new_minus = (screenWidth - new_ratio)/2;
    CGFloat minus = (screenHeight - ratio)/2;
    
   
    if([typeOf isEqualToString:@"video"]){
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[avPlayer currentItem]];
        
        CALayer *overlayLayer = [CALayer layer];
        UIImage *overlayImage = nil;
        
        UIGraphicsBeginImageContext(CGSizeMake(screenWidth, screenHeight));
        
        if(![sendTextView.text isEqualToString:@""]){
            [im drawInRect: CGRectMake(sendView.frame.origin.x, sendView.frame.origin.y, sendView.frame.size.width, sendView.frame.size.height)];
        }
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //    NSData *imageDatas = UIImageJPEGRepresentation(smallImage, 0.6f);
        overlayImage = smallImage;
        
        CGSize sss = CGSizeMake([avAsset naturalSize].width,[avAsset naturalSize].height);
        [overlayLayer setContents:(id)[overlayImage CGImage]];
        [overlayLayer setFrame:CGRectMake(0, 0,screenWidth, screenHeight)];
        [overlayLayer setMasksToBounds:YES];
        
        // 2 - set up the parent layer
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0,screenWidth, [avAsset naturalSize].height);
        
        float   angle = M_PI/2 + M_PI;  //rotate 180°, or 1 π radian
        videoLayer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
        
        [videoLayer setFrame:CGRectMake(-([avAsset naturalSize].width - screenWidth)-24, 0,[avAsset naturalSize].width+24,screenHeight)];
        
        [parentLayer addSublayer:videoLayer];
        [parentLayer addSublayer:overlayLayer];
        
        
        AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
        videoComp.renderSize = CGSizeMake([avAsset naturalSize].width, screenHeight);

        videoComp.frameDuration = CMTimeMake(1, 30);
        videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [avAsset duration]);
        AVAssetTrack *videoTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        instruction.layerInstructions = [NSArray arrayWithObjects:layerInstruction,  nil];
        videoComp.instructions = [NSArray arrayWithObject: instruction];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        exporter.videoComposition = videoComp;
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* VideoName = [NSString stringWithFormat:@"%@/mynewwatermarkedvideo.mp4",documentsDirectory];
        NSURL *exportUrl = [NSURL fileURLWithPath:VideoName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:VideoName]){
            [[NSFileManager defaultManager] removeItemAtPath:VideoName error:nil];
        }
        exporter.outputURL = exportUrl;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //Call when finished
                 [self exportDidFinish:exporter];
             });
         }];
        
        
        
    }else{
        UIGraphicsBeginImageContext(CGSizeMake(screenWidth, screenHeight));
        [myImage drawInRect: CGRectMake(new_minus, 0, new_ratio, screenHeight)];
        if(![sendTextView.text isEqualToString:@""]){
            [im drawInRect: CGRectMake(0, sendView.frame.origin.y, sendView.frame.size.width, sendView.frame.size.height)];
        }
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *imageDatas = UIImageJPEGRepresentation(smallImage, 0.6f);
        
        
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageDatas];
        //    [imageFile saveInBackground];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                PFObject *userVideo= [PFObject objectWithClassName:@"UserPhoto"];
                //    [userPhoto setObject:@"" forKey:@"imageName"];
                [userVideo setObject:imageFile           forKey:@"imageFile"];
                [userVideo setObject:[PFUser currentUser]  forKey:@"user"];
                [userVideo setObject:[PFInstallation currentInstallation]  forKey:@"installation"];
                
                [userVideo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [self downloadAllImages];
                        
                    }
                    else{
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            else{
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        } progressBlock:^(int percentDone) {
            
        }];
    }
//
//    [self closeSelectedImage];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)downloadAllImages{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *user = [PFUser currentUser];
//    [query whereKey:@"user" equalTo:user];
    
    
    PFInstallation *instal = [PFInstallation currentInstallation];
    
    [query whereKey:@"installation" equalTo:instal];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *objects, NSError *error) {
        PFFile *t =[objects objectForKey:@"imageFile"];
        imageURL = t.url;
        
        
        NSString *typeOfThing = @"picture";
        NSString *link = imageURL;
        NSString *lengthOfThing = timeL.text;
        NSString *channel = [s.selected componentsJoinedByString:@","];
        
        NSString *newCountryString =[channel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *feed = [NSString stringWithFormat:@"http://www.thewotimes.com/overheard/storyDB.php?type=%@&link=%@&length=%@&channel=%@", typeOfThing, link, lengthOfThing, newCountryString];
        NSURL *url = [NSURL URLWithString:feed];
        NSError *erro;
        NSString *stuff = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&erro];
        NSData *tdata = [stuff dataUsingEncoding:NSUTF8StringEncoding];

        
    }];
   
    
}
- (void)downloadAllVideos{
    PFQuery *query = [PFQuery queryWithClassName:@"UserVideo"];
    PFUser *user = [PFUser currentUser];
    PFInstallation *instal = [PFInstallation currentInstallation];
    
    [query whereKey:@"installation" equalTo:instal];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *objects, NSError *error) {
            PFFile *t =[objects objectForKey:@"imageFile"];
            imageURL = t.url;
            
//            NSLog(@"%@", objects);
            NSString *typeOfThing = typeOf;
            NSString *link = imageURL;
            NSString *lengthOfThing = resultTime;
            NSString *channel = [s.selected componentsJoinedByString:@","];
            
            NSString *newCountryString =[channel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *feed = [NSString stringWithFormat:@"http://www.thewotimes.com/overheard/storyDB.php?type=%@&link=%@&length=%@&channel=%@", typeOfThing, link, lengthOfThing, newCountryString];
            NSURL *url = [NSURL URLWithString:feed];
            NSError *errors;
            NSString *stuff = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&errors];
            NSData *tdata = [stuff dataUsingEncoding:NSUTF8StringEncoding];
            
        
    }];
    
}
-(UIImage*)getUIImageFromThisUIView:(UIView*)aUIView
{
    UIGraphicsBeginImageContext(aUIView.bounds.size);
    [aUIView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)panView:(UIPanGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.view];
        gesture.view.center = CGPointMake(gesture.view.center.x, gesture.view.center.y+translation.y);
        [gesture setTranslation:CGPointZero inView:self.view];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    sendView.frame = CGRectMake(0, screenHeight/2-50, screenWidth, 40);
    sendTextView.textAlignment = NSTextAlignmentLeft;
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length > 31){
        NSRange needleRange = NSMakeRange(0,31);
        NSString *needle = [textView.text substringWithRange:needleRange];
        textView.text = needle;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
//    textView.backgroundColor = [UIColor greenColor];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
//    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
}
-(void)addPickerView{
    pickerArray = [[NSArray alloc]initWithObjects:@"1",
                   @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", @"10", nil];
    
    
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [myPickerView setBackgroundColor:[UIColor whiteColor]];
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    myPickerView.frame = CGRectMake(0, screenHeight-170, screenWidth, 180);

//    [toolBar setItems:toolbarItems];
    [self.view addSubview:myPickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    toolBar.items = [[NSArray alloc] initWithObjects:barButtonDone,nil];
    barButtonDone.tintColor=[UIColor blackColor];
//    [myPickerView addSubview:toolBar];
}

-(void)pickerTapped:(id)sender
{
    NSLog(@"here");
    [myPickerView removeFromSuperview];
}
-(void)done{
    
    [myPickerView removeFromSuperview];

    
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    timeL.text = [pickerArray objectAtIndex:row];
    [myPickerView removeFromSuperview];

//    [myTextField setText:[pickerArray objectAtIndex:row]];
}
-(void)tapped{
    [myPickerView removeFromSuperview];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}


@end
