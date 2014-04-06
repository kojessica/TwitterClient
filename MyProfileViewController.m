//
//  MyProfileViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 4/4/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLeftNavButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toggleLeftMenu)]) {
        [self.delegate toggleLeftMenu];
    }
}
@end
