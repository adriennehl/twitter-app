//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";


@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

// load tweets on timeline
- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    // Create a GET Request
    [self GET:@"1.1/statuses/home_timeline.json?tweet_mode=extended"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        
        // Success, create an array of tweets
        NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // there was a problem
        completion(nil, error);
    }];
}

// post a new tweet
- (void)postStatusWithText:(NSString *)text parameter:(NSString *)idStr completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json?tweet_mode=extended";
    NSDictionary *parameters = @{@"status": text};
    if(![idStr isEqual:@""]){
        parameters = @{@"status": text,  @"in_reply_to_status_id":idStr
        };
    }
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)getUserWithCompletion:(void(^)(NSDictionary *user, NSError *error))completion {
    
    // Create a GET Request
    [self GET:@"1.1/account/verify_credentials.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable userDictionary) {
        
        // Success, get user info
        completion(userDictionary, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // there was a problem
        completion(nil, error);
    }];
}

- (void)getUserStatuses:(NSString *) user_id completion: (void(^)(NSMutableArray *tweets, NSError *error))completion {
    // Create a GET Request
    NSString *requestString = [NSString stringWithFormat:@"1.1/statuses/user_timeline.json?user_id=%@&tweet_mode=extended",user_id];
    [self GET:requestString
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        // Success, create an array of tweets
        NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
        
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // there was a problem
        completion(nil, error);
    }];
}

- (void) sendRequest:(Tweet *)tweet string:(NSString *)urlString completion:(void (^)(Tweet *, NSError *))completion{
    NSDictionary *parameters = @{@"id":tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

// favorite a tweet
- (void) favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/favorites/create.json?tweet_mode=extended";
    [self sendRequest:tweet string:urlString completion:completion];
}

// unfavorite a tweet
- (void) unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/favorites/destroy.json?tweet_mode=extended";
    [self sendRequest:tweet string:urlString completion:completion];
}

// retweet a tweet
- (void) retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json?tweet_mode=extended",tweet.idStr];
    [self sendRequest:tweet string:urlString completion:completion];
}

// unretweet a tweet
- (void) unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json?tweet_mode=extended",tweet.idStr];
    [self sendRequest:tweet string:urlString completion:completion];
}
@end
