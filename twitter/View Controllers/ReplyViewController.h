//
//  ReplyViewController.h
//  twitter
//
//  Created by Adrienne Li on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ReplyViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ReplyViewController : UIViewController
@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) id<ReplyViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
