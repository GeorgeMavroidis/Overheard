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
    
    main_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-50) style:UITableViewStylePlain];
    
    main_tableView.scrollEnabled = YES;
    main_tableView.showsVerticalScrollIndicator = YES;
    main_tableView.userInteractionEnabled = YES;
    main_tableView.bounces = YES;
    // main_tableView.backgroundColor = [UIColor blackColor];
    
    main_tableView.delegate = self;
    main_tableView.dataSource = self;
    [self.view addSubview:main_tableView];
    
    
    //[inputTextView becomeFirstResponder];
    
    
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
    [self.navigationController setNavigationBarHidden:NO];
   
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [main_tableView scrollRectToVisible:CGRectMake(0, main_tableView.contentSize.height - main_tableView.bounds.size.height, screenWidth, screenHeight-55) animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [inputTextView resignFirstResponder];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor clearColor]}];
    

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
    
    NSString *text = [data objectForKey:@"text"];
    cell.text.text = text;
    
    NSString *username = @"Anonymous";
    
    cell.username.text = username;
    cell.username.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.8f];
    cell.username.textColor = [UIColor colorWithRed: 81/255.0 green: 127/255.0 blue:164/255.0 alpha: 1.0];
    cell.text.text = @"test";
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [instagram_data objectAtIndex:indexPath.row];
    
    NSString *text = [data objectForKey:@"text"];

    return [self returnCommentsHeight:indexPath textString:text]+30 +10;
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
    rect.origin.y -= 210;
    inputBar.frame = rect;
    [UIView commitAnimations];
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
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.5f];
    
    CGSize size = [text sizeWithFont:font
                   constrainedToSize:CGSizeMake(screenWidth-50, 1000)
                       lineBreakMode:UILineBreakModeWordWrap]; // default mode
    float numberOfLines = size.height / font.lineHeight;
    addedHeight = (int)numberOfLines * (int)font.lineHeight;
    
    
    return addedHeight;
    
}

@end
