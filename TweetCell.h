//
//  TweetCell.h
//  TwitterClient
//
//  Created by Jessica Ko on 3/28/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellProtocol <NSObject>

@optional
-(void)sender:(TweetCell *)sender didTap:(NSString *)tweetId;
@end

@interface TweetCell : UICollectionViewCell <TweetCellProtocol>

@property (nonatomic,weak) id<TweetCellProtocol>delegate;
@property (weak, nonatomic) IBOutlet UILabel *tName;
@property (weak, nonatomic) IBOutlet UIImageView *tImage;
@property (weak, nonatomic) IBOutlet UILabel *tContent;
@property (weak, nonatomic) IBOutlet UILabel *tScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tTime;
- (id)cellWithTweet:(NSDictionary *)tweet;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *reTweetButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end
