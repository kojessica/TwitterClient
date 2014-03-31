//
//  Timestamp.h
//  TwitterClient
//
//  Created by Jessica Ko on 3/30/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timestamp : NSObject

+ (NSString *)relativeTimeWithTimestamp:(NSDate *)date;
+ (NSDate*)dateWithJSONString:(NSString*)dateStr;
+ (NSString*)formattedDateWithJSONString:(NSString*)dateStr;

@end
