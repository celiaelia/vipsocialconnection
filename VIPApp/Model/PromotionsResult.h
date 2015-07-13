//
//  PromotionsResult.h
//  VIPApp
//
//  Created by Celia on 28/12/13.
//  Copyright (c) 2014 VIPTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "VenuesResult.h"
@protocol Promotion;
@protocol DayPromotion;
@protocol Schedule;
@class DayVenue;

@interface PromotionsResult : JSONModel

@property (nonatomic, strong)NSArray <Promotion> *data;

@end

@interface PromotionsDayResult : JSONModel

@property (nonatomic, strong)NSArray <DayPromotion> *data;

@end

@interface Promotion : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic)NSInteger venue_id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *image_url;
@property (nonatomic, strong)NSString *description;
@property (nonatomic)NSInteger birthday_special;
@property (nonatomic, strong)NSArray <Schedule> *schedules;

@end

@interface DayPromotion : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic)NSInteger venue_id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *image_url;
@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)NSArray <Schedule> *schedules;
@property (nonatomic, strong)DayVenue *venue;

@end

@interface Schedule : JSONModel

@property (nonatomic, strong)NSString *day;

@end
