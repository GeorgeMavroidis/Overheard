//
//  StoryViewController.h
//  Overheard
//
//  Created by George on 2014-12-07.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryViewController : UIViewController

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSString *removed;

@property (nonatomic, strong) NSMutableArray *n;
-(void)provisionStory;
@end
