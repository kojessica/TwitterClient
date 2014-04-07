//
//  MyProfileViewController.h
//  TwitterClient
//
//  Created by Jessica Ko on 4/4/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSliderViewController.h"
#import "TweetCell.h"

@interface MyProfileViewController : UIViewController<MenuProtocol, UICollectionViewDataSource, UICollectionViewDelegate, TweetCellProtocol>

- (IBAction)onLeftNavButton:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *tweetTable;
@property (strong, nonatomic) NSString *screenId;

@end
