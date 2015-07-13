//
//  CitiesResult.h
//  SocialConnection
//
//  Created by Celia on 11/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol City;
@protocol Area;

@interface CitiesResult : JSONModel

@property (nonatomic, strong) NSArray <City> *data;

@end

@interface City : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSArray <Area> *areas;

@end

@interface Area : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic, strong)NSString *name;

@end