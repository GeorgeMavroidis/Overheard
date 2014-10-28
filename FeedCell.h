//
//  FeedCell.h
//  Overheard
//
//  Created by George on 2014-09-17.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *up;
@property (nonatomic, strong) UIImageView *down;
@property (nonatomic, strong) UILabel *likes;
@property (nonatomic, strong) UIView * card;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *flag;
@property (nonatomic, strong) UIImageView *mainImage;


@property (nonatomic, strong) NSString * cellIdentifier;
@property (nonatomic, assign) BOOL  isPic;

@end