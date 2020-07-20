//
//  Constants.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/17/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

typedef NS_ENUM(NSInteger, PostType) {
    Offer,
    Request
};

typedef NS_ENUM(NSInteger, FilterOption) {
    AllOffers,
    AllRequests,
    LastWeek,
    LastDay,
    None
};

#endif /* Constants_h */
