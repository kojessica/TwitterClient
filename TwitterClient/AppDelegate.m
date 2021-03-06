//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Jessica Ko on 3/28/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Client.h"
#import "HomeViewController.h"
#import "User.h"
#import "LeftNavViewController.h"
#import "MenuSliderViewController.h"
#import "MyProfileViewController.h"
#import "MentionsViewController.h"

@interface AppDelegate ()

- (void)updateRoot:(NSNotification *)notification;

@end

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    LeftNavViewController *leftMenuViewController = [[LeftNavViewController alloc] init];
    MyProfileViewController *profileViewController = [[MyProfileViewController alloc] init];
    MentionsViewController *mentionsViewController = [[MentionsViewController alloc] init];

    MenuSliderViewController *slidingMenuContainer = [[MenuSliderViewController alloc] initWithRootViewController:homeViewController leftViewController:leftMenuViewController profileController:profileViewController mentionsController:mentionsViewController];
    
    
    if ([User currentUser]) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:slidingMenuContainer];
        self.window.rootViewController = nav;
        nav.navigationBar.hidden = YES;
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        self.window.rootViewController = nav;
        nav.navigationBar.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoot:) name:UserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoot:) name:UserDidLogoutNotification object:nil];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)updateRoot:(NSNotification *)notification {
    if ([[notification name] isEqualToString:UserDidLoginNotification]) {
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        LeftNavViewController *leftMenuViewController = [[LeftNavViewController alloc] init];
        MyProfileViewController *profileViewController = [[MyProfileViewController alloc] init];
        MentionsViewController *mentionsViewController = [[MentionsViewController alloc] init];
        
        MenuSliderViewController *slidingMenuContainer = [[MenuSliderViewController alloc] initWithRootViewController:homeViewController leftViewController:leftMenuViewController profileController:profileViewController mentionsController:mentionsViewController];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:slidingMenuContainer];
        self.window.rootViewController = nav;
        nav.navigationBar.hidden = YES;
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        self.window.rootViewController = nav;
        nav.navigationBar.hidden = YES;
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"cptwitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                
                Client *client = [Client instance];
                [client fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    
                    [client.requestSerializer saveAccessToken:accessToken];
                    
                    [client currentUserWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
                        //NSLog(@"response: %@", response);
                        [User setCurrentUser:[[User alloc] initWithDictionary:response]];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    }];

                } failure:^(NSError *error) {
                    NSLog(@"%@", error);
                }];

            }
          }
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
