//
//  TweetCell.m
//  twitter
//
//  Created by Adrienne Li on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void) refreshData {
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = self.tweet.user.screenName;
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    // if tweet is favorited, set image and text color
    if (self.tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed: @"favor-icon-red.png"] forState:UIControlStateNormal];
        self.favoriteLabel.textColor = UIColor.redColor;
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed: @"favor-icon.png"] forState:UIControlStateNormal];
        self.favoriteLabel.textColor = UIColor.grayColor;
    }
    
    // if tweet is a retweet, set image and text color
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
        self.retweetLabel.textColor = UIColor.greenColor;
    }
    else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
        self.retweetLabel.textColor = UIColor.grayColor;
    }
    
    // if user has a profile picture, set image
    self.imageView.image = [UIImage imageNamed:@"camera-icon.png"];
    if (self.tweet.user.propic) {
        NSURL *url = [NSURL URLWithString:self.tweet.user.propic];
        [self.profileView setImageWithURL:url];
    }
    
    self.verifiedView.alpha = 0;
    // if user is verified, set image
    if ([self.tweet.user.verified boolValue]) {
        self.verifiedView.alpha = 1.0;
    }
}

- (IBAction)didTapFavorite:(id)sender {
    // if tweet is not favorited, favorite tweet
    if (!self.tweet.favorited) {
        // update tweet local model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        // update cell UI
        [self refreshData];
        //send a post request to the post favorites
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error){
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet : %@", tweet.text);
            }
        }];
    }
    
    // otherwise, favorite tweet
    else {
        // update tweet local model
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        // update cell UI
        [self refreshData];
        //send a post request to the post favorites
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error){
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet : %@", tweet.text);
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    // if tweet is not retweeted, retweet tweet
    if (!self.tweet.retweeted) {
        // update tweet local model
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        // update cell UI
        [self refreshData];
        //send a post request to the post retweets
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error){
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet : %@", tweet.text);
            }
        }];
    }
    
    // otherwise, unretweet tweet
    else {
        // update tweet local model
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        // update cell UI
        [self refreshData];
        //send a post request to the post favorites
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error){
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet : %@", tweet.text);
            }
        }];
    }
}

@end
