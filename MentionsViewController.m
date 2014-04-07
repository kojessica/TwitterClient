//
//  MentionsViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 4/7/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "MentionsViewController.h"
#import "Client.h"
#import "NewTweetViewController.h"
#import "TweetCell.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"
#import "Tweet.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "MenuSliderViewController.h"
#import "MyProfileViewController.h"

@interface MentionsViewController ()

-(void) reload;
-(void) fetchMoreTweets:(NSString *)max_id;
-(void) onFavoriteButton:(id)sender;
-(void) onRetweetButton:(id)sender;
-(void) onReplyButton:(id)sender;

@end

@implementation MentionsViewController

@synthesize delegate = _delegate;

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
    self.delegate = _delegate;
    
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tweets registerNib:customNib forCellWithReuseIdentifier:@"TweetCell"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.tweets addSubview:refreshControl];
    
    NSLog(@"%@", @"View Load");
    [self reload];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@", @"View appear");
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
    detailview.savedTweets = self.currentTweets;
    detailview.tweet = [self.currentTweets objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailview animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [self.currentTweets objectAtIndex:indexPath.row][@"text"];
    CGSize maximumLabelSize = CGSizeMake(230,9999);
    UIFont *font=[UIFont systemFontOfSize:13];
    CGRect textRect = [name  boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return CGSizeMake(320, textRect.size.height + 75);
}

- (void)sender:(TweetCell *)sender didTap:(NSString *)tweetId {
    MyProfileViewController *modalViewController = [[MyProfileViewController alloc] init];
    modalViewController.screenId = tweetId;
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    //NSLog(@"%@", [[self.currentTweets objectAtIndex:indexPath.row] objectForKey:@"text"]);
    NSDictionary *twt = [self.currentTweets objectAtIndex:indexPath.row];
    [cell cellWithTweet:twt];
    cell.tContent.numberOfLines = 0;
    [cell.tContent sizeToFit];
    
    BOOL favorited = [[[self.currentTweets objectAtIndex:indexPath.row] objectForKey:@"favorited"] boolValue];
    if (favorited) {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"ic_star_yellow_8.png"] forState:UIControlStateNormal];
    }
    
    BOOL retweeted = [[[self.currentTweets objectAtIndex:indexPath.row] objectForKey:@"retweeted"] boolValue];
    if (retweeted) {
        [cell.reTweetButton setTitleColor:[UIColor colorWithRed:244.f/255.f green:180.f/255.f blue:0 alpha:1.f] forState:UIControlStateNormal];
    }
    
    cell.favoriteButton.tag = indexPath.row;
    [cell.favoriteButton addTarget:self action:@selector(onFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.reTweetButton.tag = indexPath.row;
    [cell.reTweetButton addTarget:self action:@selector(onRetweetButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.replyButton.tag = indexPath.row;
    [cell.replyButton addTarget:self action:@selector(onReplyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == ([self.currentTweets count] - 1)) {
        [self fetchMoreTweets:[[self.currentTweets objectAtIndex:([self.currentTweets count] - 1)] objectForKey:@"id"]];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void) reload {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Client *client = [Client instance];
    [client mentionsTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.currentTweets = [Tweet tweetsWithArray:responseObject];
        [self.tweets reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void) fetchMoreTweets:(NSString *)max_id {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Client *client = [Client instance];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:max_id, @"max_id", nil];
    [client nexthomeTimelineWithSuccess:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *newTweets = [Tweet tweetsWithArray:responseObject];
        
        [self.tweets performBatchUpdates:^{
            int resultsSize = [self.currentTweets count];
            [self.currentTweets addObjectsFromArray:newTweets];
            for (int i = resultsSize; i < resultsSize + newTweets.count; i++) {
                NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
                [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                [self.tweets insertItemsAtIndexPaths:arrayWithIndexPaths];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void) onFavoriteButton:(id)sender {
    NSInteger tid = ((UIControl *) sender).tag;
    //NSLog(@"%d", tid);
    
    BOOL favorited = [[[self.currentTweets objectAtIndex:tid] objectForKey:@"favorited"] boolValue];
    NSString *tweetId = [[self.currentTweets objectAtIndex:tid] objectForKey:@"id"];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:tweetId, @"id", nil];
    Client *client = [Client instance];
    
    if (favorited) {
        [sender setImage:[UIImage imageNamed:@"ic_star_outline_grey_8.png"] forState:UIControlStateNormal];
        [client destoryFavoriteTweetWithSuccess:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    } else {
        [sender setImage:[UIImage imageNamed:@"ic_star_yellow_8.png"] forState:UIControlStateNormal];
        [client favoriteTweetWithSuccess:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}

- (void) onRetweetButton:(id)sender {
    NSInteger tid = ((UIControl *) sender).tag;
    NSString *tweetId = [[self.currentTweets objectAtIndex:tid] objectForKey:@"id"];
    Client *client = [Client instance];
    NSString *retwtUrl = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    
    BOOL retweeted = [[[self.currentTweets objectAtIndex:tid] objectForKey:@"retweeted"] boolValue];
    
    if (!retweeted) {
        [client retweetWithSuccess:retwtUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"retweet id: %@", [responseObject objectForKey:@"id_str"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        [sender setTitleColor:[UIColor colorWithRed:244.f/255.f green:180.f/255.f blue:0 alpha:1.f] forState:UIControlStateNormal];
        [[self.currentTweets objectAtIndex:tid] setObject:[NSNumber numberWithBool:YES] forKey:@"retweeted"];
    }
}

- (void) onReplyButton:(id)sender {
    NSInteger tid = ((UIControl *) sender).tag;
    NewTweetViewController *editor = [[NewTweetViewController alloc] initWithNibName:@"NewTweetViewController" bundle:nil];
    editor.title = @"New tweet";
    editor.backTo = @"";
    editor.replyTo = [[[self.currentTweets objectAtIndex:tid] objectForKey:@"user"] objectForKey:@"screen_name"];
    editor.savedTweets = self.currentTweets;
    [self.navigationController pushViewController:editor animated:YES];
}

- (IBAction)onLeftNavButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toggleLeftMenu)]) {
        [self.delegate toggleLeftMenu];
    }
}

@end
