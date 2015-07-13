//
//  ServiceHelper.h
//  SocialConnection
//
//  Created by Celia on 11/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UsersResult.h"
#import "AdvertisingResult.h"

@interface ServiceHelper : NSObject

@property (nonatomic,strong)UsersResult *sharedUserInfo;
@property (nonatomic,strong)Token *sharedTokenInfo;
@property (nonatomic, strong)Advertising *advertise;

+ (id)sharedServiceHelper;
- (void)retrieveSavedToken;

#pragma mark - User Methods
- (void)authenticateUser:(NSString*)email
            withPassword:(NSString*)password
                 success:(void (^)(id  myResults))success
                 failure:(void (^)(NSError *error))failure;

- (void)createNewUser:(NSDictionary*)newUser
              success:(void (^)(id  myResults))success
              failure:(void (^)(NSError *error))failure;

- (void)forgotPasswordForUser:(NSString *)user
                      success:(void (^)(id  myResults))success
                      failure:(void (^)(NSError *error))failure;

#pragma mark - Area Methods
- (void)allCitiesWithSuccess:(void (^)(id  myResults))success
                     failure:(void (^)(NSError *error))failure;
- (void)venuesForArea:(NSInteger)areaId
             success:(void (^)(id  myResults))success
             failure:(void (^)(NSError *error))failure;

#pragma mark - Reservations Methods
- (void)allReservationsWithSuccess:(void (^)(id  myResults))success
                           failure:(void (^)(NSError *error))failure;
- (void)createNewReservations:(NSDictionary*)reservation
                      success:(void (^)(id  myResults))success
                      failure:(void (^)(NSError *error))failure;
- (void)cancelReservation:(NSInteger)reservationId
                  success:(void (^)(id  myResults))success
                  failure:(void (^)(NSError *error))failure;

#pragma mark - Promotions Methods
- (void)allPromotionsForDay:(NSString*)day
                    success:(void (^)(id  myResults))success
                    failure:(void (^)(NSError *error))failure;

#pragma mark - Banner Methods
- (void)setAdvertiseImageView:(UIImageView*)advertiseImage;
- (void)loadVenueWithId:(NSInteger)venueId
                success:(void (^)(id  myResults))success
                failure:(void (^)(NSError *error))failure;
@end
