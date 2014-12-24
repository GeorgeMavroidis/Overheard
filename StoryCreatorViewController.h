//
//  StoryCreatorViewController.h
//  Overheard
//
//  Created by George on 2014-12-02.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryCreatorViewController : UIViewController<UIImagePickerControllerDelegate, UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSString *imageURL;
@end
