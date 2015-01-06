//
//  SnapchatViewController.m
//  Overheard
//
//  Created by George on 2014-12-01.
//  Copyright (c) 2014 Overheard. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CustomMainCell : UITableViewCell

//
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *status;

//
@property (strong, nonatomic) IBOutlet UIImageView *icon;

@end


#import <Foundation/Foundation.h>
@implementation CustomMainCell
@synthesize title, icon, status;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect screenRect = self.bounds;
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        title = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, screenWidth-60, 50)];
        [title setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:17]];
        [title setBackgroundColor:[UIColor clearColor]];
        
        
        status = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, screenWidth, 50)];
        [status setFont:[UIFont systemFontOfSize:12]];
        [status setTextColor:[UIColor lightGrayColor]];
        
        

        [self addSubview:title];
        [self addSubview:status];
        
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
        icon.layer.cornerRadius = 20;
        icon.contentMode = UIViewContentModeScaleAspectFit;
        icon.clipsToBounds = YES;
        [self addSubview:icon];
    }
    return self;
}

@end

#import "SnapchatViewController.h"
#import "StoryViewController.h"
#import <UIImageView+WebCache.h>
#import "StoryCreatorViewController.h"
@interface SnapchatViewController (){
    UITableView *tableView;
    
    
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    NSArray *items;
    NSMutableDictionary *loaded;
    NSMutableDictionary *tags;
    
    UIRefreshControl *refresh;
    StoryViewController *st;
    

}

@end

@implementation SnapchatViewController
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
    
    screenRect = self.view.bounds;
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    [self fetchFeeds];
    tableView=[[UITableView alloc]init];
    tableView.frame = CGRectMake(0,0,screenWidth,screenHeight-60);
    tableView.dataSource=self;
    tableView.delegate=self;
    
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
//    [tableView reloadData];
    [self.view addSubview:tableView];
    
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refresh];
    tags = [[NSMutableDictionary alloc] init];
    loaded = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"loaded_stories"] mutableCopy];
    if(loaded == nil){
        loaded = [[NSMutableDictionary alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:loaded forKey:@"loaded_stories"];
    }
    NSString *model = [[UIDevice currentDevice] model];
    if ([model hasSuffix:@"Simulator"]) {
        //device is simulator
    }else{
        UIImageView *image_icon = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2-50, self.view.bounds.size.height-150-60, 100, 100)];
        image_icon.image = [UIImage imageNamed:@"circle_picture_new.png"];
        [self.view addSubview:image_icon];
        
        UITapGestureRecognizer *storyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchStoryCreator)];
        [image_icon addGestureRecognizer:storyTap];
        [image_icon setUserInteractionEnabled:YES];
        
    }
    
    [self fetchFeeds];
    // Do any additional setup after loading the view.
}
-(void)launchStoryCreator{
    StoryCreatorViewController *storyVC = [[StoryCreatorViewController alloc] init];
    [self.navigationController pushViewController:storyVC animated:NO];
}
-(void)handleRefresh:(id)sender{
    [refresh beginRefreshing];
    [self fetchFeeds];
    [tableView reloadData];
    [refresh endRefreshing];
}
-(void)fetchFeeds{
    NSString *feed = @"http://www.thewotimes.com/overheard/story.php";
    NSURL *url = [NSURL URLWithString:feed];
    NSError *error;
    NSString *stuff = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
    if(stuff != nil){
        NSData *tdata = [stuff dataUsingEncoding:NSUTF8StringEncoding];
        items= [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:items forKey:@"overheard_stories"];
        
        //UNCHECK BEFORE
        if(loaded != nil)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //
                
                // update UI on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self checkCurrentlyLoaded:loaded];
                    
                });
                
            });
        else
            loaded = [[NSMutableDictionary alloc] init];
    }
    
    
}
-(void)checkCurrentlyLoaded:(NSMutableDictionary *)allLoaded{
    for(NSString *each in [allLoaded allKeys]){
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *feed = [NSString stringWithFormat:@"http://www.thewotimes.com/overheard/storyDB.php?get=%@", each];
            NSURL *url = [NSURL URLWithString:feed];
            NSError *error;
            NSString *stuff = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];

            NSData *tdata = [stuff dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *fetched = [NSJSONSerialization JSONObjectWithData:tdata options:0 error:nil];
            NSArray *keyss = [NSArray arrayWithObjects:@"id", nil];
            
            NSMutableArray *arr1 = [[NSMutableArray alloc] init];
            NSMutableArray *arr2 = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in fetched) {
                NSString *value = [dict objectForKey:@"id"];
                if (value) {
                    [arr1 addObject:value];
                }
            }
            for (NSDictionary *dict in [allLoaded objectForKey:each]) {
                NSString *value = [dict objectForKey:@"id"];
                if (value) {
                    [arr2 addObject:value];
                }
            }
            
            if(![arr1 isEqualToArray:arr2]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSIndexPath *tagsIP = [tags objectForKey:each];
                    CustomMainCell *c = (CustomMainCell *)[tableView cellForRowAtIndexPath:tagsIP];
                    [c.icon setAlpha:0.5];
                    [c.title setAlpha:0.5];
                    activityIndicator.frame =c.icon.frame;
                    activityIndicator.center = c.icon.center;
                    [c addSubview:activityIndicator];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    [activityIndicator startAnimating];
                    
                    
                    c.status.text = @" - loading...";
                    
                    
                });
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    
                    NSArray *downloading = [self downloadData:tdata forKey:each];
                    
                    //            NSLog(@"%@", downloading);
                    
                    
                    //Background Thread
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        // This line stops the activity indicator in the status bar
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                        // This line stops the activity indicator on the view, in this case the table view
                        NSIndexPath *tagsIP = [tags objectForKey:each];
                        CustomMainCell *c = (CustomMainCell *)[tableView cellForRowAtIndexPath:tagsIP];
                        
                        [activityIndicator stopAnimating];
                        c.status.text = @" - Hold to play";
                        [c.icon setAlpha:1];
                        [c.title setAlpha:1];
                        
                        
                        [loaded setObject:downloading forKey:each];
                        [[NSUserDefaults standardUserDefaults] setObject:loaded forKey:@"loaded_stories"];
                        
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            [self balanceData:downloading forKey:each];
                            // update UI on the main thread
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                
                            });
                            
                        });
                        
                    });
                });
                
                
                //
            }
            // update UI on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
            });
            
        });
        
        
    }
}
-(void)balanceData:(NSArray *)array forKey:(NSString *)key{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *keyDirectory = [NSString stringWithFormat:@"%@/%@", documentsDirectory, key];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:keyDirectory error:NULL];
    
    NSMutableArray *all_filenames = [[NSMutableArray alloc] init];
        for(NSDictionary *each in array){
            NSString *str=[each valueForKey:@"link"];
            NSString *type = [each valueForKey:@"type"];
            
            NSURL *url=[NSURL URLWithString:str];
            
            NSArray* foo = [str componentsSeparatedByString: @"/"];
            
            NSString* filename = [NSString stringWithFormat:@"%@",[foo objectAtIndex: [foo count] -1]];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory, key, filename];
            
            [all_filenames addObject:filename];
            
//            NSError *error;
//            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            
        }
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:directoryContent];
    [intermediate removeObjectsInArray:all_filenames];
    
    
    for(NSString *left in intermediate){
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory, key, left];
        NSError *error;
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (!success) {
                NSLog(@"Error removing file at path: %@", error.localizedDescription);
            }
        }
    }
    
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
    CustomMainCell *cell = (CustomMainCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.title.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    [cell.icon setImageWithURL:[[items objectAtIndex:indexPath.row] objectForKey:@"picture"]];
    
    CGFloat width =  [cell.title.text sizeWithFont:[UIFont fontWithName:@"AvenirNext-Bold" size:17]].width;
    
    cell.status.frame = CGRectMake(cell.title.frame.origin.x+width, 7, 100, 50);
    
    if ([loaded objectForKey:cell.title.text]) {
        cell.status.text = @" - Hold to play";        
    } else {
        cell.status.text = @"- Tap to load";
        [cell.icon setAlpha:0.5];
        [cell.title setAlpha:0.5];
        
        // Do something else like create the object
    }
    
    UILongPressGestureRecognizer *playS = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(playStory:)];
    [cell addGestureRecognizer:playS];
    playS.minimumPressDuration = 0.5;
    cell.userInteractionEnabled = YES;
    cell.tag = indexPath.row;
    [tags setObject:indexPath forKey:cell.title.text];
    
    return cell;
}
-(void)playStory:(UILongPressGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        CustomMainCell *tempCell = (CustomMainCell *)recognizer.view;
        if ([loaded objectForKey:tempCell.title.text]) {
            [self drawStory:[loaded objectForKey:tempCell.title.text] forKey:tempCell.title.text];
        }
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        [self removeStory];
    }
    
}
-(void)drawStory:(NSArray *)array forKey:(NSString *)title{
    st = [[StoryViewController alloc] init];
    st.array = array;
    st.title = title;
    
    [self.view addSubview:st.view];
    [self addChildViewController:st];
    
    self.view.frame = CGRectMake(screenWidth, 0, screenWidth, self.view.bounds.size.height);
    [st.view setFrame:CGRectMake(0, 0, screenWidth, self.view.bounds.size.height)];
    
}
-(void)removeStory{
    
    NSArray *t = [[st.n reverseObjectEnumerator] allObjects];
    
    [loaded setObject:t forKey:st.title];
    
    if([t count] == 0){
        NSIndexPath *tagsIP = [tags objectForKey:st.title];
        CustomMainCell *c = (CustomMainCell *)[tableView cellForRowAtIndexPath:tagsIP];
        [loaded removeObjectForKey:st.title];
        c.status.text = @"- Tap to load";
        [c.icon setAlpha:0.5];
        [c.title setAlpha:0.5];
    }
    
    self.view.frame = CGRectMake(screenWidth, 60, screenWidth, self.view.bounds.size.height);
    [st.view removeFromSuperview];
    st.removed = @"true";
    [st removeFromParentViewController];
    

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomMainCell *c = (CustomMainCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *obj = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];

    
    
    if ([loaded objectForKey:obj]) {
        c.status.text = @" - Hold to play";
    }else{
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame =c.icon.frame;
        activityIndicator.center = c.icon.center;
        [c addSubview:activityIndicator];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [activityIndicator startAnimating];
        
        c.status.text = @" - loading...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            NSString *feed = [NSString stringWithFormat:@"http://www.thewotimes.com/overheard/storyDB.php?get=%@", obj];
            NSURL *url = [NSURL URLWithString:feed];
            NSError *error;
            NSString *stuff = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
            
            if(stuff ==nil){
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                // This line stops the activity indicator on the view, in this case the table view
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    c.status.text = @" - No Stories!";
                    [activityIndicator stopAnimating];
                    c.selected = NO;
                    
                });
                
            }else{
                NSData *tdata = [stuff dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *downloading = [self downloadData:tdata forKey:obj];
            
                
                //            NSLog(@"%@", downloading);
                
                
                //Background Thread
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // This line stops the activity indicator in the status bar
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    // This line stops the activity indicator on the view, in this case the table view
                    [activityIndicator stopAnimating];
                    c.status.text = @" - Hold to play";
                    [c.icon setAlpha:1];
                    [c.title setAlpha:1];
                    
                    
                    [loaded setObject:downloading forKey:obj];
                    [[NSUserDefaults standardUserDefaults] setObject:loaded forKey:@"loaded_stories"];
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        //
                        [self balanceData:downloading forKey:obj];
                        // update UI on the main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                        });
                        
                    });
                    
                });
            }
        });
        
        
    }
   
    
    
}
-(NSArray *)downloadData:(NSData *)data forKey:(NSString *)key{
    
    NSArray *fetched = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    [loaded setObject:fetched forKey:forK];
    NSMutableArray *loadingArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary *each in fetched ){
        NSString *str=[each valueForKey:@"link"];
        NSString *type = [each valueForKey:@"type"];
        
        NSURL *url=[NSURL URLWithString:str];
        
        NSArray* foo = [str componentsSeparatedByString: @"/"];
        NSString* filename = [foo objectAtIndex: [foo count] -1];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", key]];
        
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory, key, filename];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if(!fileExists){
            
            NSData *data=[NSData dataWithContentsOfURL:url];
            [data writeToFile:filePath atomically:YES];
            
            
        }
        
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:each];
        [temp setObject:filename forKey:@"filename"];
        [loadingArray addObject:temp];
        
        
        
        
        
        

    }
    
    return loadingArray;
}
@end
