//
//  User.m
//  twitter
//
//  Created by Adrienne Li on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

// implement initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.userID = dictionary[@"id_str"];
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePic = [dictionary[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        self.backdropPic = dictionary[@"profile_banner_url"];
        self.friendsCount = [NSString stringWithFormat:@"%@",  dictionary[@"friends_count"]];
        self.followersCount = [NSString stringWithFormat:@"%@", dictionary[@"followers_count"]];
        self.verified = dictionary[@"verified"];
        
    }
    return self;
}
@end
