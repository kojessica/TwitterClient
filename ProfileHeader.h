//
//  ProfileHeader.h
//  TwitterClient
//
//  Created by Jessica Ko on 4/6/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeader : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileBanner;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *profileDescription;
@property (weak, nonatomic) IBOutlet UILabel *tweetsTotal;
@property (weak, nonatomic) IBOutlet UILabel *followingTotal;
@property (weak, nonatomic) IBOutlet UILabel *followerTotal;

@end
