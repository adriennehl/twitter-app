//
//  ComposeViewController.m
//  twitter
//
//  Created by Adrienne Li on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTextView.delegate = self;
    // Do any additional setup after loading the view.

}
- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)onTweet:(id)sender {
    [[APIManager shared]postStatusWithText:self.tweetTextView.text parameter:@"" completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self onClose:nil];
        }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.tweetTextView.text isEqualToString:@"What's happening?"]){
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
    self.tweetTextView.canCancelContentTouches = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.tweetTextView.text isEqualToString:@""]){
        textView.text = @"What's happening?";
        textView.textColor = UIColor.lightGrayColor;
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
