//
//  TweetDetailViewController.m
//  twitter
//
//  Created by Adrienne Li on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ReplyViewController.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedView;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mediaView;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // set cell properties
    [self refreshData];
    
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)refreshData {
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = self.tweet.user.screenName;
    self.dateCreatedLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.
                              tweet.retweetCount];
    
    // if tweet is favorited, set image and text color
    if (self.tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed: @"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed: @"favor-icon.png"] forState:UIControlStateNormal];
    }
    
    // if tweet is a retweet, set image and text color
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    
    // if user has a profile picture, set image
    self.profileView.image = [UIImage imageNamed:@"camera-icon.png"];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
    if (self.tweet.user.propic) {
        NSURL *url = [NSURL URLWithString:self.tweet.user.propic];
        [self.profileView setImageWithURL:url];
    }
    
    // if there is media, add media
    if(self.tweet.mediaURL) {
        [self.mediaView setImageWithURL:self.tweet.mediaURL];
    }
    else {
        self.mediaView.image = nil;
        CGRect frameRect = self.mediaView.frame;
        frameRect.size.height = 0;
        [self.mediaView setFrame:frameRect];
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


- (IBAction)didTapReply:(id)sender {
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ReplyViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.tweet = self.tweet;
}

@end
