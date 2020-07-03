//
//  ProfileViewController.h
//  twitter
//
//  Created by Adrienne Li on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (nonatomic, strong) User *user;
@end

NS_ASSUME_NONNULL_END
