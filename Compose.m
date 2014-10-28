//
//  Compose.m
//  Overheard
//
//  Created by George on 2014-09-18.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Compose.h"
#import <Parse/Parse.h>

#import "MainViewController.h"

//#import <AWSiOSSDKv2/AWSS3.h>
//#import "AWSCore.h"

@interface Compose (){
    UITextView *myUITextView;
    UIView *innercircle;
    UIImageView *location;
    BOOL locationBool;
    UITapGestureRecognizer *picture;
    UIImagePickerController *lib;
    
}
@end

@implementation Compose
@synthesize mainText, picker, iinercircle, footer, circle, overlay, overlayImage, takePicture, movepicture, anon, imageURL;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
//    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/2)];
    [header setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:header];
    
//    UILabel *close = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//    close.text = @"X";
//    close.font = [UIFont fontWithName:@"Avenir-Black" size:20];
//    [header addSubview:close];
    
    mainText = [[UITextView alloc] initWithFrame:CGRectMake(0, 65, screenWidth, 180)];
//    [mainText becomeFirstResponder];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [mainText setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:25]];
    mainText.delegate = self;
    [mainText setBackgroundColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    myUITextView = [[UITextView alloc] initWithFrame:mainText.frame];
//    myUITextView.delegate = self;
    myUITextView.text = @"What did you hear?";
    myUITextView.font = mainText.font;
    myUITextView.textColor = [UIColor lightGrayColor]; //optional
    [myUITextView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:myUITextView];
    [self.view addSubview:mainText];
    
   
    
    footer = [[UIView alloc] initWithFrame:CGRectMake(0, mainText.frame.size.height + mainText.frame.origin.y, screenWidth, 120)];
    [footer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:footer];
    
    anon = [[UISwitch alloc] initWithFrame:CGRectMake(screenWidth-80, 15, 100, 100)];
    [anon addTarget:self action:@selector(switchanon:) forControlEvents:UIControlEventAllEvents];
    [anon setOnTintColor:[UIColor blackColor]];
    [footer addSubview:anon];
    
    location = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 50, 50)];
    location.image = [UIImage imageNamed:@"Location-Icon-Grey.png"];
    location.userInteractionEnabled = YES;
    locationBool = NO;
    UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped)];
    [location addGestureRecognizer:locationTap];
    [footer addSubview:location];
    
    circle = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2-35, 10, 70, 70)];
    [circle setBackgroundColor:[UIColor whiteColor]];
    circle.layer.cornerRadius = 35;
    circle.clipsToBounds = YES;
//    [self.view addSubview:circle];
    
    innercircle = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 70, 70)];
    [innercircle setBackgroundColor:[UIColor blackColor]];
    innercircle.layer.cornerRadius = 55/2;
    innercircle.clipsToBounds = YES;
//    [circle addSubview:innercircle];
    

    iinercircle = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2-32, 0, 64, 64)];
    [iinercircle setBackgroundColor:[UIColor whiteColor]];
    iinercircle.layer.cornerRadius = 64/2;
    iinercircle.clipsToBounds = YES;

    [footer addSubview:iinercircle];
    

    overlay = [[UIView alloc] initWithFrame:iinercircle.frame];
    [overlay setBackgroundColor:[UIColor clearColor]];
    [footer addSubview:overlay];
    
    // Insert the overlay
    
    picture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageselector)];
    circle.userInteractionEnabled = YES;
    footer.userInteractionEnabled = YES;
    iinercircle.userInteractionEnabled = YES;
    picker.view.userInteractionEnabled = YES;
//    picker.delegate = self;
    picker.showsCameraControls = NO;
    [picker.view addGestureRecognizer:picture];
//    [picker setAllowsEditing:YES];
    [overlay addGestureRecognizer:picture];
    
    CGRect frame = iinercircle.frame;
    frame.origin.y -= 20;
    frame.origin.x -= 20;
    frame.size.height += 20;
    frame.size.width += 20;
    picker.view.frame = frame;
    
    
    
    takePicture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takepic)];
    overlayImage = nil;
    movepicture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePic:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    imageURL = @"";
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGRect keyboardRect = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
    CGRect frame = footer.frame;
    frame.origin.y = keyboardRect.origin.y-frame.size.height;
    footer.frame = CGRectMake(0, keyboardRect.origin.y-footer.frame.size.height+50, screenWidth, 80);
    frame = picker.view.frame;
    frame.origin.y = keyboardRect.origin.y-frame.size.height;
//    picker.view.frame = frame;


}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
}
-(void)takepic{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSLog(@"here");
    overlayImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-150)];
    [picker takePicture];
    

}
-(void)movePic:(UIPanGestureRecognizer *)recognizer{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGPoint translation = [recognizer translationInView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if(recognizer.view.frame.origin.y < 150){
            [UIView animateWithDuration:0.80 animations:^{
                CGRect frame = recognizer.view.frame;
                frame.origin.y = 150;
                recognizer.view.frame = frame;
                
            } completion:^(BOOL finished) {
                //        picker.showsCameraControls = YES;
                
            }];
        }else{
            [UIView animateWithDuration:0.80 animations:^{
                CGRect frame = recognizer.view.frame;
                frame.origin.y = screenHeight;
                recognizer.view.frame = frame;
                
            } completion:^(BOOL finished) {
                //        picker.showsCameraControls = YES;
                overlayImage = nil;
                [overlay addGestureRecognizer:takePicture];
                CGRect frame = recognizer.view.frame;
                frame.origin.y = 150;
                recognizer.view.frame = frame;
            }];
        }
    }
   
    recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}
- (void)downloadAllImages{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // If there are photos, we start extracting the data
        // Save a list of object IDs while extracting this data
        
        NSMutableArray *newObjectIDArray = [NSMutableArray array];
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        if (objects.count > 0) {
            PFFile *t =[[objects objectAtIndex:[objects count]-1] objectForKey:@"imageFile"];
            imageURL = t.url;
        }
    }];
    
}
-(void)locationTapped{
    if(locationBool){
        location.image = [UIImage imageNamed:@"Location-Icon-Grey.png"];
        locationBool = NO;
    }else{
        location.image = [UIImage imageNamed:@"Location-Icon-Blue.png"];
        locationBool = YES;
    }
}
- (void)switchanon:(id)sender{
    if([sender isOn]){
        NSLog(@"Switch is ON");
    } else{
        NSLog(@"Switch is OFF");
    }
}
-(void)imageselector{
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take Photo",
                            @"Choose From Camera Roll",
                            @"Remove Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        [self openPeephole];
                    }else{
                        [self openImagePicker];
                    }
                    break;
                case 1:
                    [self openImagePicker];
                    break;
                case 2:
                    
                    [overlayImage removeFromSuperview];
                    overlayImage = nil;
                    break;
                default:
                    
                    break;
            }
            break;
        }
        default:
            break;
    }
}
-(void)openImagePicker{
    lib = [[UIImagePickerController alloc] init];
    [lib setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [lib setAllowsEditing:YES];
    lib.delegate =self;
    [self presentModalViewController:lib animated:YES];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [lib dismissViewControllerAnimated:YES completion:nil];
    [mainText becomeFirstResponder];
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    // Access the uncropped image from info dictionary
    NSLog(@"picutre here");
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    overlayImage = [[UIImageView alloc] initWithFrame:iinercircle.frame];
    overlayImage.image = image;
    overlayImage.clipsToBounds = YES;
    [overlay addSubview:overlayImage];
    
    // Save image
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
    
//    [refreshHUD hide:YES];
}
-(void)uploadImage:(NSData *)imageData{
    
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
    [lib dismissViewControllerAnimated:YES completion:nil];
    [mainText becomeFirstResponder];
    
}
-(void)openLib{
    
    //
    //    [picker setAllowsEditing:YES];
    //
    //    picker.showsCameraControls = YES;
    
    //    [self presentModalViewController:picker animated:YES];
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [UIView animateWithDuration:0.50 animations:^{
        CGRect frame = circle.frame;
        frame = CGRectMake(0, 0, screenWidth, screenHeight-40);
        circle.frame = frame;
        iinercircle.frame = frame;
        innercircle.frame = frame;
        frame = CGRectMake(0, 150, screenWidth, screenHeight-40);
        footer.frame = frame;

        overlay.frame = iinercircle.frame;
        //        overlayImage.frame = frame;
        frame = CGRectMake(0, 0, screenWidth, screenHeight-40);
        picker.view.frame = frame;
        picker.view.userInteractionEnabled = YES;
        
        frame = CGRectMake(0, 0, screenWidth, screenHeight-40);
        overlayImage.frame = frame;
        [overlayImage removeFromSuperview];
        overlayImage = nil;
        
        [mainText resignFirstResponder];
        
        iinercircle.layer.cornerRadius = 0;
        
        overlay.layer.cornerRadius = 0;
        
        
        if(overlayImage == nil){
//            [overlay addGestureRecognizer:takePicture];
        }else{
//            [overlay addGestureRecognizer:movepicture];
            
        }
    } completion:^(BOOL finished) {
        //        picker.showsCameraControls = YES;
        
    }];
}

-(void)openPeephole{

//
//    [picker setAllowsEditing:YES];
//    
//    picker.showsCameraControls = YES;

//    [self presentModalViewController:picker animated:YES];
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [UIView animateWithDuration:0.50 animations:^{
        CGRect frame = circle.frame;
        frame = CGRectMake(0, 0, screenWidth, screenHeight-150);
        circle.frame = frame;
        iinercircle.frame = frame;
        innercircle.frame = frame;
        frame = CGRectMake(0, 150, screenWidth, screenHeight-150);
        footer.frame = frame;
        
        overlay.frame = iinercircle.frame;
        //        overlayImage.frame = frame;
        frame = CGRectMake(0, 0, screenWidth, screenHeight-150);
        picker.view.frame = frame;
        frame = CGRectMake(0, 0, screenWidth, screenHeight-150);
        overlayImage.frame = frame;
        [overlayImage removeFromSuperview];
        overlayImage = nil;
//        overlayImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-150)];
//        overlayImage.image = [[UIImage alloc] init];
        [mainText resignFirstResponder];
        
        iinercircle.layer.cornerRadius = 0;
        
        overlay.layer.cornerRadius = 0;
        
        [overlay setUserInteractionEnabled:YES];
        if(overlayImage == nil){
            [overlay addGestureRecognizer:takePicture];
        }else{
            [overlay addGestureRecognizer:movepicture];
            
        }
    } completion:^(BOOL finished) {
        //        picker.showsCameraControls = YES;
        
    }];
}


- (void)keyboardWillChange:(NSNotification *)notification {
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if (mainText.text.length > 0) {
        myUITextView.text = @"";
        myUITextView.textColor = [UIColor lightGrayColor]; //optional
    }
    if (mainText.text.length == 0) {
        myUITextView.text = @"What did you hear?";
        myUITextView.textColor = [UIColor lightGrayColor]; //optional
    }
    if(innercircle.frame.origin.x == 0){
        [UIView animateWithDuration:0.25 animations:^{
            iinercircle.frame =CGRectMake(screenWidth/2-32, 0, 64, 64);
            [iinercircle setBackgroundColor:[UIColor whiteColor]];
            iinercircle.layer.cornerRadius = 64/2;
            overlay.layer.cornerRadius = 64/2;
            iinercircle.clipsToBounds = YES;
            overlay.frame = iinercircle.frame;
            
            CGRect frame = overlayImage.frame;
            frame.origin.y = -10;
            frame.origin.x = -10;
            frame.size.height = 75;
            frame.size.width = 75;
            overlayImage.frame = frame;
            //            picker.view.frame = frame;
            [overlay removeGestureRecognizer:takePicture];
            
        } completion:^(BOOL finished) {
            
//            picker.showsCameraControls = NO;
        }];
    }

//    [textView becomeFirstResponder];
}
-(void)textViewDidChange:(UITextView *)textView{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (mainText.text.length > 0) {
        myUITextView.text = @"";
        myUITextView.textColor = [UIColor lightGrayColor]; //optional
    }
    if (mainText.text.length == 0) {
        myUITextView.text = @"What did you hear?";
        myUITextView.textColor = [UIColor lightGrayColor]; //optional
    }
    
    }
- (void)textViewDidEndEditing:(UITextView *)textView
{
//    if ([myUITextView.text isEqualToString:@""]) {
//        myUITextView.text = @"placeholder text here...";
//        myUITextView.textColor = [UIColor lightGrayColor]; //optional
//    }
//    [textView resignFirstResponder];
}
@end