//
//  ComposeViewController.h
//  twitter
//
//  Created by Adrienne Li on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController :  UIViewController
@property (weak, nonatomic) id<ComposeViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
