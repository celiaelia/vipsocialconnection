//
//  AppDelegate.m
//  SocialConnection
//
//  Created by Celia on 10/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "AppDelegate.h"
#import "ServiceHelper.h"
#import "UsersResult.h"
#import <FacebookSDK/FacebookSDK.h>
#import "WelcomeViewController.h"
#import "MenuTableViewController.h"
#import "MMDrawerController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSData *tokenData = [[NSUserDefaults standardUserDefaults]valueForKey:@"sharedToken"];
    
    if(tokenData)
    {
        Token *sharedTokenInfo = [NSKeyedUnarchiver unarchiveObjectWithData:tokenData];
        NSData *userData = [[NSUserDefaults standardUserDefaults]valueForKey:@"sharedUser"];
        UsersResult *sharedUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [[ServiceHelper sharedServiceHelper]setSharedTokenInfo:sharedTokenInfo];
        [[ServiceHelper sharedServiceHelper]setSharedUserInfo:sharedUserInfo];
        [[ServiceHelper sharedServiceHelper]retrieveSavedToken];
        
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
        self.window.rootViewController = drawerController;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    Token *user = [[ServiceHelper sharedServiceHelper]sharedTokenInfo];
    if(!user)
        return;
    
    NSDate *expirationTime = [[NSUserDefaults standardUserDefaults]valueForKey:@"expirationTime"];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:expirationTime];
    
    if(interval > user.expires_in)
    {
        UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        self.window.rootViewController = loginVC;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
