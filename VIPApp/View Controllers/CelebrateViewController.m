//
//  CelebrateViewController.m
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "CelebrateViewController.h"
#import "PromotionsDayViewController.h"
#import "ServiceHelper.h"

@interface CelebrateViewController ()
{
    BOOL isPickerVisible;
    NSInteger selectedDay;
}

@property (nonatomic, strong)UIView *pickerContainer;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)UITextField *dayTextField;

@end

@implementation CelebrateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"FESTEJATE";
    
    self.bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 77, self.view.frame.size.width, 100)];
    self.bannerView.backgroundColor = [UIColor whiteColor];
    [self loadAdvertising];
    [self.view addSubview:self.bannerView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"festeja"]];
    imageView.frame = CGRectMake(0, 0, 280, 190);
    imageView.center = CGPointMake(self.view.center.x, 240);
    [self.view addSubview:imageView];
    
    _dayTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 250, 36)];
    _dayTextField.center = CGPointMake(self.view.center.x, 330);
    _dayTextField.placeholder = @"ELIGE EL DÍA";
    _dayTextField.delegate = self;
    _dayTextField.textAlignment = NSTextAlignmentCenter;
    _dayTextField.font = [UIFont fontWithName:@"Roboto-Regular" size:19.0];
    _dayTextField.backgroundColor = [UIColor whiteColor];
    _dayTextField.alpha = 0.8;
    _dayTextField.tintColor = [UIColor clearColor];
    _dayTextField.layer.cornerRadius = 5;
    
    [self.view addSubview:_dayTextField];

    self.isMainMenu = YES;
    
    _dataArray = @[@"Lunes", @"Martes", @"Miercoles", @"Jueves", @"Viernes", @"Sabado", @"Domingo"];
    
    [self initializePickerView];
}


#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self presentPickerView];
    return NO;
}

#pragma mark - PickerView methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_dataArray objectAtIndex:row]uppercaseString];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedDay = row;
}

#pragma mark - Action Methods
- (void)donePressed
{
    [self dismissPickerView];
    
    _dayTextField.text = [_dataArray objectAtIndex:selectedDay];
    isPickerVisible = NO;
    
    [self pushAreasViewController];
}

- (void)pushAreasViewController
{
    PromotionsDayViewController *promotionsViewController = [[PromotionsDayViewController alloc]init];
    promotionsViewController.day = [_dataArray objectAtIndex:selectedDay];
    [self.navigationController pushViewController:promotionsViewController animated:YES];
}

#pragma mark - Memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
