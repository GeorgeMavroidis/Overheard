//
//  PublicFeed.h
//  Overheard
//
//  Created by George on 2014-09-17.
//  Copyright (c) 2014 Overheard. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface PublicFeed : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) UITableView *main_tableView;
-(void)fetchFeeds;
@end
