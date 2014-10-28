//
//  InstagramCommentViewController.h
//  Feed
//
//  Created by George on 2014-05-12.
//  Copyright (c) 2014 George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramCommentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate>
-(id)initWithMedia:(NSString *)media;
@end
