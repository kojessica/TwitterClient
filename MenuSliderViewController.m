//
//  MenuSliderViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 4/3/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "MenuSliderViewController.h"
#import "LeftNavViewController.h"
#import "MyProfileViewController.h"
#import "HomeViewController.h"

@interface MenuSliderViewController ()

@property (nonatomic,strong) UIViewController<MenuProtocol> *rootViewController;
@property (nonatomic,strong) UIViewController<MenuProtocol> *leftViewController;
@property (nonatomic,strong) UIViewController<MenuProtocol> *profileController;
@property (nonatomic,strong) UIView *overlay;
@property (nonatomic,assign) BOOL leftViewVisible;
@property (nonatomic,assign) BOOL profileViewVisible;
-(void)onTouch:(id)sender;

@end

@implementation MenuSliderViewController

- (instancetype)initWithRootViewController:(UIViewController<MenuProtocol> *)rootViewController leftViewController:(UIViewController<MenuProtocol> *)leftViewController profileController:(UIViewController<MenuProtocol> *)profileController {
    self = [super init];
    
    if (self) {
        _rootViewController = rootViewController;
        _leftViewController = leftViewController;
        _profileController = profileController;
        _overlay = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0.f, 60.f, self.view.frame.size.height)];
        [_overlay setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_overlay];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.rootViewController.view];
    [self addChildViewController:self.rootViewController];
    [self.rootViewController didMoveToParentViewController:self];
    self.rootViewController.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)leftView {
    if (![self.rootViewController.childViewControllers containsObject:self.leftViewController]) {
        [self.view addSubview:self.leftViewController.view];
        [self addChildViewController:self.leftViewController];
        [self.leftViewController didMoveToParentViewController:self];
    }
    
    return self.leftViewController.view;
}

- (UIView *)profileView {
    if (![self.rootViewController.childViewControllers containsObject:self.profileController]) {
        [self.view addSubview:self.profileController.view];
        [self addChildViewController:self.profileController];
        [self.profileController didMoveToParentViewController:self];
    }
    
    return self.profileController.view;
}


- (void)toggleLeftMenu {

    NSLog(@"hello");
    
    if (self.leftViewVisible) {
        self.rootViewController.delegate = self;
        [self resetMenu];
    } else {
        self.leftViewController.delegate = self;
        
        [self.view sendSubviewToBack:[self leftView]];
        [self.view bringSubviewToFront:self.overlay];
    
        self.overlay.frame = CGRectMake(self.view.frame.size.width - 60.f, 0.f, 60.f, self.view.frame.size.height);
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch:)];
        
        UITapGestureRecognizer *tabRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch:)];
        
        [self.overlay addGestureRecognizer:panRecognizer];
        [self.overlay addGestureRecognizer:tabRecognizer];
        
        [UIView animateWithDuration:0.9f
                              delay:0.0f
             usingSpringWithDamping:0.9f
              initialSpringVelocity:10.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect currentFrame = self.rootViewController.view.frame;
                             self.rootViewController.view.frame = CGRectOffset(currentFrame,(self.view.frame.size.width - 60.0f), 0.0f);
                             self.profileController.view.frame = CGRectOffset(currentFrame,(self.view.frame.size.width - 60.0f), 0.0f);
                             
                             CALayer *layer = self.rootViewController.view.layer;
                             layer.shadowOffset = CGSizeMake(1, 1);
                             layer.shadowColor = [[UIColor blackColor] CGColor];
                             layer.shadowRadius = 4.0f;
                             layer.shadowOpacity = 0.80f;
                             layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
                             
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 self.leftViewVisible = YES;
                             }
                         }];
    }
}

- (void)onTouch:(id)sender {
    [self resetMenu];
    self.overlay.frame = CGRectMake(self.view.frame.size.width, 0.f, 60.f, self.view.frame.size.height);
}

- (void)loadProfile {
    NSLog(@"load profile");
    [self resetMenu];
    self.profileController.delegate = self;

    [self.view bringSubviewToFront:[self profileView]];
    
    [UIView animateWithDuration:0.9f
                          delay:0.0f
         usingSpringWithDamping:0.9f
          initialSpringVelocity:10.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect currentFrame = self.rootViewController.view.frame;
                         self.profileController.view.frame = CGRectOffset(currentFrame,0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.leftViewVisible = NO;
                         }
                     }];
}

- (void)loadHome {
    NSLog(@"load home");
    self.rootViewController.delegate = self;
    [self.view sendSubviewToBack:[self profileView]];
    [self resetMenu];
}

- (void)resetMenu {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0.8f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            CGRect currentFrame = self.rootViewController.view.frame;
                            self.rootViewController.view.frame = CGRectMake(0.0f, 0.0f, currentFrame.size.width, currentFrame.size.height);
                            self.profileController.view.frame = CGRectMake(0.0f, 0.0f, currentFrame.size.width, currentFrame.size.height);
                        } completion:^(BOOL finished) {
                            if (finished) {
                                self.leftViewVisible = NO;
                            }
                        }];
}
@end
