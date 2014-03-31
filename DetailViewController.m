//
//  DetailViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 3/29/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "DetailViewController.h"
#import "HomeViewController.h"
#import "Timestamp.h"
#import "NewTweetViewController.h"
#import "Client.h"

@interface DetailViewController ()

- (IBAction)onBackButton:(id)sender;
- (void)reply;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tContent.text = [self.tweet objectForKey:@"text"];
    self.retweetCount.text = [NSString stringWithFormat:@"%@", [self.tweet objectForKey:@"retweet_count"]];
    self.favoriteCount.text = [NSString stringWithFormat:@"%@", [self.tweet objectForKey:@"favorite_count"]];
    [self.tName setText:[NSString stringWithFormat: @"%@", [[self.tweet objectForKey:@"user"] objectForKey:@"name"]]];
    [self.tScreenName setText:[NSString stringWithFormat: @"@%@", [[self.tweet objectForKey:@"user"] objectForKey:@"screen_name"]]];

    BOOL favorited = [[self.tweet objectForKey:@"favorited"] boolValue];
    if (favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"ic_star_yellow_8.png"] forState:UIControlStateNormal];
    }
    
    BOOL retweeted = [[self.tweet objectForKey:@"retweeted"] boolValue];
    if (retweeted) {
        [self.retweetButton setTitleColor:[UIColor colorWithRed:244.f/255.f green:180.f/255.f blue:0 alpha:1.f] forState:UIControlStateNormal];
    }
    
    
    NSString *formattedDate = [Timestamp formattedDateWithJSONString:[self.tweet objectForKey:@"created_at"]];
    
    self.tTime.text = formattedDate;
    
    NSURL *url = [NSURL URLWithString:[[self.tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tImage.image = [UIImage imageWithData:imageData];
        });
    });
    self.tContent.numberOfLines = 0;
    [self.tContent sizeToFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    NSMutableArray *vcs =  [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs insertObject:home atIndex:[vcs count]-1];
    [self.navigationController setViewControllers:vcs animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)onFavoriteButton:(id)sender {
    BOOL favorited = [[self.tweet objectForKey:@"favorited"] boolValue];
    NSString *tweetId = [self.tweet objectForKey:@"id"];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:tweetId, @"id", nil];
    Client *client = [Client instance];
    
    if (favorited) {
        [sender setImage:[UIImage imageNamed:@"ic_star_outline_grey_8.png"] forState:UIControlStateNormal];
        [client destoryFavoriteTweetWithSuccess:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        NSInteger favCount = [[self.tweet objectForKey:@"favorite_count"] intValue];
        self.favoriteCount.text = [NSString stringWithFormat:@"%d", favCount-1];
    } else {
        [sender setImage:[UIImage imageNamed:@"ic_star_yellow_8.png"] forState:UIControlStateNormal];
        [client favoriteTweetWithSuccess:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        NSInteger favCount = [[self.tweet objectForKey:@"favorite_count"] intValue];
        self.favoriteCount.text = [NSString stringWithFormat:@"%d", favCount+1];
    }
}

- (IBAction)onRetweetButton:(id)sender {
    NSString *tweetId = [self.tweet objectForKey:@"id"];
    Client *client = [Client instance];
    NSString *retwtUrl = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    
    BOOL retweeted = [[self.tweet objectForKey:@"retweeted"] boolValue];
    
    if (retweeted) {
    } else {
        [client retweetWithSuccess:retwtUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        [sender setTitleColor:[UIColor colorWithRed:244.f/255.f green:180.f/255.f blue:0 alpha:1.f] forState:UIControlStateNormal];
        [self.tweet setObject:[NSNumber numberWithBool:YES] forKey:@"retweeted"];
        NSInteger retweetCount = [[self.tweet objectForKey:@"retweet_count"] intValue];
        self.retweetCount.text = [NSString stringWithFormat:@"%d", retweetCount+1];
    }

}

- (IBAction)onReplyButton:(id)sender {
    [self reply];
}

- (IBAction)onReply:(id)sender {
    [self reply];
}

- (void)reply {
    NewTweetViewController *editor = [[NewTweetViewController alloc] initWithNibName:@"NewTweetViewController" bundle:nil];
    editor.title = @"New tweet";
    editor.backTo = @"detailview";
    editor.savedTweet = self.tweet;
    editor.savedTweets = self.savedTweets;
    editor.replyTo = [[self.tweet objectForKey:@"user"] objectForKey:@"screen_name"];
    
    [self.navigationController pushViewController:editor animated:YES];
}
@end
