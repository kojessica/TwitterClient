//
//  User.m
//  TwitterClient
//
//  Created by Jessica Ko on 3/28/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "User.h"
#import "Client.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@implementation User

static User *currentUser = nil;

- (id)initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        _data = data;
    }
    
    return self;
}


+ (User *)currentUser {
    if (currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dictionary) {
            currentUser = [[User alloc] initWithDictionary:dictionary];
            NSLog(@"%@", dictionary);
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    if (user) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user.data] forKey:@"current_user"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"current_user"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (user && !currentUser) {
        currentUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    } else if (!user && currentUser) {
        currentUser = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    }
}

@end
