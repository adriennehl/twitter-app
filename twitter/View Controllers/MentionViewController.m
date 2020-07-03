//
//  MentionViewController.m
//  twitter
//
//  Created by Adrienne Li on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "MentionViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetDetailViewController.h"
#import "Tweet.h"

@interface MentionViewController ()  <UITableViewDelegate, UITableViewDataSource, TweetCellDelegate>
@property (nonatomic, strong) NSMutableArray  *tweets;
@property (weak, nonatomic) IBOutlet UITableView *mentionsTableView;
@end

@implementation MentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mentionsTableView.dataSource = self;
    self.mentionsTableView.delegate = self;
    
    [self fetchTweets];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.mentionsTableView reloadData];
}

- (void)fetchTweets {
    // Get timeline
    [[APIManager shared] getUserMentions:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded mention timeline");
            self.tweets = tweets;
            [self.mentionsTableView reloadData];
        }
        else {
            NSLog(@"😫😫😫 Error getting mention timeline: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)mentionsTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [mentionsTableView dequeueReusableCellWithIdentifier:@"MentionTweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell = [cell reloadTweet:cell tweet:tweet];
    cell.delegate = self;
    
    return cell;
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    // segue to profile view controller
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"profileSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = sender;
    }
    else {
        TweetCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.mentionsTableView indexPathForCell:tappedCell];
       Tweet *tweet = self.tweets[indexPath.row];
        
        TweetDetailViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }
}


@end
