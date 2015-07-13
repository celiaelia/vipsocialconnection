//
//  ServiceHelper.m
//  SocialConnection
//
//  Created by Celia on 11/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "ServiceHelper.h"
#import "AFNetworking.h"
#import "CitiesResult.h"

#define baseURL @"http://api.viprsv.com/api/v1/"

static ServiceHelper *sharedInstance;
NSString *const ClientId = @"R3A59PxbyscDiu7Q2fatEGdMZn68SHWYrmgvhkUe";
NSString *const ClientSecret = @"fCd2a4vhXuQmxpeDYsW76wcArkyPjUN8qE95TzBH";

@interface ServiceHelper()

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)UIImageView *advertiseImage;
@property (strong, nonatomic) AFHTTPRequestOperationManager *httpManager;

@end

@implementation ServiceHelper

+ (id)sharedServiceHelper
{
    if(!sharedInstance)
        sharedInstance = [[ServiceHelper alloc]init];

    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        _httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self loadAdvertiseImage];
    }
    return self;
}

- (void)retrieveSavedToken
{
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@", _sharedTokenInfo.access_token];
    [_httpManager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
}

#pragma mark - User Methods
- (void)authenticateUser:(NSString*)email
            withPassword:(NSString*)password
                 success:(void (^)(id  myResults))success
                 failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *httpManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:baseURL]];
    
    NSString *contentType = @"application/x-www-form-urlencoded";
    NSString *fullPath = [NSString stringWithFormat:@"http://api.viprsv.com/oauth/access_token"];
    
    NSDictionary *parameters = @{@"username":email,
                                 @"password":password,
                                 @"grant_type":@"password",
                                 @"client_id":ClientId,
                                 @"client_secret":ClientSecret};
    
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [httpManager.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [httpManager POST:fullPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveToken:responseObject withUser:email];
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];
}

- (void)createNewUser:(NSDictionary*)newUser
              success:(void (^)(id  myResults))success
              failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@users", baseURL];

    [_httpManager POST:fullPath parameters:newUser success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];
}

- (void)saveToken:(id)response withUser:(NSString*)user
{
    NSError *error;
    Token *token = [[Token alloc]initWithDictionary:response error:&error];
    _sharedTokenInfo = token;
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSDate date] forKey:@"expirationTime"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if(!_sharedUserInfo)
    {
        _sharedUserInfo = [[UsersResult alloc]init];
        _sharedUserInfo.username = user;
        _sharedUserInfo.email = user;
    }
    
    NSData *encodedToken = [NSKeyedArchiver archivedDataWithRootObject:_sharedTokenInfo];
    NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:_sharedUserInfo];
    [[NSUserDefaults standardUserDefaults]setValue:encodedToken forKey:@"sharedToken"];
    [[NSUserDefaults standardUserDefaults]setValue:encodedUser forKey:@"sharedUser"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@", token.access_token];
    [_httpManager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
}

- (void)refreshToken
{
    
}

- (void)forgotPasswordForUser:(NSString *)user
                      success:(void (^)(id  myResults))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@forgot-password", baseURL];
    
    [_httpManager POST:fullPath parameters:@{@"email":user} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];
}

#pragma mark - Area Methods
- (void)allCitiesWithSuccess:(void (^)(id  myResults))success
    failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@cities?with=areas&has=areas", baseURL];
    
    [_httpManager GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];
}

- (void)venuesForArea:(NSInteger)cityId
             success:(void (^)(id  myResults))success
             failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@venues?q=address.area_id,=,%li&with=promotions,address,photos,address.city,address.state,promotions.schedules", baseURL, (long)cityId];
    [_httpManager GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];}

#pragma mark - Reservations Methods
- (void)allReservationsWithSuccess:(void (^)(id  myResults))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@reservations?with=venue", baseURL];
    [_httpManager GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];
}

- (void)createNewReservations:(NSDictionary*)reservation
                      success:(void (^)(id  myResults))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@reservations", baseURL];
    [_httpManager POST:fullPath parameters:reservation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];
}

- (void)cancelReservation:(NSInteger)reservationId
                  success:(void (^)(id  myResults))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@reservations/%li", baseURL, (long)reservationId];
    [_httpManager DELETE:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(success);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];
}

#pragma mark - Promotions Methods
- (void)allPromotionsForDay:(NSString*)day
                    success:(void (^)(id  myResults))success
                    failure:(void (^)(NSError *error))failure
{
    NSInteger cityId = [[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCity"]integerValue];
    NSString *fullPath = [NSString stringWithFormat:@"%@promotions?q=birthday_special,=,1;venue.address.city_id,=,%li;schedules.day,=,%@&with=schedules,venue", baseURL, (long)cityId, day];
    [_httpManager GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];
}

#pragma mark - Banner Methods
- (void)loadAdvertiseImage
{
    NSString *fullPath = [NSString stringWithFormat:@"%@advertisings?with=promotion", baseURL];
    
    [_httpManager GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSArray *promotions = [data valueForKey:@"promotion"];
        AdvertisingResult *result;
        if(![promotions.firstObject isEqual:[NSNull null]])
        {
            result = [[AdvertisingResult alloc] initWithDictionary:responseObject error:&error];
        }
        else
        {
            AdvertisingResultNoProm *noProm = [[AdvertisingResultNoProm alloc]initWithDictionary:responseObject error:&error];
            result = (AdvertisingResult*)noProm;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[result.data.firstObject image_url]]];
            UIImage *image = [UIImage imageWithData:data];
            _advertise = result.data.firstObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                _image = image;
                _advertiseImage.image = image;
                
                [self performSelector:@selector(loadAdvertiseImage) withObject:nil afterDelay:4];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}

- (void)loadVenueWithId:(NSInteger)venueId
                success:(void (^)(id  myResults))success
                failure:(void (^)(NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@venues?q=id,=,%li", baseURL, (long)venueId];
    [_httpManager GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(failure);
    }];
}

- (void)setAdvertiseImageView:(UIImageView *)advertiseImage
{
    advertiseImage.image = _image;
    self.advertiseImage = advertiseImage;
}

@end
