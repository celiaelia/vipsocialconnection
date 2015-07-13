//
//  ReservationFormViewController.h
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenuesResult.h"
#import "VIPViewController.h"

@interface ReservationFormViewController : VIPViewController<UITextFieldDelegate>

@property (nonatomic, strong)Venue *venue;
@property (nonatomic, strong)Promotion *promotion;

@end
