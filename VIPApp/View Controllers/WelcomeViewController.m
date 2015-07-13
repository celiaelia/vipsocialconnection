//
//  WelcomeViewController.m
//  SocialConnection
//
//  Created by Celia on 10/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AreasViewController.h"
#import "ServiceHelper.h"
#import "CitiesResult.h"

enum textField{
    CityText,
    AreaText
};

@interface WelcomeViewController ()
{
    NSInteger selectedTextField, selectedArea, selectedCity;
}

@property (nonatomic, strong)UITextField *cityTextField;
@property (nonatomic, strong)UITextField *areaTextField;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)City *selectedCity;

@end

@implementation WelcomeViewController
@synthesize selectedCity = _selectedCity;

- (void)viewDidLoad {
    [super viewDidLoad];

    //NSString *username = [[[ServiceHelper sharedServiceHelper]sharedUserInfo]username];
    self.navigationItem.title = @"BIENVENIDO";
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"welcome"]];
    imageView.frame = CGRectMake(0, 0, 200, 220);
    imageView.center = CGPointMake(self.view.center.x, 200);
    [self.view addSubview:imageView];
    
    _cityTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 220, 36)];
    _cityTextField.center = CGPointMake(self.view.center.x, 270);
    _cityTextField.placeholder = @"ELIGE TU CIUDAD";
    _cityTextField.textAlignment = NSTextAlignmentCenter;
    _cityTextField.backgroundColor = [UIColor whiteColor];
    _cityTextField.alpha = 0.8;
    _cityTextField.tag = CityText;
    _cityTextField.delegate = self;
    _cityTextField.tintColor = [UIColor clearColor];
    _cityTextField.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    
    [self.view addSubview:_cityTextField];
    
    _areaTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 220, 36)];
    _areaTextField.center = CGPointMake(self.view.center.x, 307);
    _areaTextField.placeholder = @"ELIGE TU ZONA";
    _areaTextField.alpha = 0.8;
    _areaTextField.backgroundColor = [UIColor whiteColor];
    _areaTextField.textAlignment = NSTextAlignmentCenter;
    _areaTextField.tag = AreaText;
    _areaTextField.delegate = self;
    _areaTextField.tintColor = [UIColor clearColor];
    _areaTextField.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    
    [self.view addSubview:_areaTextField];
    
    [self roundCornersForView:_cityTextField corners:UIRectCornerTopLeft| UIRectCornerTopRight];
    [self roundCornersForView:_areaTextField corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    
    self.isMainMenu = YES;

    [self fetchData];
    
    self.bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
    self.bannerView.backgroundColor = [UIColor whiteColor];
    [self loadAdvertising];
    [self.view addSubview:self.bannerView];
}

- (void)fetchData
{
    [self startLoadingView];
    
    [[ServiceHelper sharedServiceHelper]allCitiesWithSuccess:^(id result) {
        [self stopLoadingView];
        
        NSError *error;
        CitiesResult *cities = [[CitiesResult alloc]initWithDictionary:result error:&error];
        _dataArray = cities.data;
        [self createPickerWithFetchedData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)createPickerWithFetchedData
{
    selectedTextField = CityText;
    [self initializePickerView];
}

- (void)roundCornersForView:(UIView*)view corners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag != selectedTextField)
    {
        selectedTextField = textField.tag;
        [self.pickerView reloadAllComponents];
    }
    selectedTextField = textField.tag;
    
    if(!self.isPickerVisible && selectedTextField == CityText)
            selectedCity = [self.pickerView selectedRowInComponent:0];
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
    if(selectedTextField == CityText)
        return _dataArray.count;
    else if(_selectedCity)
        return  _selectedCity.areas.count;
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(selectedTextField == CityText)
        return [[_dataArray objectAtIndex:row]name];
    else if(_selectedCity)
        return [[_selectedCity.areas objectAtIndex:row]name];
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(selectedTextField == CityText)
        selectedCity = row;
    else
        selectedArea = row;
}

#pragma mark - Action Methods
- (void)donePressed
{
    [self dismissPickerView];
    
    if(selectedTextField == CityText)
    {
        _selectedCity = [_dataArray objectAtIndex:selectedCity];
        
        if(![_cityTextField.text isEqualToString:_selectedCity.name])
        {
            selectedArea = 0;
            _areaTextField.text = @"";
        }
        _cityTextField.text = _selectedCity.name;
    }
    else if(_selectedCity && _selectedCity.areas)
        _areaTextField.text = [[_selectedCity.areas objectAtIndex:selectedArea]name];
    
    if(_cityTextField.text.length && _areaTextField.text.length)
    {
        [self pushAreasViewController];
    }
}

- (void)pushAreasViewController
{
    [[NSUserDefaults standardUserDefaults]setValue:@(_selectedCity.id) forKey:@"selectedCity"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    AreasViewController *areasViewController = [[AreasViewController alloc]init];
    areasViewController.area = [_selectedCity.areas objectAtIndex:selectedArea];
    [self.navigationController pushViewController:areasViewController animated:YES];
}

#pragma mark - Memory managment
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
