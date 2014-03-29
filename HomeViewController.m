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

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *tweets;

@end

NSString * const didTweet = @"didTweet";

@implementation HomeViewController

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
    self.tweets.dataSource = self;
    self.tweets.delegate = self;
    

    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tweets registerNib:customNib forCellWithReuseIdentifier:@"TweetCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fakeTweet:) name:didTweet object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 50);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
   
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
    NSLog(@"%@",  [notification.userInfo objectForKey:@"new_tweet"]);
}

@end
