//
//  HomeViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 3/28/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "HomeViewController.h"
#import "Client.h"
#import "NewTweetViewController.h"
#import "TweetCell.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"
#import "Tweet.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *tweets;
-(void)reload;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweets.dataSource = self;
    self.tweets.delegate = self;
    self.currentTweets = [[NSMutableArray alloc] init];

    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tweets registerNib:customNib forCellWithReuseIdentifier:@"TweetCell"];
    
    NSLog(@"%@",  @"ViewDidLoad");
    
    [self reload];
    NSLog(@"%@", self.currentTweets);
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.theNewTweet) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        NSDictionary *currentUser = [User currentUserDictionary];
        [userDict setValue:[currentUser objectForKey:@"name"] forKey:@"name"];
        [userDict setValue:[currentUser objectForKey:@"screen_name"] forKey:@"screen_name"];
        [userDict setValue:[currentUser objectForKey:@"profile_image_url"] forKey:@"profile_image_url"];
        [dict setValue:self.theNewTweet forKey:@"text"];
        [dict setValue:userDict forKey:@"user"];
        
        [self.currentTweets insertObject:dict atIndex:0];
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.tweets insertItemsAtIndexPaths:arrayWithIndexPaths];
    }

    NSLog(@"%@",  @"ViewDidAppear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.currentTweets count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailview = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailview.tweet = [self.currentTweets objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailview animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [self.currentTweets objectAtIndex:indexPath.row][@"text"];
    CGSize maximumLabelSize = CGSizeMake(215,9999);
    UIFont *font=[UIFont systemFontOfSize:13];
    CGRect textRect = [name  boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return CGSizeMake(320, textRect.size.height + 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    //NSLog(@"%@", [[self.currentTweets objectAtIndex:indexPath.row] objectForKey:@"text"]);
    NSDictionary *twt = [self.currentTweets objectAtIndex:indexPath.row];
    [cell cellWithTweet:twt];
    cell.tContent.numberOfLines = 0;
    [cell.tContent sizeToFit];
    return cell;
}

- (IBAction)onLogOutButton:(id)sender {
    Client *client = [Client instance];
    [client logout];
}

- (IBAction)onNewButton:(id)sender {
    NewTweetViewController *editor = [[NewTweetViewController alloc] initWithNibName:@"NewTweetViewController" bundle:nil];
    editor.title = @"New tweet";
    [self.navigationController pushViewController:editor animated:YES];
}

- (void)fakeTweet:(NSNotification *)notification {
    /*NSString *newTweet = [notification.userInfo objectForKey:@"new_tweet"];
    if (newTweet) {
        [self.currentTweets insertObject:newTweet atIndex:0];
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.tweets insertItemsAtIndexPaths:arrayWithIndexPaths];
    }*/
}

- (void) reload {
    Client *client = [Client instance];
    [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.currentTweets = [Tweet tweetsWithArray:responseObject];
        [self.tweets reloadData];
        //NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
