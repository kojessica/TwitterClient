//
//  MyProfileViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 4/4/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "MyProfileViewController.h"
#import "User.h"
#import "ProfileHeader.h"
#import "TweetCell.h"
#import "MBProgressHUD.h"
#import "Client.h"
#import "NewTweetViewController.h"

@interface MyProfileViewController ()

- (void) reload;
-(void) fetchMoreTweets:(NSString *)max_id;
-(void) onFavoriteButton:(id)sender;
-(void) onRetweetButton:(id)sender;
-(void) onReplyButton:(id)sender;
-(void) loadOtherProfile;
@property (strong, nonatomic) NSDictionary *currentUser;
@property (strong, nonatomic) NSMutableArray *currentTweets;

@end

@implementation MyProfileViewController

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
    self.tweetTable.dataSource = self;
    self.tweetTable.delegate = self;
    
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tweetTable registerNib:customNib forCellWithReuseIdentifier:@"TweetCell"];

    UINib *customHeaderNib = [UINib nibWithNibName:@"ProfileHeader" bundle:nil];
    [self.tweetTable registerNib:customHeaderNib forCellWithReuseIdentifier:@"ProfileHeader"];
    
    NSLog(@"%@", self.screenId);
    
    if (!self.screenId) {
        self.currentUser = [User currentUserDictionary];
        [self reload];
    } else {
        [self loadOtherProfile];
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.currentTweets count] + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake(320, 295);
    } else {
        NSString *name = [self.currentTweets objectAtIndex:indexPath.row-1][@"text"];
        CGSize maximumLabelSize = CGSizeMake(230,9999);
        UIFont *font=[UIFont systemFontOfSize:13];
        CGRect textRect = [name  boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        return CGSizeMake(320, textRect.size.height + 75);
    }
}

- (void)sender:(TweetCell *)sender didTap:(NSString *)tweetId {
    MyProfileViewController *modalViewController = [[MyProfileViewController alloc] init];
    modalViewController.screenId = tweetId;
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ProfileHeader *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileHeader" forIndexPath:indexPath];
        
        
        [cell.profileBanner setBackgroundColor:[UIColor blackColor]];
        NSURL *urlbg = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web", [self.currentUser objectForKey:@"profile_banner_url"]]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageDataBG = [NSData dataWithContentsOfURL:urlbg];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.profileBanner.image = [UIImage imageWithData:imageDataBG];
            });
        });
        
        NSString *biggerImgUrl = [[self.currentUser objectForKey:@"profile_image_url"] stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        
        NSURL *url = [NSURL URLWithString:biggerImgUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.profileImage.image = [UIImage imageWithData:imageData];
            });
        });
        
        cell.profileName.text = [self.currentUser objectForKey:@"name"];
        cell.screenName.text = [NSString stringWithFormat:@"@%@", [self.currentUser objectForKey:@"screen_name"]];
        cell.profileDescription.text = [self.currentUser objectForKey:@"description"];
        cell.tweetsTotal.text = [NSString stringWithFormat:@"%@", [self.currentUser objectForKey:@"statuses_count"]];
        cell.followerTotal.text = [NSString stringWithFormat:@"%@", [self.currentUser objectForKey:@"followers_count"]];
        cell.followingTotal.text = [NSString stringWithFormat:@"%@", [self.currentUser objectForKey:@"following"]];
        
        CALayer * l = [cell.profileImage layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:8.0];
        [cell.profileImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [cell.profileImage.layer setBorderWidth: 2.0];
        
        return cell;
    } else {
        TweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
        
        //NSLog(@"%@", [[self.currentTweets objectAtIndex:indexPath.row] objectForKey:@"text"]);
        NSDictionary *twt = [self.currentTweets objectAtIndex:indexPath.row-1];
        [cell cellWithTweet:twt];
        cell.tContent.numberOfLines = 0;
        [cell.tContent sizeToFit];
        
        BOOL favorited = [[[self.currentTweets objectAtIndex:indexPath.row-1] objectForKey:@"favorited"] boolValue];
        if (favorited) {
            [cell.favoriteButton setImage:[UIImage imageNamed:@"ic_star_yellow_8.png"] forState:UIControlStateNormal];
        }
        
        BOOL retweeted = [[[self.currentTweets objectAtIndex:indexPath.row-1] objectForKey:@"retweeted"] boolValue];
        if (retweeted) {
            [cell.reTweetButton setTitleColor:[UIColor colorWithRed:244.f/255.f green:180.f/255.f blue:0 alpha:1.f] forState:UIControlStateNormal];
        }
        
        
        cell.favoriteButton.tag = indexPath.row;
        [cell.favoriteButton addTarget:self action:@selector(onFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.reTweetButton.tag = indexPath.row;
        [cell.reTweetButton addTarget:self action:@selector(onRetweetButton:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.replyButton.tag = indexPath.row;
        [cell.replyButton addTarget:self action:@selector(onReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row == ([self.currentTweets count])) {
            [self fetchMoreTweets:[[self.currentTweets objectAtIndex:([self.currentTweets count] - 1)] objectForKey:@"id"]];
        }
        
        cell.delegate = self;

        return cell;
    }
}

- (void) fetchMoreTweets:(NSString *)max_id {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Client *client = [Client instance];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:max_id, @"max_id", nil];
    [client nexthomeTimelineWithSuccess:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *newTweets = [Tweet tweetsWithArray:responseObject];
        
        [self.tweetTable performBatchUpdates:^{
            int resultsSize = [self.currentTweets count];
            [self.currentTweets addObjectsFromArray:newTweets];
            for (int i = resultsSize; i < resultsSize + newTweets.count; i++) {
                NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
                [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                [self.tweetTable insertItemsAtIndexPaths:arrayWithIndexPaths];
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


- (void) reload {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Client *client = [Client instance];
    [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.currentTweets = [Tweet tweetsWithArray:responseObject];
        [self.tweetTable reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void) loadOtherProfile {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Client *client = [Client instance];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjects:@[self.screenId] forKeys:@[@"screen_name"]];
    
    [client getUserProfile:param success:^(AFHTTPRequestOperation *operation, id responseUserObject) {
        self.currentUser = responseUserObject;
        
        [client otherUserTimelineWithSuccess:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.currentTweets = [Tweet tweetsWithArray:responseObject];
            [self.tweetTable reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLeftNavButton:(id)sender {
    if (!self.screenId) {
        if ([self.delegate respondsToSelector:@selector(toggleLeftMenu)]) {
            [self.delegate toggleLeftMenu];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
