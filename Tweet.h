//
//  Tweet.h
//  TwitterClient
//
//  Created by Jessica Ko on 3/29/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, strong) NSDictionary *tweet;
+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
