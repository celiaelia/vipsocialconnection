//
//  ProfileViewController.m
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "ProfileViewController.h"
#import "ServiceHelper.h"
#import "UsersResult.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"MI PERFIL";
    self.backgroundView.image = [UIImage imageNamed:@"Crown_Bckgd"];
    self.isMainMenu = YES;
    
    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 70)];
    usernameLabel.text = [NSString stringWithFormat:@"USUARIO:\n%@", [[[ServiceHelper sharedServiceHelper] sharedUserInfo] username]];
    usernameLabel.numberOfLines = 2;
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    usernameLabel.center = CGPointMake(self.view.center.x, 320);
    usernameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0];
    usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:usernameLabel];
    
   /* UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
    emailLabel.text = [NSString stringWithFormat:@"Email: %@", [[[ServiceHelper sharedServiceHelper] sharedUserInfo] email]];
    emailLabel.textAlignment = NSTextAlignmentCenter;
    emailLabel.center = CGPointMake(self.view.center.x, 350);
    emailLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:emailLabel];*/

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
