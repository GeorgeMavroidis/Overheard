//
//  InstagramCommentCell.m
//  Feed
//
//  Created by George on 2014-05-12.
//  Copyright (c) 2014 George. All rights reserved.
//

#import "InstagramCommentCell.h"
#import "InstagramCommentCell.h"

@implementation InstagramCommentCell
@synthesize username, profile_picture_image_view, clock_view, time, text, user_id;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        [self setBackgroundColor:[UIColor clearColor]];
        username = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, screenWidth, 20)];
        [self addSubview:username];
        user_id = @"";
        profile_picture_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 32, 32)];
        CALayer *imageLayer = profile_picture_image_view.layer;
        [imageLayer setCornerRadius:32/2];
        [imageLayer setMasksToBounds:YES];
        [self addSubview:profile_picture_image_view];
        
        clock_view = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-48, 16.5, 15, 15)];
        clock_view.image = [UIImage imageNamed:@"clocks.png"];
        //[self addSubview:clock_view];

        time = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 40, 10, screenWidth, 30)];
        time.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
        time.textColor = [UIColor lightGrayColor];
        [self addSubview:time];
        
        text = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, screenWidth-50, 1000)];
        text.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15.0f];
        text.userInteractionEnabled = NO;
        [text setBackgroundColor:[UIColor clearColor]];
        [self addSubview:text];
        


    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
