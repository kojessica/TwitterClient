//
//  HomeViewController.h
//  TwitterClient
//
//  Created by Jessica Ko on 3/28/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSliderViewController.h"
#import "TweetCell.h"

@interface HomeViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MenuProtocol, TweetCellProtocol>

- (IBAction)onNewButton:(id)sender;
@property (strong, nonatomic) NSString *theNewTweet;
@property (strong, nonatomic) NSMutableArray *currentTweets;
- (IBAction)onLeftNavButton:(id)sender;

@end
