//
//  LeftNavViewController.h
//  TwitterClient
//
//  Created by Jessica Ko on 4/3/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSliderViewController.h"

@interface LeftNavViewController : UIViewController<MenuProtocol>

- (IBAction)OnMyHomeLink:(id)sender;
- (IBAction)OnSignOutLink:(id)sender;
- (IBAction)OnMentionsLink:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fullname;
@property (weak, nonatomic) IBOutlet UILabel *screenname;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
