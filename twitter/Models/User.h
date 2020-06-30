//
//  User.h
//  twitter
//
//  Created by Adrienne Li on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *propic;
@property (nonatomic) NSNumber *verified;

// create initialize
- (instancetype) initWithDictionary: (NSDictionary*)dictionary;
@end

NS_ASSUME_NONNULL_END
