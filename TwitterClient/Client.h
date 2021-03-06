//
//  Client.h
//  TwitterClient
//
//  Created by Jessica Ko on 3/28/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface Client : BDBOAuth1RequestOperationManager

+ (Client *)instance;
- (void) login;
- (void) logout;
- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
- (AFHTTPRequestOperation *)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)favoriteTweetWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
- (AFHTTPRequestOperation *)destoryFavoriteTweetWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
- (AFHTTPRequestOperation *)tweetWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
- (AFHTTPRequestOperation *)retweetWithSuccess:(NSString *)retweetUrl success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
- (AFHTTPRequestOperation *)destoryRetweetWithSuccess:(NSString *)retweetUrl success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
- (AFHTTPRequestOperation *)nexthomeTimelineWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
- (AFHTTPRequestOperation *)otherUserTimelineWithSuccess:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
- (AFHTTPRequestOperation *)getUserProfile:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
- (AFHTTPRequestOperation *)mentionsTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;
@end
