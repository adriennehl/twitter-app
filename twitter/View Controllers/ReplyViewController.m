//
//  ReplyViewController.m
//  twitter
//
//  Created by Adrienne Li on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ReplyViewController.h"
#import "APIManager.h"

@interface ReplyViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *replyTextView;
@property (weak, nonatomic) IBOutlet UILabel *replyToLabel;

@end

@implementation ReplyViewController

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)onTweet:(id)sender {
    NSString *reply = [NSString stringWithFormat:@"@%@ ",self.tweet.user.screenName];
    reply = [reply stringByAppendingString:self.replyTextView.text];
    [[APIManager shared] postStatusWithText:reply parameter:(NSString *)self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error replying to Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Reply Success!");
            [self onBack:nil];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.replyToLabel.text = self.tweet.user.screenName;
    self.replyTextView.delegate = self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.replyTextView.text isEqualToString:@"Tweet your reply"]){
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
