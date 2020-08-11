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

/**
 * Manager for mentions plugin which implements delegate protocols as specified by Hakawai requirements
 */
@interface MentionsManager : NSObject <HKWMentionsStateChangeDelegate, HKWMentionsDefaultChooserViewDelegate>

/**
 * @return A shared instance of this class
 */
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
