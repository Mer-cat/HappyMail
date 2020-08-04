//
//  Constants.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/17/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// Must update this array if FilterOption is updated
#define FILTER_ARRAY (@[@"Offers", @"Requests", @"Thank Yous", @"Within last week", @"Within last day"])

typedef NS_ENUM(NSInteger, PostType) {
    Offer,
    Request,
    ThankYou
};

typedef NS_ENUM(NSInteger, FilterOption) {
    AllOffers,
    AllRequests,
    AllThankYous,
    LastWeek,
    LastDay,
    None
};

#endif /* Constants_h */
