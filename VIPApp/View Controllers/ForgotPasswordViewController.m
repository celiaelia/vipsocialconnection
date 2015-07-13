//
//  ForgotPasswordViewController.m
//  VIPApp
//
//  Created by Celia on 12/01/15.
//  Copyright (c) 2015 VIPTeam. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ServiceHelper.h"
#import "VIPButton.h"

@interface ForgotPasswordViewController ()

@property (nonatomic, strong)UITextField *emailTextField;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title= @"OLVIDO CONTRASEÑA";
    
    _emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 250, 36)];
    _emailTextField.center = CGPointMake(self.view.center.x, 120);
    _emailTextField.placeholder = @"Email";
    _emailTextField.textAlignment = NSTextAlignmentCenter;
    _emailTextField.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    _emailTextField.backgroundColor = [UIColor whiteColor];
    _emailTextField.alpha = 0.8;
    _emailTextField.tintColor = [UIColor clearColor];
    _emailTextField.layer.cornerRadius = 5;
    [self.view addSubview:_emailTextField];
    
    VIPButton *bookButton = [[VIPButton alloc]initWithFrame:CGRectMake(0, 0, 250, 35)];
    bookButton.center = CGPointMake(self.view.center.x, 180);
    [bookButton setTitle:@"ENVIAR" forState:UIControlStateNormal];
    bookButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    [bookButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bookButton];
}

- (void)buttonPressed
{
    if(_emailTextField.text.length)
    {
        [self.view endEditing:YES];
        [self startLoadingView];
        
        [[ServiceHelper sharedServiceHelper]forgotPasswordForUser:_emailTextField.text success:^(NSDictionary *myResults) {
            [self stopLoadingView];
            if([myResults valueForKey:@"success"])
            {
                [[[UIAlertView alloc]initWithTitle:@"Un correo ha sido enviado a tu cuenta" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
                [[[UIAlertView alloc]initWithTitle:@"Error" message:@"El correo que ingresaste no esta ligado a ninguna cuenta" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
        } failure:^(NSError *error) {
            [self stopLoadingView];
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"El correo que ingresaste no esta ligado a ninguna cuenta" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
