//
//  AreasViewController.h
//  SocialConnection
//
//  Created by Celia on 11/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesResult.h"
#import "VIPViewController.h"

@interface AreasViewController : VIPViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)Area *area;

@end
