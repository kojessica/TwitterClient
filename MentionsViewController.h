//
//  MentionsViewController.h
//  TwitterClient
//
//  Created by Jessica Ko on 4/7/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSliderViewController.h"
#import "TweetCell.h"

@interface MentionsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MenuProtocol, TweetCellProtocol>

@property (weak, nonatomic) IBOutlet UICollectionView *tweets;
@property (strong, nonatomic) NSMutableArray *currentTweets;
- (IBAction)onLeftNavButton:(id)sender;

@end
