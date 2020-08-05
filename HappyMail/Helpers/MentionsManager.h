//
//  HKWMentionsDelegateHelper.h
//  HappyMail
//
//  Created by Mercy Bickell on 8/4/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKWMentionsPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface MentionsManager : NSObject <HKWMentionsStateChangeDelegate, HKWMentionsDefaultChooserViewDelegate>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
