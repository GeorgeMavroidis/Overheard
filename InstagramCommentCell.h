//
//  InstagramCommentCell.h
//  Feed
//
//  Created by George on 2014-05-12.
//  Copyright (c) 2014 George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramCommentCell : UITableViewCell

@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UIImageView *profile_picture_image_view;
@property (nonatomic, strong) UIImageView *clock_view;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UITextView *text;
@property (nonatomic, strong) NSString *user_id;


@end
