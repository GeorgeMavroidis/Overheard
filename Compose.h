//
//  Compose.h
//  Overheard
//
//  Created by George on 2014-09-18.
//  Copyright (c) 2014 Overheard. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface Compose : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) UITextView *mainText;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIView *iinercircle;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UIView *circle;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) UIImageView *overlayImage;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UITapGestureRecognizer *takePicture;
@property (nonatomic, strong) UIPanGestureRecognizer *movepicture;
@property (nonatomic, strong) UISwitch *anon;
//@property (nonatomic, retain) BOOL *locationBool;

@property (nonatomic, weak) IBOutlet UILabel *uploadStatusLabel;
@property (nonatomic, weak) IBOutlet UIButton *uploadButton;
@property (nonatomic, weak) IBOutlet UIButton *pauseButton;
@property (nonatomic, weak) IBOutlet UIButton *resumeButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

- (IBAction)uploadButtonPressed:(id)sender;
- (IBAction)pauseButtonPressed:(id)sender;
- (IBAction)resumeButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end


