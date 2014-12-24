//
//  SnapchatViewController.m
//  Overheard
//
//  Created by George on 2014-12-01.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CustomMainCellS : UITableViewCell

//
@property (strong, nonatomic) IBOutlet UILabel *title;

//
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UIImageView *check;

@end


#import <Foundation/Foundation.h>
@implementation CustomMainCellS
@synthesize title, icon, check;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect screenRect = self.bounds;
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        title = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, screenWidth-60, 50)];
        [self addSubview:title];
        
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
        icon.layer.cornerRadius = 20;
        icon.contentMode = UIViewContentModeScaleAspectFit;
        icon.clipsToBounds = YES;
        [self addSubview:icon];
        
        check = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-40, 15, 20, 20)];
//        check.layer.cornerRadius = 20;
        check.contentMode = UIViewContentModeScaleAspectFit;
        check.image = [UIImage imageNamed:@"check_000000_50.png"];
        [check setHidden:TRUE];
        check.clipsToBounds = YES;
        [self addSubview:check];
    }
    return self;
}

@end

#import "SnapchatSelectViewController.h"

#import <UIImageView+WebCache.h>
@interface SnapchatSelectViewController (){
    UITableView *tableView;
    
    
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    NSArray *items;
}

@end

@implementation SnapchatSelectViewController
@synthesize selected, imageURL;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES
    //                                            withAnimation:UIStatusBarAnimationFade];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO
    //                                            withAnimation:UIStatusBarAnimationFade];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    selected = [[NSMutableArray alloc] init];
    screenRect = self.view.bounds;
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    [self fetchFeeds];
    tableView=[[UITableView alloc]init];
    tableView.frame = CGRectMake(0,0,screenWidth,screenHeight);
    tableView.dataSource=self;
    tableView.delegate=self;
    //    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //    [tableView reloadData];
    [self.view addSubview:tableView];
    
    // Do any additional setup after loading the view.
}
-(void)fetchFeeds{
    
//    [[NSUserDefaults standardUserDefaults] setObject:items forKey:@"overheard_stories"];
//    NSString *feed = @"http://www.thewotimes.com/overheard/story.php";
//    NSURL *url = [NSURL URLWithString:feed];
//    NSError *error;
//    NSString *stuff = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
//    NSData *tdata = [stuff dataUsingEncoding:NSUTF8StringEncoding];
//    items= [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
    items = [[NSUserDefaults standardUserDefaults] objectForKey:@"overheard_stories"];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomMainCellS *cell = (CustomMainCellS *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomMainCellS alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.title.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    [cell.icon setImageWithURL:[[items objectAtIndex:indexPath.row] objectForKey:@"picture"]];
    if([selected containsObject:cell.title.text]){
        [cell.check setHidden:NO];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomMainCellS *c = (CustomMainCellS *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *obj = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    if ([selected containsObject:obj]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF contains[cd] %@)", obj];
        NSArray *results = [selected filteredArrayUsingPredicate:predicate];
        selected = [NSMutableArray arrayWithArray:results];
        [c.check setHidden:YES];
        
    }else{
        [selected addObject:obj];
        [c.check setHidden:NO];
    }
    
}

@end
