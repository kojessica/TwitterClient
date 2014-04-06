//
//  NewTweetViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 3/29/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "NewTweetViewController.h"
#import "HomeViewController.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "Client.h"
#import "LeftNavViewController.h"
#import "MyProfileViewController.h"

@interface NewTweetViewController ()

- (IBAction)onCancelButton:(id)sender;
- (IBAction)onTweetButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *countDown;

@end

@implementation NewTweetViewController

static int maximumNumCharacters = 140;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.delegate = self;
    NSLog(@"%@", self.replyTo);
    if ([self.replyTo length] > 0) {
        self.textView.text = [NSString stringWithFormat:@"@%@ ", self.replyTo];
    }
    [self.textView becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.backgroundColor = [UIColor colorWithRed:250 green:250 blue:250 alpha:1.f];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    self.countDown.text = [NSString stringWithFormat:@"%i", maximumNumCharacters - textView.text.length - 1];
    
    if (textView.text.length + text.length > maximumNumCharacters){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)onCancelButton:(id)sender {
    if ([self.backTo isEqualToString:@"detailview"]) {
        DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        detail.tweet = self.savedTweet;
        NSMutableArray *vcs =  [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [vcs insertObject:detail atIndex:[vcs count]-1];
        [self.navigationController setViewControllers:vcs animated:NO];
        [self.navigationController popViewControllerAnimated:YES];
    } else {

        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        LeftNavViewController *leftMenuViewController = [[LeftNavViewController alloc] init];
        MyProfileViewController *profileViewController = [[MyProfileViewController alloc] init];
        MenuSliderViewController *slidingMenuContainer = [[MenuSliderViewController alloc] initWithRootViewController:homeViewController leftViewController:leftMenuViewController profileController:profileViewController];

        NSMutableArray *vcs =  [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [vcs insertObject:slidingMenuContainer atIndex:[vcs count]-1];
        [self.navigationController setViewControllers:vcs animated:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onTweetButton:(id)sender {
    if (self.textView.text.length > 0) {
        Client *client = [Client instance];
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.textView.text, @"status", nil];
        [client tweetWithSuccess:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        LeftNavViewController *leftMenuViewController = [[LeftNavViewController alloc] init];
        MyProfileViewController *profileViewController = [[MyProfileViewController alloc] init];
        MenuSliderViewController *slidingMenuContainer = [[MenuSliderViewController alloc] initWithRootViewController:homeViewController leftViewController:leftMenuViewController profileController:profileViewController];
        
        homeViewController.theNewTweet = self.textView.text;
        homeViewController.currentTweets = self.savedTweets;
        NSMutableArray *vcs =  [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [vcs insertObject:slidingMenuContainer atIndex:[vcs count]-1];
        [self.navigationController setViewControllers:vcs animated:NO];
        [self.navigationController popViewControllerAnimated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Tweeting...";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
    }
}

@end
