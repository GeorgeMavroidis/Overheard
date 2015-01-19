//
//  MainViewController.m
//  Overheard
//
//  Created by George on 2014-09-16.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import "MainViewController.h"
#import "PublicFeed.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Compose.h"
 #import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "SnapchatViewController.h"
#import "MBProgressHUD.h"
#include <stdlib.h>
#import "StoryCreatorViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MainViewController (){
    UIWebView *webview;
    
    UIView *facebookBar, *bottomBar, *publicFeed;
    NSUserDefaults *defaults;
    
    Compose *compose;
    UIImagePickerController *picker;
    UIPageControl *pageControl;
    UIScrollView *tutorial, *mainScrollView;
    
    CLLocationManager *locationManager;
    
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
    SnapchatViewController *snap;
    UIImagePickerController *storyPicker;
}

@end

@implementation MainViewController
@synthesize ptv;
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
    HUD = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"Overheard @ Guelph";
//    
//    [self.navigationController setNavigationBarHidden:YES];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:166.0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
//    self.navigationController.navigationBar.translucent = NO;
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
}
-(void)viewDidAppear:(BOOL)animated{
    defaults = [NSUserDefaults standardUserDefaults];
    
        [self noAction];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [bottomBar setHidden:YES];
        [self setTitle:@"Overheard @ Guelph"];
        CGRect frame = publicFeed.frame;
        frame.origin.y -= 40;
        frame.size.height += 40;
        publicFeed.frame = frame;
        
        frame = ptv.view.frame;
        frame.size.height += 50;
        ptv.view.frame = frame;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1; //this provide you the page number
    pageControl.currentPage = page;// this displays the white dot as current page
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1; //this provide you the page number
//    pageControl.currentPage = page;// this displays the white dot as current page
    defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"facebook_data"] != nil){
        if(page == 1){
            [self initCamera];
        }
    }else{
        if(page == 0){
            
            [bottomBar setHidden:YES];
        }
        if(page == 1){
            [bottomBar setHidden:NO];
            
            //        UIAlertView *requestContacts = [[UIAlertView alloc] initWithTitle: @"Can we have access to your address book?" message: @"You must give the app permission to your contact list" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            //        requestContacts.delegate = self;
            //        [requestContacts show];
            
            CGRect screenRect = self.view.bounds;
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = bottomBar.frame;
                frame.origin.y = 20;
                bottomBar.frame = frame;
                frame = publicFeed.frame;
                frame.origin.y = 90;
                frame.size.width = screenWidth;
                frame.size.height = screenHeight-90;
                publicFeed.frame = frame;
                [pageControl setHidden:YES];
                
            } completion:^(BOOL finished) {
            }];

//            [bottomBar setHidden:YES];
//            UIAlertView *push = [[UIAlertView alloc] initWithTitle: @"We need your location" message: @"You must give permission to use location services" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
//            push.delegate = self;
////            [push show];
            
        }
        if(page == 2){
            [bottomBar setHidden:YES];
            
            if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                                UIUserNotificationTypeBadge |
                                                                UIUserNotificationTypeSound);
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                         categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            } else {
                // Register for Push Notifications before iOS 8
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                                       UIRemoteNotificationTypeAlert |
                                                                                       UIRemoteNotificationTypeSound)];
            }
            
        }
        if(page == 3) {
            
            [bottomBar setHidden:NO];
            
            //        UIAlertView *requestContacts = [[UIAlertView alloc] initWithTitle: @"Can we have access to your address book?" message: @"You must give the app permission to your contact list" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            //        requestContacts.delegate = self;
            //        [requestContacts show];
            
            CGRect screenRect = self.view.bounds;
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = bottomBar.frame;
                frame.origin.y = 20;
                bottomBar.frame = frame;
                frame = publicFeed.frame;
                frame.origin.y = 90;
                frame.size.width = screenWidth;
                frame.size.height = screenHeight-90;
                publicFeed.frame = frame;
                [pageControl setHidden:YES];
                
            } completion:^(BOOL finished) {
            }];
            
        }
        if(page == 4) {
            
        }
    }
}
-(void)initCamera{
    
//    
//    CGRect screenRect = self.view.bounds;
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    storyPicker = nil;
//    storyPicker = [[UIImagePickerController alloc] init];
//
//    storyPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    storyPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//    storyPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//    storyPicker.showsCameraControls = NO;
////    storyPicker.navigationBarHidden = YES;
////    storyPicker.toolbarHidden = YES;
////    storyPicker.wantsFullScreenLayout = YES;
//    
//    [snap.view addSubview:storyPicker.view];
//    storyPicker.view.frame = CGRectMake(0, screenHeight-200, screenWidth, screenHeight);
}
-(void)nullCamera{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    CGFloat pageWidth = tutorial.frame.size.width;
    int page = floor((tutorial.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1; //this provide you the page number
    //    pageControl.currentPage = page;// this displays the white dot as current page
    
    if(page == 0){
        
        
    }
    if(page == 1){
        locationManager = [[CLLocationManager alloc] init];
        if(IS_OS_8_OR_LATER) {
            [locationManager requestAlwaysAuthorization];
        }
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];

        
    }
    if(page == 2){
        
    }
    if(page == 3){
        if(buttonIndex == 0){
            ABAddressBookRef addressBook = ABAddressBookCreate();
            __block BOOL accessGranted = NO;
            if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    accessGranted = granted;
                    dispatch_semaphore_signal(sema);
                });
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            }
            else { // we're on iOS 5 or older
                accessGranted = YES;
            }
            
            if (accessGranted) {
                
            }
            
        }
        
    }

    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Getting Location");
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    compose = [[Compose alloc] init];
    compose.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed: 210/255.0 green: 210/255.0 blue:210/255.0 alpha: 0.4];
    // Create CGRects for frames
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    publicFeed = [[UIView alloc] init];
    
    publicFeed = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight)];
    publicFeed.backgroundColor = [UIColor whiteColor];
    
    bottomBar = [[UIView alloc] init];
    bottomBar.frame = CGRectMake(0, screenHeight-80, screenWidth, 80);
    bottomBar.backgroundColor = [UIColor whiteColor];
    
    snap = [[SnapchatViewController alloc] init];
    
    
   
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ptv = [[PublicFeed alloc] init];
    ptv.view.frame = CGRectMake(0, 0, screenWidth, screenHeight-90);
    
    NSLog(@"%@", [defaults objectForKey:@"facebook_data"]);
    
        mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        mainScrollView.delegate = self;
        [mainScrollView setContentSize:CGSizeMake(screenWidth*2, screenHeight-10)];

        [mainScrollView setPagingEnabled:YES];
        [mainScrollView setUserInteractionEnabled:YES];
        [mainScrollView setBounces:NO];
        
        [self.view addSubview:mainScrollView];
        [mainScrollView addSubview:compose.view];
        [mainScrollView addSubview:publicFeed];
        [pageControl setHidden:YES];
        [self noAction];
        
        [mainScrollView addSubview:snap.view];
        snap.view.frame = CGRectMake(screenWidth, 60, screenWidth, screenHeight);
        [self addChildViewController:snap];
        
        
        
        
        ptv.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        publicFeed.frame = CGRectMake(0, -100, screenWidth, screenHeight);
        mainScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    compose.view.frame = CGRectMake(0, -screenHeight, screenWidth, screenHeight);
    [publicFeed addSubview:ptv.view];
    [self addChildViewController:ptv];
    
    UIBarButtonItem *composed = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem=composed;
    
    UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(story)];
    self.navigationItem.leftBarButtonItem = camera;
    
    if([defaults objectForKey:@"unlocked"] == nil){
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"locsk.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lockAction)forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, -5, 40, 45)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 50, 20)];
        [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
        [label setBackgroundColor:[UIColor clearColor]];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = barButton;
    }
    //
//    picker.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
    
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [compose.view addSubview:refreshHUD];
    
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
    PFInstallation *pfi = [PFInstallation currentInstallation];
    PFUser *pfuser = [PFUser user];
    pfuser.username = pfi.installationId;
    pfuser.password = @"";
    
    [pfuser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            PFInstallation *installation = [PFInstallation currentInstallation];
            installation[@"user"] = [PFUser currentUser];
            installation[@"installation_id"] = pfi.installationId;
            [installation saveInBackground];
        } else {
            
            
            PFInstallation *installation = [PFInstallation currentInstallation];
            [PFUser logInWithUsernameInBackground:installation.installationId password:@""
                                            block:^(PFUser *pfuser, NSError *error) {
                                                    NSLog(@"%@", pfuser);
                                                    PFInstallation *installation = [PFInstallation currentInstallation];
                                                    installation[@"user"] = [PFUser currentUser];
                                                    installation[@"installation_id"] = pfi.installationId;
                                                    [installation saveInBackground];
                                              
                                            }];
        }
    }];
    
    UIView *search = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    [search setBackgroundColor:[UIColor clearColor]];
    [publicFeed addSubview:search];
    
    UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    [search addSubview:sb];

}
-(void)launchStoryCreator{
    StoryCreatorViewController *storyVC = [[StoryCreatorViewController alloc] init];
    [self.navigationController pushViewController:storyVC animated:NO];
}
-(void)agggg{
    NSLog(@"here");
    NSURL *url = [NSURL URLWithString:@"http://www.tryoverheard.com/legal.html"];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"www.tryoverheard.com/legal.html"]];
}
-(void)lockAction{
    NSMutableArray *sharingItems = [NSMutableArray new];
    [sharingItems addObject:@"Check out the new Overheard At Guelph App in the App Store!"];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    compose.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    compose.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    [compose.picker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    NSLog(@"here");
    [compose.picker dismissViewControllerAnimated:YES completion:NULL];
    [compose.mainText becomeFirstResponder];
    [self cancel];
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    // Access the uncropped image from info dictionary
    NSLog(@"picutre here");
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    compose.overlayImage.image = image;
    compose.overlay.clipsToBounds = YES;
    [compose.overlay addSubview:compose.overlayImage];
//    [compose.overlay addGestureRecognizer:compose.movepicture];
//    [compose.overlay removeGestureRecognizer:compose.takePicture];
    // Save image
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
    
    [refreshHUD hide:YES];
}
-(void)uploadImage:(NSData *)imageData{
    
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    
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
- (void)downloadAllImages{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *user = [PFUser currentUser];
    //    [query whereKey:@"user" equalTo:user];
    
    
    PFInstallation *instal = [PFInstallation currentInstallation];
    
    [query whereKey:@"installation" equalTo:instal];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *objects, NSError *error) {
        PFFile *t =[objects objectForKey:@"imageFile"];
        compose.imageURL = t.url;
        
        
        
    }];
    
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
    [compose.picker dismissViewControllerAnimated:YES completion:nil];
    [compose.mainText becomeFirstResponder];
    
}
-(void)story{
//    SnapchatViewController *snap = [[SnapchatViewController alloc] init];
//    
//    [self.navigationController pushViewController:snap animated:YES];
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [mainScrollView setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
    [self initCamera];
}


-(void)compose{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    compose = [[Compose alloc] init];
    [self addChildViewController:compose];
    [self.view addSubview:compose.view];
    compose.view.frame = CGRectMake(0, -screenHeight, screenWidth, screenHeight);
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    compose.picker = [[UIImagePickerController alloc] init];
//    compose.picker.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
   
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
        
    }else{//other action}
        compose.picker = [[UIImagePickerController alloc] init];
        compose.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        compose.picker.showsCameraControls = YES;
        compose.picker.delegate = self;
    }
    float cameraAspectRatio = 4.0 / 3.0;
    float imageWidth = floorf(screenWidth * cameraAspectRatio);
    float scale = ceilf((screenHeight / imageWidth) * 10.0) / 10.0;
    
    [UIView animateWithDuration:0.50 animations:^{
        CGRect frame = publicFeed.frame;
        frame.origin.y = screenHeight;
        publicFeed.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.50 animations:^{
        compose.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        [compose.mainText becomeFirstResponder];
        
    } completion:^(BOOL finished) {
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem=cancel;
        UIBarButtonItem *post = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
        self.navigationItem.rightBarButtonItem=post;
        self.title = @"Post";
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }];
}
-(void)send{
    NSString *posts = compose.mainText.text;
    if(posts.length > 0){
        
        NSURL *aUrl = [NSURL URLWithString:@"http://www.thewotimes.com/posts.php"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                     delegate:self];
        
        [request setHTTPMethod:@"POST"];
        
        NSString *user = @"";
        NSString *name = @"";
        NSString *profile_picture = @"";
        
            user = [NSString stringWithFormat:@"Anonymous-%@",[[defaults objectForKey:@"facebook_data"] valueForKey:@"id"]];
            name = @"Anonymous";
        
        
            profile_picture = @"";
        
        NSString *postString = @"";
        
        if([compose.imageURL isEqualToString:@""]){
            postString = [NSString stringWithFormat:@"post=%@&user=%@&name=%@&profile_picture=%@", posts, user, name, profile_picture];
            
        }else{
            
            postString = [NSString stringWithFormat:@"post=%@&user=%@&name=%@&image=%@&profile_picture=%@", posts, user, name, compose.imageURL, profile_picture];
            
        }
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        compose.mainText.text = @"";
        compose.overlayImage  =nil;
        compose.imageURL = @"";
        [ptv.main_tableView reloadData];
        
        [self cancel];
    }
}
-(void)cancel{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
//    [picker removeFromParentViewController];
//    [picker.view removeFromSuperview];
    
    [UIView animateWithDuration:0.50 animations:^{
        CGRect frame = compose.view.frame;
        frame.origin.y = -screenHeight;
        compose.view.frame = frame;
        
    } completion:^(BOOL finished) {
        [compose.picker.view removeFromSuperview];
        [compose.picker removeFromParentViewController];
        [compose removeFromParentViewController];
        [compose.view removeFromSuperview];
        
    }];
    [UIView animateWithDuration:0.50 animations:^{
        publicFeed.frame = CGRectMake(0, 60, screenWidth, screenHeight);
        [compose.mainText resignFirstResponder];
        
        
    } completion:^(BOOL finished) {
        UIBarButtonItem *composeBut = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
        self.navigationItem.rightBarButtonItem=composeBut;
        UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(story)];
        self.navigationItem.leftBarButtonItem = camera;
        [self initCamera];
        //        UIBarButtonItem *post = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(compose)];
//        self.navigationItem.leftBarButtonItem=nil;
        self.title = @"Overheard @ Guelph";
        if([defaults objectForKey:@"unlocked"] == nil){
            UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"locsk.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(lockAction)forControlEvents:UIControlEventTouchUpInside];
            [button setFrame:CGRectMake(0, -5, 40, 45)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 50, 20)];
            [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
            [label setBackgroundColor:[UIColor clearColor]];
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//            self.navigationItem.leftBarButtonItem = barButton;
        }
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }];

}
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
-(void) pan:(UIPanGestureRecognizer *)sender{
    
    CGPoint translation = [(UIPanGestureRecognizer*)sender translationInView:self.view];

    if(bottomBar.frame.origin.y > 20){
        sender.view.center = CGPointMake(sender.view.center.x, sender.view.center.y + translation.y);
        [sender setTranslation:CGPointZero inView:self.view];
        publicFeed.center = CGPointMake(publicFeed.center.x, publicFeed.center.y + translation.y);
    }
    if(sender.state == UIGestureRecognizerStateEnded){
        [self action];
        [bottomBar removeGestureRecognizer:sender];
    }
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    PFUser *pfuser = [PFUser user];
    pfuser.username = user.id;
    pfuser.password = @"";
    //    pfuser.email = @"email@example.com";
    pfuser[@"name"] = user.name;
    pfuser[@"facebook_data"] = user;

    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    ptv.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    publicFeed.frame = CGRectMake(0, -100, screenWidth, screenHeight);
    mainScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    
    [pfuser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            PFInstallation *installation = [PFInstallation currentInstallation];
            installation[@"user"] = [PFUser currentUser];
            installation[@"facebook_data"] = user;
            installation[@"name"] = user.name;
            installation[@"username"] = user.id;
            [installation saveInBackground];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [PFUser logInWithUsernameInBackground:user.id password:@""
                                            block:^(PFUser *pfuser, NSError *error) {
                                                if (user) {
                                                    NSLog(@"%@", pfuser);
                                                    PFInstallation *installation = [PFInstallation currentInstallation];
                                                    installation[@"user"] = [PFUser currentUser];
                                                    installation[@"facebook_data"] = user;
                                                    installation[@"name"] = user.name;
                                                    installation[@"username"] = user.id;
                                                    [installation saveInBackground];
                                                    // Do stuff after successful login.
                                                } else {
                                                    // The login failed. Check error to see why.
                                                }
                                            }];
        }
    }];
    NSLog(@"%@",user);
    [defaults setObject:user forKey:@"facebook_data"];

    [self noAction];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [bottomBar setHidden:YES];
    [self setTitle:@"Overheard @ Guelph"];
//    CGRect frame = publicFeed.frame;
//    frame.origin.y -= 30;
//    frame.size.height += 30;
//    publicFeed.frame = frame;
//    
//    frame = ptv.view.frame;
//    frame.size.height += 50;
//    ptv.view.frame = frame;
//    
//    frame = publicFeed.frame;
//    frame.origin.y -= 40;
//    frame.size.height += 40;
//    publicFeed.frame = frame;
//    
//    frame = ptv.view.frame;
//    frame.size.height += 50;
    //        frame.origin.y = 0;
//    ptv.view.frame = frame;
    
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    mainScrollView.delegate = self;
    [mainScrollView setContentSize:CGSizeMake(screenWidth*2, screenHeight-10)];
    
    [mainScrollView setPagingEnabled:YES];
    [mainScrollView setUserInteractionEnabled:YES];
    [mainScrollView setBounces:NO];
    
    [self.view addSubview:mainScrollView];
    [mainScrollView addSubview:compose.view];
    [mainScrollView addSubview:publicFeed];
    [pageControl setHidden:YES];
    [self noAction];
    
    [mainScrollView addSubview:snap.view];
    snap.view.frame = CGRectMake(screenWidth, 60, screenWidth, screenHeight);
    [self addChildViewController:snap];

    [self compose];
    [self cancel];
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    facebookBar.text = @"You're logged in as";
}
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
-(void) action{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = bottomBar.frame;
        frame.origin.y = 20;
        bottomBar.frame = frame;
        frame = publicFeed.frame;
        frame.origin.y = bottomBar.frame.size.height + bottomBar.frame.origin.y;
        publicFeed.frame = frame;
        
        CALayer *layer = bottomBar.layer;
        
        layer.shadowColor = (__bridge CGColorRef)([UIColor blackColor]);
        layer.shadowOffset = CGSizeMake(0,  5);
        layer.shadowOpacity = 0.1;
        layer.shadowRadius = 10;
        
        layer = facebookBar.layer;
        
        layer.shadowColor = (__bridge CGColorRef)([UIColor whiteColor]);
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowOpacity = 0.0;
        layer.shadowRadius = 0;

    } completion:^(BOOL finished) {
    }];
}
-(void) noAction{
        CGRect frame = bottomBar.frame;
        frame.origin.y = 20;
        bottomBar.frame = frame;
        frame = publicFeed.frame;
        frame.origin.y = bottomBar.frame.size.height + bottomBar.frame.origin.y;
        publicFeed.frame = frame;
        
        CALayer *layer = bottomBar.layer;
        
        layer.shadowColor = (__bridge CGColorRef)([UIColor blackColor]);
        layer.shadowOffset = CGSizeMake(0,  5);
        layer.shadowOpacity = 0.1;
        layer.shadowRadius = 10;
        
        layer = facebookBar.layer;
        
        layer.shadowColor = (__bridge CGColorRef)([UIColor whiteColor]);
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowOpacity = 0.0;
        layer.shadowRadius = 0;
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
