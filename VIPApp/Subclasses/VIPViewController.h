//
//  VIPViewController.h
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPViewController : UIViewController

@property (nonatomic)BOOL isPickerVisible;
@property (nonatomic)BOOL isMainMenu;
@property (nonatomic, strong)UIImageView *bannerView;
@property (nonatomic, strong)UIImageView *backgroundView;

@property (nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, strong)UIDatePicker *datePickerView;
@property (nonatomic, strong)UIView *pickerContainer;

- (void)loadAdvertising;
- (void)initializePickerView;
- (void)initializeDatePickerView;
- (void)presentPickerView;
- (void)dismissPickerView;
- (void)startLoadingView;
- (void)stopLoadingView;

@end
