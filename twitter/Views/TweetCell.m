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
#import "TimelineViewController.h"
#import "DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // configure tap gesture recognizer
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileView setUserInteractionEnabled:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (TweetCell*) reloadTweet:(TweetCell *)cell tweet:(Tweet *)tweet{
    // set cell properties
    cell.tweet = tweet;
    cell.nameLabel.text = tweet.user.name;
    cell.handleLabel.text = tweet.user.screenName;
    //    cell.dateLabel.text = tweet.createdAtString;
    cell.tweetLabel.text = tweet.text;
    cell.favoriteLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    cell.retweetLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    
    // set date label
    cell.dateLabel.text = tweet.date.shortTimeAgoSinceNow;
    
    // if tweet is favorited, set image and text color
    if (tweet.favorited) {
        [cell.favoriteButton setImage:[UIImage imageNamed: @"favor-icon-red.png"] forState:UIControlStateNormal];
        cell.favoriteLabel.textColor = UIColor.redColor;
    }
    else {
        [cell.favoriteButton setImage:[UIImage imageNamed: @"favor-icon.png"] forState:UIControlStateNormal];
        cell.favoriteLabel.textColor = UIColor.grayColor;
    }
    
    // if tweet is a retweet, set image and text color
    if (tweet.retweeted) {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
        cell.retweetLabel.textColor = UIColor.greenColor;
    }
    else {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
        cell.retweetLabel.textColor = UIColor.grayColor;
    }
    
    // if user has a profile picture, set image
    cell.profileView.image = [UIImage imageNamed:@"camera-icon.png"];
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.width / 2;
    if (tweet.user.profilePic) {
        NSURL *url = [NSURL URLWithString:tweet.user.profilePic];
        [cell.profileView setImageWithURL:url];
    }
    
    // if there is media, add media
    if(tweet.mediaURL) {
        [cell.photoView setImageWithURL:tweet.mediaURL];
    }
    else {
        cell.photoView.image = nil;
        CGRect frameRect = cell.photoView.frame;
        frameRect.size.height = 0;
        [cell.photoView setFrame:frameRect];
    }
    
    cell.verifiedView.alpha = 0;
    // if user is verified, set image
    if ([tweet.user.verified boolValue]) {
        cell.verifiedView.alpha = 1.0;
    }
    return cell;
}

- (void) refreshData {
    [self reloadTweet:self tweet:self.tweet];
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

// when user taps on proile
- (void)didTapUserProfile:(UITapGestureRecognizer *)sender {
   // call method on delegate
    [self.delegate tweetCell:self didTap:self.tweet.user];
}

@end
