//
//  ReservationsResult.h
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol Reservation;
@class ResVenue;

@interface ReservationsResult : JSONModel

@property (nonatomic, strong) NSArray <Reservation> *data;

@end

@interface Reservation : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic, strong)NSString *date;
@property (nonatomic)NSInteger status;
@property (nonatomic, strong)ResVenue *venue;

@end

@interface ResVenue : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *logo_url;

@end