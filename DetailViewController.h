//
//  DetailViewController.h
//  TwitterClient
//
//  Created by Jessica Ko on 3/29/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *tImage;
@property (weak, nonatomic) IBOutlet UILabel *tName;
@property (weak, nonatomic) IBOutlet UILabel *tScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tContent;
@property (weak, nonatomic) IBOutlet UILabel *tTime;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
- (IBAction)onFavoriteButton:(id)sender;
- (IBAction)onRetweetButton:(id)sender;
- (IBAction)onReplyButton:(id)sender;
- (IBAction)onReply:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) NSMutableArray *savedTweets;

@end
