//
//  LoginViewController.m
//  SocialConnection
//
//  Created by Celia on 10/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "LoginViewController.h"
#import "MMDrawerController.h"
#import "MenuTableViewController.h"
#import "ForgotPasswordViewController.h"
#import "WelcomeViewController.h"
#import "SignUpViewController.h"
#import "ServiceHelper.h"
#import "VIPButton.h"

@interface LoginViewController ()
{
    BOOL isKeyboardShowing;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet VIPButton *login;
@property (weak, nonatomic) IBOutlet VIPButton *loginFacebook;
@property (nonatomic, strong)FBLoginView *loginView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundView.image = [UIImage imageNamed:@"Crown_Bckgd"];
    
    UIImageView *userImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user"]];
    userImage.frame = CGRectMake(_usernameTextField.frame.origin.x + 5, _usernameTextField.frame.origin.y + 7, 22, 23);
    [self.view addSubview:userImage];
    
    UIImageView *lockImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lock"]];
    lockImage.frame = CGRectMake(_passwordTextField.frame.origin.x + 6, _passwordTextField.frame.origin.y + 9, 22, 23);
    [self.view addSubview:lockImage];
    
    [self roundCornersForView:_usernameTextField corners:UIRectCornerTopLeft| UIRectCornerTopRight];
    [self roundCornersForView:_passwordTextField corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    [self roundCornersForView:_login corners:UIRectCornerTopLeft| UIRectCornerTopRight];
    [self roundCornersForView:_loginFacebook corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    
    UIImageView *buttonsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _login.frame.origin.y, 210, 68)];
    buttonsView.center = CGPointMake(self.view.center.x, buttonsView.center.y);
    buttonsView.image = [UIImage imageNamed:@"loginButtons"];
    buttonsView.userInteractionEnabled = YES;
    [self.view insertSubview:buttonsView belowSubview:_login];
    
    _loginView = [[FBLoginView alloc] init];
    _loginView.center = CGPointMake(self.view.center.x, self.view.frame.size.height + 100);
    _loginView.readPermissions = @[@"email"];
    [self.view addSubview:_loginView];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    
    [self startLoadingView];

    NSString *email = [(NSDictionary*)user valueForKey:@"email"];
    NSString *password = [(NSDictionary*)user valueForKey:@"id"];
    [[ServiceHelper sharedServiceHelper] authenticateUser:email withPassword:password success:^(id myResults) {
        [self stopLoadingView];
        [self userLoggedSuccesfully];
    } failure:^(NSError *error) {
        [self createNewAccountWithInfo:(NSDictionary*)user];
    }];
}

- (void)createNewAccountWithInfo:(NSDictionary*)user
{
    NSDictionary *newUser = @{@"name": [user valueForKey:@"name"],
                              @"email": [user valueForKey:@"email"],
                              @"username": [user valueForKey:@"email"],
                              @"password": [user valueForKey:@"id"],
                              @"password_confirmation": [user valueForKey:@"id"]
                              };
    
    NSString *password = [user valueForKey:@"id"];
    
    [[ServiceHelper sharedServiceHelper]createNewUser:newUser success:^(id myResults)
     {
         NSError *error;
         UsersResult *user = [[UsersResult alloc]initWithDictionary:myResults error:&error];
         
         if(user.id)
             [[ServiceHelper sharedServiceHelper]setSharedUserInfo:user];
         else
         {
             [self stopLoadingView];
             [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Tu email ya ha sido usado para crear una cuenta" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
             return;
         }
         NSString *email = [user valueForKey:@"email"];
         
         [[ServiceHelper sharedServiceHelper]authenticateUser:email withPassword:password success:^(id myResults)
          {
              [self stopLoadingView];
              [self userLoggedSuccesfully];
          } failure:^(NSError *error) {
          
          }];
         
     } failure:^(NSError *error) {
         [self stopLoadingView];
         [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Intenta creando un usuario nuevo" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
         
     }];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self hideKeyboard];
}

#pragma mark - Button Action Methods
- (IBAction)startSessionPressed:(id)sender {
    [self hideKeyboard];
    [self startLoadingView];
    
    [[ServiceHelper sharedServiceHelper]authenticateUser:_usernameTextField.text
                                            withPassword:_passwordTextField.text
                                                 success:^(id myResults)
    {
        [self stopLoadingView];
        [self userLoggedSuccesfully];
    } failure:^(NSError *error) {
        [self stopLoadingView];
        [[[UIAlertView alloc]initWithTitle:@"Credenciales incorrectas" message:@"Intenta de nuevo" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
    }];
}

- (IBAction)facebookSignUpPressed:(id)sender {
    _loginView.delegate = self;
    for(id object in self.loginView.subviews){
        if([[object class] isSubclassOfClass:[UIButton class]]){
            UIButton* button = (UIButton*)object;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (IBAction)forgotPasswordPressed:(id)sender {
    [self hideKeyboard];
    ForgotPasswordViewController *forgotViewController = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgotViewController animated:YES];
}

#pragma mark - TextField Delegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(!isKeyboardShowing)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
        }];
        isKeyboardShowing = YES;
    }
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
    if(!isKeyboardShowing) return;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 200);
    }];
    isKeyboardShowing = NO;
    [self.view endEditing:YES];
}

#pragma mark - Memory managment
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
