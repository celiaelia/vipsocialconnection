//
//  AdvertisingResult.h
//  VIPApp
//
//  Created by Celia on 21/12/13.
//  Copyright (c) 2014 VIPTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "VenuesResult.h"
@class AdverPromotion;
@protocol AdvertisingNoProm;
@protocol Advertising;
@protocol DayVenue;

@interface AdvertisingResult : JSONModel

@property (nonatomic, strong) NSArray <Advertising> *data;

@end

@interface AdvertisingResultNoProm : JSONModel

@property (nonatomic, strong) NSArray <AdvertisingNoProm> *data;

@end

@interface Advertising : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic, strong)NSString *image_url;
@property (nonatomic, strong)AdverPromotion *promotion;

@end

@interface AdvertisingNoProm : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *image_url;
@property (nonatomic, strong)NSString *full_image_url;

@end

@interface AdverPromotion : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic)NSInteger venue_id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *image_url;
@property (nonatomic, strong)NSString *description;

@end

@interface AdverVenuesResult : JSONModel

@property (nonatomic, strong) NSArray <DayVenue> *data;

@end
