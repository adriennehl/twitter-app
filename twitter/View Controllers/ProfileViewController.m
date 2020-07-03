//
//  ProfileViewController.m
//  twitter
//
//  Created by Adrienne Li on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "TweetDetailViewController.h"
#import "Tweet.h"
#import "User.h"

@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.profileTableView.dataSource = self;
    self.profileTableView.delegate = self;
    
    // if user is nil, get user data
    if(!self.user) {
        [self getUser];
    }
    else {
        [self loadUserData];
        [self fetchTweets];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.profileTableView reloadData];
}

- (void)getUser{
    [[APIManager shared] getUserWithCompletion:^(NSDictionary *userDictionary, NSError *error) {
        if (userDictionary) {
            NSLog(@"😎😎😎 Successfully loaded user");
            self.user = [[User alloc] initWithDictionary:userDictionary];
            [self loadUserData];
            // load user tweets
            [self fetchTweets];
        }
        else {
            NSLog(@"😫😫😫 Error getting user: %@", error.localizedDescription);
        }
    }];
}

- (void)fetchTweets {
    // Get timeline
    NSString *user_id = self.user.userID;
    [[APIManager shared] getUserStatuses:user_id completion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded statuses");
            self.tweets = [NSMutableArray arrayWithArray:tweets];
            [self.profileTableView reloadData];
        }
        else {
            NSLog(@"😫😫😫 Error loading statuses: %@", error.localizedDescription);
        }
    }];
}

- (void) loadUserData {
    self.nameLabel.text = self.user.name;
    self.handleLabel.text = self.user.screenName;
    self.followingLabel.text = self.user.friendsCount;
    self.followersLabel.text = self.user.followersCount;
    
    // if user has a profile picture, set image
    self.profileView.image = [UIImage imageNamed:@"camera-icon.png"];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
    if (self.user.profilePic) {
        NSURL *url = [NSURL URLWithString:self.user.profilePic];
        [self.profileView setImageWithURL:url];
    }
    
    // if user has a banner picture, set image
    self.backdropView.image = [UIImage imageNamed:@"camera-icon.png"];
    if (self.user.backdropPic) {
        NSURL *url = [NSURL URLWithString:self.user.backdropPic];
        [self.backdropView setImageWithURL:url];
    }
}

- (NSInteger)tableView:(UITableView *)profileTableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)profileTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [profileTableView dequeueReusableCellWithIdentifier:@"ProfileTweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell = [cell reloadTweet:cell tweet:tweet];
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TweetCell *tappedCell = sender;
     NSIndexPath *indexPath = [self.profileTableView indexPathForCell:tappedCell];
    Tweet *tweet = self.tweets[indexPath.row];
     
     TweetDetailViewController *detailsViewController = [segue destinationViewController];
     detailsViewController.tweet = tweet;
}


@end
