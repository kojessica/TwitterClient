//
//  LeftNavViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 4/3/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "LeftNavViewController.h"
#import "MenuSliderViewController.h"
#import "MyProfileViewController.h"
#import "Client.h"
#import "User.h"

@interface LeftNavViewController ()

- (void)handleTap:(UITapGestureRecognizer *)recognizer;

@end

@implementation LeftNavViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *currentUser = [User currentUserDictionary];
    self.fullname.text = [currentUser objectForKey:@"name"];
    self.screenname.text = [currentUser objectForKey:@"screen_name"];
    
    
    NSString *biggerImgUrl = [[currentUser objectForKey:@"profile_image_url"] stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    
    NSURL *url = [NSURL URLWithString:biggerImgUrl];
    NSLog(@"%@", currentUser);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileImage.image = [UIImage imageWithData:imageData];
        });
    });
    
    NSURL *urlbg = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web", [currentUser objectForKey:@"profile_banner_url"]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageDataBG = [NSData dataWithContentsOfURL:urlbg];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImage.image = [UIImage imageWithData:imageDataBG];
        });
    });

    UITapGestureRecognizer *tabRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.profileImage addGestureRecognizer:tabRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnMyProfileLink:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loadProfile)]) {
        [self.delegate loadProfile];
    }
}

- (IBAction)OnMyHomeLink:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loadHome)]) {
        [self.delegate loadHome];
    }
}

- (IBAction)OnSignOutLink:(id)sender {
    Client *client = [Client instance];
    [client logout];
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(loadProfile)]) {
        [self.delegate loadProfile];
    }
}

@end
