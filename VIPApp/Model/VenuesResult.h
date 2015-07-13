//
//  VenuesResult.h
//  SocialConnection
//
//  Created by Celia on 11/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromotionsResult.h"
#import "JSONModel.h"
@protocol Venue, Promotion, Photo;
@class AddressCity, State, Address;

@interface VenuesResult : JSONModel

@property (nonatomic, strong) NSArray <Venue> *data;

@end

@interface Venue : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic, strong)NSString *logo_url;
@property (nonatomic, strong)NSString *image_url;
@property (nonatomic, strong)NSString *banner_url;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)Address *address;
@property (nonatomic, strong)NSArray <Promotion> *promotions;
@property (nonatomic, strong)NSArray <Photo> *photos;

@end

@interface DayVenue : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic, strong)NSString *logo_url;
@property (nonatomic, strong)NSString *image_url;
@property (nonatomic, strong)NSString *name;

@end

@interface Address : JSONModel

@property (nonatomic, strong)NSString *street;
@property (nonatomic, strong)NSString *number;
@property (nonatomic)NSString *zip_code;
@property (nonatomic)NSNumber *latitude;
@property (nonatomic)NSNumber *longitude;
@property (nonatomic)AddressCity *city;
@property (nonatomic)State *state;

@end

@interface AddressCity : JSONModel

@property (nonatomic, strong)NSString *name;

@end

@interface State : JSONModel

@property (nonatomic, strong)NSString *name;

@end

@interface Photo : JSONModel

@property (nonatomic, strong)NSString *image_url;

@end
