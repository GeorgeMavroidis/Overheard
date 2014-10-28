//
//  FeedCell.m
//  Overheard
//
//  Created by George on 2014-09-17.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedCell.h"


@interface CustomTableViewCell (){
}
@end

@implementation CustomTableViewCell
@synthesize cellIdentifier, card, textView, profileImage, usernameLabel, up, down, likes, timeLabel, mainImage, isPic, flag;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellIdentifier  = @"cellIdentifier";
        card = [[UIView alloc] init];
        textView = [[UITextView alloc] init];
        profileImage = [[UIImageView alloc] init];
        usernameLabel = [[UILabel alloc] init];
        up = [[UIImageView alloc] init];
        down = [[UIImageView alloc] init];
        likes = [[UILabel alloc] init];
        mainImage = [[UIImageView alloc] init];
        timeLabel = [[UILabel alloc] init];
        isPic = NO;
        CGRect screenRect = self.bounds;
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
//        self.backgroundColor = [UIColor colorWithRed: 210/255.0 green: 210/255.0 blue:210/255.0 alpha: 0.4];
        self.backgroundColor = [UIColor clearColor];
        
        card.frame = CGRectMake(15, 10, screenWidth-30, 300-20);
        card.backgroundColor = [UIColor whiteColor];
        card.layer.cornerRadius = 4;
        card.clipsToBounds = true;
        [self addSubview:card];
        
        usernameLabel.frame = CGRectMake(65, 20, screenWidth, 30);
        usernameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size:14];
        //        usernameLabel.backgroundColor = UIColor.redColor()
        [self addSubview:usernameLabel];
        
        timeLabel.frame = CGRectMake(screenWidth-100, 20, 70, 30);
        timeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size:12];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
        [self addSubview:timeLabel];
        
        profileImage.frame = CGRectMake(25, 22, 30, 30);
        profileImage.layer.cornerRadius = 15;
        profileImage.layer.masksToBounds = YES;
        profileImage.layer.borderWidth = 0;
        [self addSubview:profileImage];
        
        textView.frame = CGRectMake(25, 60, screenWidth-40, 200);
        textView.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 16];
        textView.userInteractionEnabled = false;
        [self addSubview:textView];
        
        
        
        mainImage.frame = CGRectMake(5, textView.frame.size.height+textView.frame.origin.y, screenWidth-10, 300);
        mainImage.contentMode = UIViewContentModeScaleAspectFill;
        mainImage.layer.cornerRadius = 5;
        mainImage.clipsToBounds = YES;
        [self addSubview:mainImage];
        //        var t = 45
        
        up.frame = CGRectMake((screenWidth/2)-(45/2)-40, 300-80, 30, 30);
        up.image = [UIImage imageNamed: @"up.png"];
        [self addSubview:up];
        
        down.frame = CGRectMake(screenWidth/2-(45/2)+40, 300-80, 30, 30);
        down.image = [UIImage imageNamed: @"down.png"];
        [self addSubview:down];
        
        likes.frame = CGRectMake(screenWidth/2-32, 300-140, 50, 45);
        likes.textAlignment = NSTextAlignmentCenter;
        likes.font = [UIFont fontWithName:@"HelveticaNeue-Light" size: 16];
        [self addSubview:likes];
        
        flag =[[UILabel alloc] initWithFrame:CGRectMake(screenWidth-90, up.frame.origin.y, 100, 20)];
        flag.textAlignment = NSTextAlignmentCenter;
        flag.font = [UIFont fontWithName:@"HelveticaNeue-Light" size: 16];
        flag.text = @". . .";
        [self addSubview:flag];
//        [likes setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}


@end