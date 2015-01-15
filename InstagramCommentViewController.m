//
//  InstagramCommentViewController.m
//  Feed
//
//  Created by George on 2014-05-12.
//  Copyright (c) 2014 George. All rights reserved.
//

#import "InstagramCommentViewController.h"
#import "InstagramCommentCell.h"
#import "AsyncImageView.h"
#import <Parse/Parse.h>

@interface InstagramCommentViewController ()

@end
@implementation InstagramCommentViewController{
    UIView *kNavBar;
    UITableView *main_tableView;
    UIView *inputBar;
    UITextView *inputTextView;
    UIView *sendText;
    UILabel *send;
    UILabel *placeholderLabel;
    NSString *media_id;
    NSArray *instagram_data;
    NSString *user_id, *user_name;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) initWithMedia:(NSString *)media {
    if ((self = [super initWithNibName:nil bundle:nil])){
        media_id = media;
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    instagram_data = [[NSArray alloc] init];
    
    main_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-50) style:UITableViewStylePlain];
    
    main_tableView.scrollEnabled = YES;
    main_tableView.showsVerticalScrollIndicator = YES;
    main_tableView.userInteractionEnabled = YES;
    main_tableView.bounces = YES;
    // main_tableView.backgroundColor = [UIColor blackColor];
    
    main_tableView.delegate = self;
    main_tableView.dataSource = self;
    [self.view addSubview:main_tableView];
    
    self.title = @"Comments";
    [self fetchCommentsFor:media_id];
    //[inputTextView becomeFirstResponder];
    
    inputBar = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-50, screenWidth, 50)];
    [inputBar setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    //    [self.view addSubview:inputBar];
    [self.view addSubview:inputBar];
    inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, inputBar.frame.size.width-90, 30)];
    inputTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [inputTextView.layer setCornerRadius:5.0f];
    inputTextView.delegate = self;
    UIView *tran = [[UIView alloc] initWithFrame:inputBar.frame];
    [tran setBackgroundColor:[UIColor blackColor]];
    [tran setAlpha:0.5];
    //    [self.view addSubview:tran];
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.0, .0, inputTextView.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:@"Add a comment..."];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    //[placeholderLabel setFont:[challengeDescription font]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
            // textView is UITextView object you want add placeholder text to
    [inputTextView addSubview:placeholderLabel];
    [inputBar addSubview:inputTextView];
    inputTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    main_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
            sendText = [[UIView alloc] initWithFrame:CGRectMake(screenWidth-70, 10, 60, 30)];
//    [sendText setBackgroundColor:[UIColor colorWithRed:61/255.0 green:175/255.0 blue:4/255.0 alpha:1]];
    [sendText setBackgroundColor:[UIColor colorWithRed:166.0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    send = [[UILabel alloc] initWithFrame:CGRectMake(10.0, -2.0, inputTextView.frame.size.width - 20.0, 34.0)];
    [send setText:@"Send"];
    [send setTextColor:[UIColor clearColor]];
    [send setTextColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5]];
    [send setTextColor:[UIColor whiteColor]];
    [sendText addSubview:send];
    [sendText.layer setCornerRadius:5.0f];

    [inputBar addSubview:sendText];

    UITapGestureRecognizer *sendt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendComment)];
    [sendText setUserInteractionEnabled:YES];
    [sendText addGestureRecognizer:sendt];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    user_id= [[defaults objectForKey:@"facebook_data"] valueForKey:@"id"];
//    user_name = [[defaults objectForKey:@"facebook_data"] valueForKey:@"name"];
    PFInstallation *pfi = [PFInstallation currentInstallation];
    user_id = pfi.installationId;
    user_name = @"";

    
    [main_tableView scrollRectToVisible:CGRectMake(0, main_tableView.contentSize.height - main_tableView.bounds.size.height, main_tableView.bounds.size.width, main_tableView.bounds.size.height) animated:YES];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)fetchCommentsFor:(NSString *)postid{

    
    NSString *posts_url = [NSString stringWithFormat:@"http://thewotimes.com/posts.php?new_comment=test&postid=%@&type=get&user=%@&name=%@", postid, user_id, user_name];
//    NSLog(posts_url);
    NSURL *url = [NSURL URLWithString:posts_url];
    NSError* error;
    NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    NSData *tdata = [t dataUsingEncoding:NSUTF8StringEncoding];
    if(tdata != nil){
        
        NSArray *json_comment= [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
        id comme = [[json_comment objectAtIndex:0]objectForKey:@"comment"];
        if([comme isKindOfClass:[NSArray class]]){
//        NSLog(@"%@",t);
        instagram_data = comme;
        [main_tableView reloadData];
        [main_tableView scrollRectToVisible:CGRectMake(0, main_tableView.contentSize.height - main_tableView.bounds.size.height, main_tableView.bounds.size.width, main_tableView.bounds.size.height) animated:YES];
        }


    }

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return TRUE;
}
-(void)revealGesture:(UIPanGestureRecognizer *)rec{
    CGPoint vel = [rec velocityInView:self.view];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGPoint currentlocation = [rec locationInView:self.view];
    CGRect tableFrame = main_tableView.frame;
    CGRect new_frame = main_tableView.frame;
    CGRect navBarFrame = inputBar.frame;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
   
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
//    [main_tableView scrollRectToVisible:CGRectMake(0, main_tableView.contentSize.height - main_tableView.bounds.size.height, screenWidth, screenHeight-55) animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    [inputTextView resignFirstResponder];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor clearColor]}];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"InstagramCell";
    
    InstagramCommentCell *cell = (InstagramCommentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[InstagramCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSDictionary *data = [instagram_data objectAtIndex:indexPath.row];
    cell.text.text = [NSString stringWithFormat:@"%@ - %@", [data objectForKey:@"user_name"],[data objectForKey:@"comment"]];
    
    return cell;
    
}
-(void)sendComment{
    
    NSString *newCountryString =[inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray* foo = [user_name componentsSeparatedByString: @" "];
    NSString* day = [foo objectAtIndex: 0];
//    user_name = [user_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *posts_url = [NSString stringWithFormat:@"http://www.thewotimes.com/posts.php?new_comment=%@&postid=%@&type=set&user=%@&name=%@", newCountryString, media_id, user_id, day];
    
    NSURL *url = [NSURL URLWithString:posts_url];
    NSError* error;
    NSString *t = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    NSLog(@"%@", t);
    inputTextView.text = @"";
    [inputTextView resignFirstResponder];
    
    NSData *tdata = [t dataUsingEncoding:NSUTF8StringEncoding];
    if(tdata != nil){
        
        NSArray *json_comment= [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
        id comme = [[json_comment objectAtIndex:0]objectForKey:@"comment"];
        if([comme isKindOfClass:[NSArray class]]){
            //        NSLog(@"%@",t);
            instagram_data = comme;
            [main_tableView reloadData];
            [main_tableView scrollRectToVisible:CGRectMake(0, main_tableView.contentSize.height - main_tableView.bounds.size.height, main_tableView.bounds.size.width, main_tableView.bounds.size.height) animated:YES];
        }
        
        
    }
    
//    [self fetchCommentsFor:media_id];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [instagram_data objectAtIndex:indexPath.row];
    
    NSString *text = [NSString stringWithFormat:@"%@ - %@", [data objectForKey:@"user_name"],[data objectForKey:@"comment"]];

    return [self returnCommentsHeight:indexPath textString:text]+10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [instagram_data count];
}
-(void) textViewDidBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:NULL];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.265];
    CGRect rect = main_tableView.frame;
    rect.origin.y -= 210;
    main_tableView.frame = rect;
    
    rect = inputBar.frame;
    rect.origin.y -= 220;
//    inputBar.frame = rect;
    [UIView commitAnimations];
    
    if (inputTextView.text.length > 0) {
        placeholderLabel.text = @"";
        //        send.textColor = [UIColor lightGrayColor]; //optional
    }
    if (inputTextView.text.length == 0) {
        placeholderLabel.text = @"Add a comment...";
        send.textColor = [UIColor whiteColor]; //optional
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = main_tableView.frame;
    CGRect originalRect =rect;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //0.265
    [UIView setAnimationDuration:0.2];
    rect.origin.y = screenHeight - main_tableView.frame.size.height-50;
    main_tableView.frame = rect;
    
    rect = inputBar.frame;
    rect.origin.y = screenHeight - inputBar.frame.size.height;
    inputBar.frame = rect;
    
    [UIView commitAnimations];
    
    //main_tableView.frame = originalRect;
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
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(int)returnCommentsHeight:(NSIndexPath*)indexPath textString:(NSString *)text {
    int addedHeight;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:15.0f];
    
    CGSize size = [text sizeWithFont:font
                   constrainedToSize:CGSizeMake(screenWidth-50, 1000)
                       lineBreakMode:UILineBreakModeWordWrap]; // default mode
    float numberOfLines = size.height / font.lineHeight;
    addedHeight = (int)numberOfLines * (int)font.lineHeight;
    
    
    return addedHeight;
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification{
    
    CGRect screenRect = self.view.bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGRect keyboardRect = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
    CGRect frame = inputBar.frame;
    frame.origin.y = keyboardRect.origin.y-frame.size.height;
    inputBar.frame = CGRectMake(0, keyboardRect.origin.y-inputBar.frame.size.height, screenWidth, 50);
    frame = inputBar.frame;
    frame.origin.y = keyboardRect.origin.y-frame.size.height;
    //    picker.view.frame = frame;
    
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
}

@end
