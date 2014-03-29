//
//  User.h
//  TwitterClient
//
//  Created by Jessica Ko on 3/28/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSDictionary *data;
+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
- (id)initWithDictionary:(NSDictionary *)data;

@end
