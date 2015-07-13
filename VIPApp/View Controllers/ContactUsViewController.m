//
//  ContactUsViewController.m
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"CONTACTANOS";
    self.isMainMenu = YES;
    self.backgroundView.image = [UIImage imageNamed:@"Crown_Bckgd"];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
    phoneLabel.text = @"MANDA TUS DUDAS Y\nCOMENTARIOS A:";
    phoneLabel.numberOfLines = 2;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.center = CGPointMake(self.view.center.x, 290);
    phoneLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:phoneLabel];
    
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
    emailLabel.text = @"reservacionesvipsc@gmail.com";
    emailLabel.textAlignment = NSTextAlignmentCenter;
    emailLabel.center = CGPointMake(self.view.center.x, 350);
    emailLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:emailLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
