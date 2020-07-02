//
//  Tweet.h
//  twitter
//
//  Created by Adrienne Li on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject

// properties
@property (nonatomic, strong) NSString *idStr; // for favoriting, retweeting, and replying
@property (nonatomic, strong) NSString *text; // tweet content
@property (nonatomic) int favoriteCount; // favorite count label
@property (nonatomic) BOOL favorited; // configure favorite button
@property (nonatomic) int retweetCount; // retweet count label
@property (nonatomic) BOOL retweeted; // configure retweet button
@property (nonatomic, strong) User *user; // contains tweet author's name, screenname, etc.
@property (nonatomic, strong) NSString *createdAtString; // Display date
@property (nonatomic, strong) NSDate *date; // date tweet was created
@property (nonatomic, strong) NSURL *mediaURL; // link to media

// for retweets
@property (nonatomic, strong) User *retweetedByUser; // user who retweeted
// create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries;
@end

NS_ASSUME_NONNULL_END
