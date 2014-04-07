//
//  Client.m
//  TwitterClient
//
//  Created by Jessica Ko on 3/28/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "Client.h"
#import "User.h"

NSString * const twitterConsumerKey = @"hEfuuotJxxbFCGR4WSqVZMYVS";
NSString * const twitterConsumerSecret = @"2rxJ0Dh76LhSO2kzewYGANp8G4VjysPk5nmRc0EasBQKixghWA";

/*
NSString * const twitterConsumerKey = @"OaGBrR0bQX6cVutGvarAEY0bR";
NSString * const twitterConsumerSecret = @"WeHKYymLtobMkuFUMvWp0zFODJmigwDGj0xaalgLoZtHw2qbEW";
*/

@implementation Client

+ (Client *)instance {
    static Client *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[Client alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:twitterConsumerKey consumerSecret:twitterConsumerSecret];
    });
    
    return instance;
}

- (void) login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cptwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void) logout {
    [self.requestSerializer removeAccessToken];
    [User setCurrentUser:nil];
}

- (AFHTTPRequestOperation *)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)favoriteTweetWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    return [self POST:@"1.1/favorites/create.json" parameters:param success:success failure:failure];
}

- (AFHTTPRequestOperation *)destoryFavoriteTweetWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    return [self POST:@"1.1/favorites/destroy.json" parameters:param success:success failure:failure];
}

- (AFHTTPRequestOperation *)tweetWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    return [self POST:@"1.1/statuses/update.json" parameters:param success:success failure:failure];
}

- (AFHTTPRequestOperation *)retweetWithSuccess:(NSString *)retweetUrl success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    return [self POST:retweetUrl parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)destoryRetweetWithSuccess:(NSString *)retweetUrl success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    return [self POST:retweetUrl parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)nexthomeTimelineWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:param success:success failure:failure];
}

- (AFHTTPRequestOperation *)otherUserTimelineWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:param success:success failure:failure];
}

- (AFHTTPRequestOperation *)getUserProfile:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    return [self GET:@"1.1/users/show.json" parameters:param success:success failure:failure];
}

@end
