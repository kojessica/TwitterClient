//
//  DetailViewController.h
//  TwitterClient
//
//  Created by Jessica Ko on 3/29/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *tImage;
@property (weak, nonatomic) IBOutlet UILabel *tName;
@property (weak, nonatomic) IBOutlet UILabel *tScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tContent;
@property (weak, nonatomic) IBOutlet UILabel *tTime;

@end
