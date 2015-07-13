//
//  SignUpViewController.m
//  SocialConnection
//
//  Created by Celia on 11/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "SignUpViewController.h"
#import "MMDrawerController.h"
#import "MenuTableViewController.h"
#import "WelcomeViewController.h"
#import "ServiceHelper.h"
#import "UsersResult.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"REGISTRO";
}

#pragma mark - IBAction Methods
- (IBAction)signUpButtonPressed:(id)sender
{
    NSString *errorMessage;
    if(!_nameTextField.text.length)
        errorMessage = @"Ingrese un nombre";
    else if(!_userTextField.text.length)
        errorMessage = @"Ingrese un usuario";
    else if(!_emailTextField.text.length)
        errorMessage = @"Ingrese un correo electrónico";
    else if(!_passwordTextField.text.length)
        errorMessage = @"Ingrese una contraseña";
    else if(_passwordTextField.text.length < 8)
        errorMessage = @"La contraseña debe ser de al menos 8 caracteres";
    else if(![_passwordTextField.text isEqualToString:_confirmTextField.text])
        errorMessage = @"Las contraseñas no coinciden";
    
    if(errorMessage)
        [[[UIAlertView alloc]initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    else
    {
        NSDictionary *newUser = @{@"name": _nameTextField.text,
                                  @"email": _emailTextField.text,
                                  @"username": _userTextField.text,
                                  @"password": _passwordTextField.text,
                                  @"password_confirmation": _confirmTextField.text};
        
        [self startLoadingView];
        
        [[ServiceHelper sharedServiceHelper]createNewUser:newUser success:^(id myResults)
        {
            NSError *error;
            UsersResult *user = [[UsersResult alloc]initWithDictionary:myResults error:&error];
            
            if(user.id)
                [[ServiceHelper sharedServiceHelper]setSharedUserInfo:user];
            else
            {
                [self stopLoadingView];
                [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Intenta con otro nombre de usuario/email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                return;
            }
         
            [[ServiceHelper sharedServiceHelper]authenticateUser:_userTextField.text withPassword:_passwordTextField.text success:^(id myResults)
            {
                [self stopLoadingView];
                [self userLoggedSuccesfully];
            } failure:^(NSError *error) {}];
            
        } failure:^(NSError *error) {
            [self stopLoadingView];
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Intenta con otro nombre de usuario" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];

        }];
    }
}

- (void)userLoggedSuccesfully
{
    MenuTableViewController *menuController = [[MenuTableViewController alloc]init];
    WelcomeViewController *welcomeController = [[WelcomeViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:welcomeController];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:nav
                                            leftDrawerViewController:menuController
                                            rightDrawerViewController:nil];
    
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self presentViewController:drawerController animated:NO completion:nil];
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.frame.size.height + 100);
    
    CGPoint offset = CGPointMake(0, textField.center.y - 25);
    [UIView animateWithDuration:0.4 animations:^{
        _scrollView.contentOffset = offset;
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType == UIReturnKeyNext)
    {
        UITextField *nextTextField = (UITextField*)[self.view viewWithTag:textField.tag + 1];
        [nextTextField becomeFirstResponder];
    }
    else
        [self hideKeyboard];
    
    return YES;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.4 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

#pragma mark - Memory managment
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
