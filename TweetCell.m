//
//  TweetCell.m
//  TwitterClient
//
//  Created by Jessica Ko on 3/28/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "TweetCell.h"
#import "Timestamp.h"

@implementation TweetCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (id)cellWithTweet:(NSDictionary *)tweet
{
    self.tContent.text = [tweet objectForKey:@"text"];
    self.tName.text = [[tweet objectForKey:@"user"] objectForKey:@"name"];
    [self.tScreenName setText:[NSString stringWithFormat: @"@%@", [[tweet objectForKey:@"user"] objectForKey:@"screen_name"]]];
    self.tTime.text = [tweet objectForKey:@"created_at"];
    
    //Format time
    NSDate *date = [Timestamp dateWithJSONString:[tweet objectForKey:@"created_at"]];
    NSString *formattedDate = [Timestamp relativeTimeWithTimestamp:date];
    
    self.tTime.text = formattedDate;

    
    NSURL *url = [NSURL URLWithString:[[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tImage.image = [UIImage imageWithData:imageData];
        });
    });
    self.tContent.numberOfLines = 0;
    [self.tContent sizeToFit];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
