//
//  PublicFeed.m
//  Overheard
//
//  Created by George on 2014-09-17.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import "PublicFeed.h"
#import "FeedCell.h"
#import "AsyncImageView.h"
//#import "UIImageView+WebCache.h"
#import <UIImageView+WebCache.h>
#import "InstagramCommentViewController.h"


@interface PublicFeed (){
    NSString *cellIdentifier;
    NSMutableArray *tableData;
    NSArray *json;
    UIView *mainPost, *mainPostHeader, *lower, *comment;
    UIScrollView *commentView;
    UIRefreshControl * refresh;
    CGFloat y_retained;
    BOOL isPic;
    
    UIView *inputBar;
    UITextView *inputTextView;
    UIView *sendText;
    UILabel *send;
    UILabel *placeholderLabel;
    NSString *postid;
}
@end

@implementation PublicFeed
@synthesize main_tableView;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];

//    if([d objectForKey:@"likes"] == nil){
        NSMutableArray *m = [[NSMutableArray alloc] init];
        [d setObject:m forKey:@"likes"];
//    }
//    if([d objectForKey:@"dislikes"] == nil){
        NSMutableArray *t = [[NSMutableArray alloc] init];
        [d setObject:t forKey:@"dislikes"];
//    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    isPic = NO;
    cellIdentifier = @"cellIdentifier";
    json = [[NSArray alloc] init];
    main_tableView = [[UITableView alloc] init];
    main_tableView.backgroundColor =[UIColor colorWithRed: 210/255.0 green: 210/255.0 blue:210/255.0 alpha: 0.4];
    main_tableView.delegate = self;
    main_tableView.dataSource = self;

    self.view = main_tableView;
    main_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [main_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    main_tableView.showsVerticalScrollIndicator = NO;
    [self fetchFeeds];
    
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [main_tableView addSubview:refresh];
    
    
    mainPostHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -50, screenWidth, 50)];
    [mainPostHeader setBackgroundColor:[UIColor whiteColor]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:mainPostHeader];
    
    UILabel *closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 50)];
    closeLabel.text = @"X";
    closeLabel.font = [UIFont fontWithName:@"Avenir-Black" size:24];
    [mainPostHeader setUserInteractionEnabled:YES];
    
    [mainPostHeader addSubview:closeLabel];
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePost)];
    [mainPostHeader addGestureRecognizer:closeTap];
    
    lower = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [lower setBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardDidChangeFrameNotification object:nil];
    
    inputBar = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-50, screenWidth, 50)];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGRect screenRect = [[UIApplication sharedApplication] keyWindow].bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        CGRect keyboardRect = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardRect = [[[UIApplication sharedApplication] keyWindow] convertRect:keyboardRect fromView:nil]; //this is it!
        CGRect frame = inputBar.frame;
        frame.origin.y = keyboardRect.origin.y-frame.size.height;
        inputBar.frame =frame;
        
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    
}
- (void)keyboardWillChange:(NSNotification *)aNotification {
    CGRect screenRect = [[UIApplication sharedApplication] keyWindow].bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        CGRect keyboardRect = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardRect = [[[UIApplication sharedApplication] keyWindow] convertRect:keyboardRect fromView:nil]; //this is it!
        CGRect frame = inputBar.frame;
        frame.origin.y = keyboardRect.origin.y-frame.size.height;
        inputBar.frame =frame;
        
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect screenRect = [[UIApplication sharedApplication] keyWindow].bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        CGRect keyboardRect = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardRect = [[[UIApplication sharedApplication] keyWindow] convertRect:keyboardRect fromView:nil]; //this is it!
        CGRect frame = inputBar.frame;
        frame.origin.y = keyboardRect.origin.y-frame.size.height;
        inputBar.frame =frame;
        
        
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)closePost{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        CGRect frame = mainPost.frame;
        frame.origin.y = y_retained;
        frame.origin.x = 0;
        mainPost.frame = frame;
        
        CGRect headerFrame = mainPostHeader.frame;
        headerFrame.origin.y = -50;
        mainPostHeader.frame = headerFrame;
      
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
        
        CGRect lowerframe = lower.frame;
        lowerframe.origin.y = y_retained + mainPost.frame.origin.y + mainPost.frame.size.height;
        lowerframe.origin.x = 0;
//        lowerframe.size.height = screenHeight;
        lower.frame = lowerframe;
        [lower removeFromSuperview];
        
        lowerframe = comment.frame;
        lowerframe.origin.y = screenHeight;
        lowerframe.origin.x = 0;
        //        lowerframe.size.height = screenHeight;
        comment.frame = lowerframe;
        inputBar.frame = lowerframe;
        
        
    } completion:^(BOOL finished) {
        [mainPost removeFromSuperview];
        [inputBar removeFromSuperview];
        [commentView removeFromSuperview];
        
    }];
}
-(void)handleRefresh:(id)sender{
    [refresh beginRefreshing];
    [self fetchFeeds];
    [main_tableView reloadData];
    [refresh endRefreshing];
}
-(void)fetchFeeds{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *posts_url = @"http://thewotimes.com/posts.php";
    NSURL *url = [NSURL URLWithString:posts_url];
    NSError* error;
    NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    NSData *tdata = [t dataUsingEncoding:NSUTF8StringEncoding];
    json= [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
    
    [main_tableView reloadData];
    [main_tableView setNeedsDisplay];
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [json count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ta = [[json objectAtIndex:indexPath.row] objectForKey:@"post"];
    NSString *tagg =[[json objectAtIndex:indexPath.row] objectForKey:@"id"];
//        postid = tagg;
    
    InstagramCommentViewController *t = [[InstagramCommentViewController alloc] initWithMedia:tagg];
    [self.navigationController pushViewController:t animated:true];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if([defaults objectForKey:@"facebook_data"] != nil){
//        
//    
//    CustomTableViewCell *temp = [tableView cellForRowAtIndexPath:indexPath];
//    
//    temp.selectionStyle = UITableViewCellSelectionStyleNone;
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    
//    commentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, screenWidth, screenHeight)];
//
//    [commentView setBackgroundColor:[UIColor whiteColor]];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:commentView];
//    
//    mainPost = [[UIView alloc] init];
//    [mainPost setBackgroundColor:[UIColor whiteColor]];
//    [commentView addSubview:mainPost];
//    
//    CGRect cardframe = temp.card.frame;
//    cardframe.origin.y = temp.frame.origin.y- tableView.contentOffset.y;
//    cardframe.origin.x = temp.frame.origin.x;
//    cardframe.size.width = screenWidth;
//    mainPost.frame = cardframe;
//    
//    
//    commentView.contentSize = CGSizeMake(screenWidth, mainPost.frame.size.height+250);
//
//    
//    inputBar = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-50, screenWidth, 50)];
//    [inputBar setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
//    //    [self.view addSubview:inputBar];
//    [[UIApplication sharedApplication].delegate.window addSubview:inputBar];
//    
//    inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, inputBar.frame.size.width-90, 30)];
//    inputTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//    [inputTextView.layer setCornerRadius:5.0f];
//    inputTextView.delegate = self;
//    UIView *tran = [[UIView alloc] initWithFrame:inputBar.frame];
//    [tran setBackgroundColor:[UIColor blackColor]];
//    [tran setAlpha:0.5];
////    [self.view addSubview:tran];
//    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.0, .0, inputTextView.frame.size.width - 20.0, 34.0)];
//    [placeholderLabel setText:@"Add a comment..."];
//    // placeholderLabel is instance variable retained by view controller
//    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
//    //[placeholderLabel setFont:[challengeDescription font]];
//    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
//    
//    // textView is UITextView object you want add placeholder text to
//    [inputTextView addSubview:placeholderLabel];
//    
//    [inputBar addSubview:inputTextView];
//    
//    inputTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
//    commentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
//    
//    sendText = [[UIView alloc] initWithFrame:CGRectMake(screenWidth-70, 10, 60, 30)];
//    [sendText setBackgroundColor:[UIColor colorWithRed:61/255.0 green:175/255.0 blue:4/255.0 alpha:1]];
//    send = [[UILabel alloc] initWithFrame:CGRectMake(10.0, -2.0, inputTextView.frame.size.width - 20.0, 34.0)];
//    [send setText:@"Send"];
//    [send setTextColor:[UIColor clearColor]];
//    [send setTextColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5]];
//    [send setTextColor:[UIColor whiteColor]];
//    [sendText addSubview:send];
//    [sendText.layer setCornerRadius:5.0f];
//    
//    
//    [inputBar addSubview:sendText];
//    
//    UITapGestureRecognizer *sendt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendComment)];
//    [sendText setUserInteractionEnabled:YES];
//    [sendText addGestureRecognizer:sendt];
//    
//    
//    
//    NSString *t = [[json objectAtIndex:indexPath.row] objectForKey:@"post"];
//    NSString *tagg =[[json objectAtIndex:indexPath.row] objectForKey:@"id"];
//    postid = tagg;
//    
//    [self fetchComments:tagg];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
////        [self fetchComments:tagg];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//        });
//    });
//
//    y_retained = temp.frame.origin.y- tableView.contentOffset.y;
//    
//    CustomTableViewCell *new = [[CustomTableViewCell alloc] init];
//    new = [self createCustomCellFromData:indexPath];
//        
//    [mainPost addSubview:lower];
//    [mainPost addSubview:new];
//        
//
//    CGRect lowerframe = lower.frame;
//    lowerframe.origin.y = 0;
//    lowerframe.origin.x = 0;
//    lower.frame = lowerframe;
//    
//    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
//        CGRect frame = mainPost.frame;
//        frame.origin.y = 0;
//        frame.origin.x = 0;
//        mainPost.frame = frame;
//        
//        CGRect headerFrame = mainPostHeader.frame;
//        headerFrame.origin.y = 0;
//        mainPostHeader.frame = headerFrame;
//        
//        
//        CGRect commentFrame = comment.frame;
//        commentFrame.origin.y = mainPost.frame.origin.y + mainPost.frame.size.height;
//        comment.frame = commentFrame;
//        
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES
//                                                withAnimation:UIStatusBarAnimationSlide];
//    } completion:^(BOOL finished) {
//        
//        
//    }];
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please login"
//                                           message:@"You need to log in to access certain features"
//                                          delegate:self cancelButtonTitle:@"Ok"
//                                 otherButtonTitles:nil];
//        [alert show];
//    }
    
}
-(void)sendComment{
    
    NSString *newCountryString =[inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *posts_url = [NSString stringWithFormat:@"http://www.thewotimes.com/posts.php?comment=%@&postid=%@&type=set", newCountryString, postid];
    NSURL *url = [NSURL URLWithString:posts_url];
    NSError* error;
    NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];

    inputTextView.text = @"";
    [inputTextView resignFirstResponder];
    
    [self fetchComments:postid];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if (inputTextView.text.length > 0) {
        placeholderLabel.text = @"";
//        send.textColor = [UIColor lightGrayColor]; //optional
    }
    if (inputTextView.text.length == 0) {
        placeholderLabel.text = @"Add a comment...";
        send.textColor = [UIColor whiteColor]; //optional
    }
    
    
    //    [textView becomeFirstResponder];
}
-(void)textViewDidChange:(UITextView *)textView{
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (inputTextView.text.length > 0) {
        placeholderLabel.text = @"";
//        send.textColor = [UIColor lightGrayColor]; //optional
    }
    if (inputTextView.text.length == 0) {
        placeholderLabel.text = @"Add a comment...";
        send.textColor = [UIColor whiteColor]; //optional
    }
    
}
-(void)fetchComments:(NSString *)postid{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    NSString *posts_url = [NSString stringWithFormat:@"http://thewotimes.com/posts.php?comment=test&postid=%@&type=get", postid];
    NSURL *url = [NSURL URLWithString:posts_url];
    NSError* error;
    NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    NSData *tdata = [t dataUsingEncoding:NSUTF8StringEncoding];
    if(tdata != nil){
        
        NSArray *json_comment= [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
        id comme = [[json_comment objectAtIndex:0]objectForKey:@"comment"];
       
        NSString *y = [NSString stringWithFormat:@"%@", comme];

        if(![y isEqualToString:@"0"]){
            
            comment = [[UIView alloc] initWithFrame:CGRectMake(0, mainPost.frame.origin.y+mainPost.frame.size.height, screenWidth, 40*[comme count])];
            [commentView addSubview:comment];
            
            int last = 10;
            int scrollheight = 0;
            for(int i = 0; i <  [comme count]; i++){
                UITextView *t = [[UITextView alloc] initWithFrame:CGRectMake(20, last, screenWidth-40, 50)];
                t.text = [comme objectAtIndex:i];
                t.editable = NO;
                t.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                [t sizeToFit]; //added
                [t layoutIfNeeded]; //added
                t.userInteractionEnabled = NO;
                CGRect frame = t.frame;
//                frame.size.height = ts.height;
                t.frame = frame;
                last += frame.size.height+10;
                
                [comment addSubview:t];
                scrollheight += last;
                UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(40, t.frame.origin.y - 5,screenWidth-80, 1)];
                separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
                [comment addSubview:separator];
            }
            commentView.contentSize = CGSizeMake(screenWidth, commentView.frame.size.height+last);
            
        }
        
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"%f", [self heightForOverheardPost:indexPath.row]);
    CGFloat addedHeight = 0;
    NSString *mainImage =[[json objectAtIndex:indexPath.row] objectForKey:@"image"];
    if(![mainImage isEqualToString:@""]){
        addedHeight += 300;
    }
    return [self heightForOverheardPost:[[json objectAtIndex:indexPath.row] objectForKey:@"post"]]+80 + addedHeight;
}
-(CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        NSLog(@"here");
    }
    cell = [self createCustomCellFromData:indexPath];
    return cell;
}
-(CustomTableViewCell *)createCustomCellFromData:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [[CustomTableViewCell alloc] init];
    NSString *t = [[json objectAtIndex:indexPath.row] objectForKey:@"post"];
    t =[t stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    t =[t stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    t =[t stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    NSString *likes = [[json objectAtIndex:indexPath.row] objectForKey:@"likes"];
    if([likes isEqualToString:@""]){
        likes = @"0";
    }
    //    NSLog(@"%@", t);
    cell.textView.text = t;
    NSString *u = [[json objectAtIndex:indexPath.row] objectForKey:@"user"];
//    if([u isEqualToString:@"Anonymous"]){
//        u = @"Anonymous Gryphon";
//    }
    if ([u rangeOfString:@"Anonymous"].location == NSNotFound) {
        
    } else {
        u = @"Anonymous Gryphon";
        
    }
    cell.usernameLabel.text = u;
    
    cell.likes.text = likes;
    NSString *prof = [[json objectAtIndex:indexPath.row] objectForKey:@"profile_picture"];
    NSString *a= [[json objectAtIndex:indexPath.row] objectForKey:@"account"];
    if([prof isEqualToString:@""]){
        prof = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", a];
    }
    if([u isEqualToString:@"Anonymous Gryphon"]){
        prof = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", @"anonymous"];
        
    }
//    cell.profileImage.imageURL = [NSURL URLWithString:prof];
    
    [cell.profileImage setImageWithURL:[NSURL URLWithString:prof] placeholderImage:[UIImage imageNamed:@""]];


//    NSLog(prof);
    cell.timeLabel.text = [[json objectAtIndex:indexPath.row] objectForKey:@"time"];
    
    NSString *mainImage =[[json objectAtIndex:indexPath.row] objectForKey:@"image"];
    if(![mainImage isEqualToString:@""]){
//        cell.mainImage.imageURL =[NSURL URLWithString:mainImage];
       [cell.mainImage setImageWithURL:[NSURL URLWithString:mainImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//           CGRect frame = cell.mainImage.frame;
//           frame.size.height = cell.mainImage.image.size.height;
//           NSLog(@"%f", cell.mainImage.image.size.height);
//           cell.mainImage.frame = frame;
       }];
        cell.isPic = YES;
    }
    
    cell = [self layoutOverheardCell:cell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *up= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like:)];
    [cell.up addGestureRecognizer:up];
    [cell.up setUserInteractionEnabled:YES];
    cell.up.tag =[[[json objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    
    UITapGestureRecognizer *down= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dislike:)];
    [cell.down addGestureRecognizer:down];
    [cell.down setUserInteractionEnabled:YES];
    cell.down.tag =[[[json objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    
    UITapGestureRecognizer *flagg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flagContent)];
    [cell.flag addGestureRecognizer:flagg];
    [cell.flag setUserInteractionEnabled:YES];
    return cell;
}
-(void)flagContent{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Flag" message: @"Do You Want To Flag This Content?" delegate: nil cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel",nil]; [alert show];
    
}
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
-(void)like:(UITapGestureRecognizer *)sender{
//    NSLog(@"%d", (sender.view).tag);
    CustomTableViewCell *tempcell;
    if(SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7.0")){
        tempcell = [(CustomTableViewCell *)[sender.view superview] superview];
        
    }else{
        
        tempcell = (CustomTableViewCell *)[sender.view superview];
    }
    
    NSLog(@"%@", tempcell.likes.text);
    NSString *ids = [NSString stringWithFormat:@"%d",(sender.view).tag];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSMutableArray *t = [d objectForKey:@"likes"];
    BOOL liked = NO;
    if([t count] > 0){
        for (NSString *l in t) {

            if([l isEqualToString:ids]){
                    liked = YES;
            }
        }
    }else{
        
    }
    
    if(!liked){
        NSMutableArray *m = [[NSMutableArray alloc] initWithArray:t];
        [m addObject:ids];
        [d setObject:m forKey:@"likes"];
        [self updateLikes:ids cell:tempcell type:@"like"];
        
        
        int dis_ = 0;
        
//        NSMutableArray *a = [d objectForKey:@"dislikes"];
//        if([a count] > 0){
//            for (NSString *l in a) {
//                if([l isEqualToString:ids]){
//                    
//                }
//            }
//        }
    }
    
    
}
-(void)dislike:(UITapGestureRecognizer *)sender{
    CustomTableViewCell *tempcell;
    if(SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7.0")){
        tempcell = [(CustomTableViewCell *)[sender.view superview] superview];
        
    }else{
        
        tempcell = (CustomTableViewCell *)[sender.view superview];
    }
    NSString *ids = [NSString stringWithFormat:@"%d",(sender.view).tag];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSMutableArray *t = [d objectForKey:@"dislikes"];
    BOOL disliked = NO;
    int dis_ = 0;
    if([t count] > 0){
        for (NSString *l in t) {

            if([l isEqualToString:ids]){
                disliked = YES;
            }
        }
    }else{
        
    }
    
    if(!disliked){
        NSMutableArray *m = [[NSMutableArray alloc] initWithArray:t];
        [m addObject:ids];
        [d setObject:m forKey:@"dislikes"];
        [self updateLikes:ids cell:tempcell type:@"dislike"];
    }
    
}
-(void)updateLikes:(NSString *)ids cell:(CustomTableViewCell *)cell type:(NSString *)type{
    
    for(int i = 0; i < [json count];i++){
        
        NSMutableArray *s = [[NSMutableArray alloc] initWithArray:json];
        NSMutableDictionary *t = [s objectAtIndex:i];
        
        
        if([[t objectForKey:@"id"] isEqualToString:ids]){
            NSLog(@"here");
            NSString *posts_url = [NSString stringWithFormat:@"http://thewotimes.com/posts.php?like=%@&id=%@",type, ids];
            NSURL *url = [NSURL URLWithString:posts_url];
            NSError* error;
            NSString *tra = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
            NSData *tdata = [tra dataUsingEncoding:NSUTF8StringEncoding];
            NSString *new_like = [[NSString alloc] initWithData:tdata encoding:NSUTF8StringEncoding];
            cell.likes.text = new_like;
            NSMutableDictionary *q = [[NSMutableDictionary alloc] initWithDictionary:t];
            [q setObject:new_like forKey:@"likes"];
            
            t = q;
            [s setObject:t atIndexedSubscript:i];
            json = s;
        }
    }
    
    
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CustomTableViewCell *)layoutOverheardCell:(CustomTableViewCell *)cell{
    CGFloat ntvh = [self heightForOverheardPost:cell.textView.text];
    CGRect frame = cell.textView.frame;
    frame.size.height = ntvh;
    cell.textView.frame = frame;
//    NSLog(@"%f", ntvh);
    frame = cell.mainImage.frame;
    frame.origin.y = cell.textView.frame.size.height + cell.textView.frame.origin.y - 35;
    cell.mainImage.frame = frame;
    
    frame = cell.card.frame;
    CGFloat picture = 0;
    if(cell.isPic){
        picture = 300;
//        NSLog(@"here");
    }
    frame.size.height = ntvh+60+10+picture;
    cell.card.frame = frame;
    
    frame = cell.up.frame;
    frame.origin.y = cell.card.frame.size.height + cell.card.frame.origin.y - 49;
    cell.up.frame = frame;
    
    frame = cell.down.frame;
    frame.origin.y = cell.card.frame.size.height + cell.card.frame.origin.y - 49;
    cell.down.frame = frame;
    
    frame = cell.likes.frame;
    frame.origin.y = cell.card.frame.size.height + cell.card.frame.origin.y - 54;
    cell.likes.frame = frame;
    
    frame = cell.flag.frame;
    frame.origin.y = cell.card.frame.size.height + cell.card.frame.origin.y - 40;
    cell.flag.frame = frame;
    
    
    NSString *created_time = cell.timeLabel.text;
    NSTimeInterval epoch = [created_time doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:epoch];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:date];
    
    double seconds = 1;
    double minutes = 60;
    double hours = minutes*60;
    double days = hours * 24;
    double weeks = days * 7;
    NSInteger secondsBetweenDates = distanceBetweenDates;
    NSInteger minutesBetweenDates = distanceBetweenDates / minutes;
    NSInteger hoursBetweenDates = distanceBetweenDates / hours;
    NSInteger daysBetweenDates = distanceBetweenDates / days;
    NSInteger weeksBetweenDates = distanceBetweenDates / weeks;
    if(secondsBetweenDates < 60){
        created_time = [NSString stringWithFormat:@"%d", secondsBetweenDates];
        created_time = [created_time stringByAppendingString:@"s"];
        NSLog(@"%d", secondsBetweenDates);
    }else
        if(minutesBetweenDates < 60){
            created_time = [NSString stringWithFormat:@"%d", minutesBetweenDates];
            created_time = [created_time stringByAppendingString:@"m"];
        }else
            if(hoursBetweenDates < 24){
                created_time = [NSString stringWithFormat:@"%d", hoursBetweenDates];
                created_time = [created_time stringByAppendingString:@"h"];
            }else
                if(daysBetweenDates < 7){
                    created_time = [NSString stringWithFormat:@"%d", daysBetweenDates];
                    created_time = [created_time stringByAppendingString:@"d"];
                }
                else{
                    created_time = [NSString stringWithFormat:@"%d", weeksBetweenDates];
                    created_time = [created_time stringByAppendingString:@"w"];
                }
    cell.timeLabel.text = created_time;
    return cell;
}
-(CGFloat)heightForOverheardPost:(NSString *)text{
    UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 16];
    
//    NSDictionary *data = temp_post;
    int addedHeight;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGSize size = [text sizeWithFont:font
                   constrainedToSize:CGSizeMake(screenWidth-40-50, 40000)
                       lineBreakMode:UILineBreakModeWordWrap]; // default mode
    float numberOfLines = size.height / font.lineHeight;
    addedHeight = (int)numberOfLines * (int)font.lineHeight;
    
    return addedHeight+50;
    
}


@end

