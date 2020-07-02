//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

// method to post tweet
- (void)postStatusWithText:(NSString *)text parameter:(NSString *)idStr completion:(void (^)(Tweet *, NSError *))completion;

// method to favorite tweet
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

// method to unfavorite tweet
- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

// method to favorite tweet
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

// method to unfavorite tweet
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

@end
