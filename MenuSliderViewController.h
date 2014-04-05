//
//  MenuSliderViewController.h
//  TwitterClient
//
//  Created by Jessica Ko on 4/3/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuProtocol <NSObject>

@optional

- (void)toggleLeftMenu;
- (void)resetMenu;

@property (nonatomic,weak) id<MenuProtocol>delegate;

@end


@interface MenuSliderViewController : UIViewController <MenuProtocol>

- (instancetype)initWithRootViewController:(UIViewController<MenuProtocol> *)rootViewController
                        leftViewController:(UIViewController *)leftViewController;

@end
