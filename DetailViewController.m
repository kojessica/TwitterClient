//
//  DetailViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 3/29/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "DetailViewController.h"
#import "HomeViewController.h"
#import "Timestamp.h"

@interface DetailViewController ()

- (IBAction)onBackButton:(id)sender;

@end

@implementation DetailViewController

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
    self.tContent.text = [self.tweet objectForKey:@"text"];
    [self.tName setText:[NSString stringWithFormat: @"%@", [[self.tweet objectForKey:@"user"] objectForKey:@"name"]]];
    [self.tScreenName setText:[NSString stringWithFormat: @"@%@", [[self.tweet objectForKey:@"user"] objectForKey:@"screen_name"]]];
    
    NSString *formattedDate = [Timestamp formattedDateWithJSONString:[self.tweet objectForKey:@"created_at"]];
    
    self.tTime.text = formattedDate;
    
    NSURL *url = [NSURL URLWithString:[[self.tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tImage.image = [UIImage imageWithData:imageData];
        });
    });
    self.tContent.numberOfLines = 0;
    [self.tContent sizeToFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    NSMutableArray *vcs =  [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs insertObject:home atIndex:[vcs count]-1];
    [self.navigationController setViewControllers:vcs animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
