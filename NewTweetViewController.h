//
//  NewTweetViewController.h
//  TwitterClient
//
//  Created by Jessica Ko on 3/29/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTweetViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSMutableArray *savedTweets;
@property (strong, nonatomic) NSString *replyTo;

@end
