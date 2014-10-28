//
//  MainViewController.h
//  Overheard
//
//  Created by George on 2014-09-17.
//  Copyright (c) 2014 Overheard. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PublicFeed.h"

@interface MainViewController : UIViewController <FBLoginViewDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate>

-(void)compose;
@property (strong, nonatomic) PublicFeed *ptv;
@end

