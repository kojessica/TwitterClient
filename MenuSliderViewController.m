//
//  MenuSliderViewController.m
//  TwitterClient
//
//  Created by Jessica Ko on 4/3/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "MenuSliderViewController.h"

@interface MenuSliderViewController ()

@property (nonatomic,strong) UIViewController<MenuProtocol> *rootViewController;
@property (nonatomic,strong) UIViewController *leftViewController;
@property (nonatomic,strong) UIView *overlay;
@property (nonatomic,assign) BOOL leftViewVisible;
-(void)onTouch:(id)sender;

@end

@implementation MenuSliderViewController

- (instancetype)initWithRootViewController:(UIViewController<MenuProtocol> *)rootViewController leftViewController:(UIViewController *)leftViewController
{
    self = [super init];
    
    if (self) {
        _rootViewController = rootViewController;
        _leftViewController = leftViewController;
        _overlay = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0.f, 60.f, self.view.frame.size.height)];
        [_overlay setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_overlay];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.rootViewController.view];
    [self addChildViewController:self.rootViewController];
    [self.rootViewController didMoveToParentViewController:self];
    self.rootViewController.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)leftView
{
    if (![self.rootViewController.childViewControllers containsObject:self.leftViewController]) {
        [self.view addSubview:self.leftViewController.view];
        [self addChildViewController:self.leftViewController];
        [self.leftViewController didMoveToParentViewController:self];
    }
    
    return self.leftViewController.view;
}

- (void)toggleLeftMenu
{

    NSLog(@"hello");
    
    if (self.leftViewVisible) {
        [self resetMenu];
    } else {
        [self.view sendSubviewToBack:[self leftView]];
        
        
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
    NSLog(@"%@", sender);
    self.overlay.frame = CGRectMake(self.view.frame.size.width, 0.f, 60.f, self.view.frame.size.height);
}


- (void)resetMenu
{
    [UIView animateWithDuration:0.9f
                          delay:0.0f
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0.8f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            CGRect currentFrame = self.rootViewController.view.frame;
                            self.rootViewController.view.frame = CGRectMake(0.0f, 0.0f, currentFrame.size.width, currentFrame.size.height);
                        } completion:^(BOOL finished) {
                            if (finished) {
                                self.leftViewVisible = NO;
                            }
                        }];
}
@end
