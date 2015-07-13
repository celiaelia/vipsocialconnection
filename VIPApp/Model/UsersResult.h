//
//  UsersResult.h
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol Error;

@interface UsersResult : JSONModel

@property (nonatomic)NSInteger id;
@property (nonatomic, strong)NSString *username;
//@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *email;

@end

@interface Token : JSONModel

@property (nonatomic, strong)NSString *access_token;
@property (nonatomic, strong)NSString *refresh_token;
@property (nonatomic)NSInteger expires_in;

@end