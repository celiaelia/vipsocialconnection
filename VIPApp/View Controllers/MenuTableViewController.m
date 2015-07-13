//
//  MenuTableViewController.m
//  SocialConnection
//
//  Created by Celia on 10/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "MenuTableViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "CelebrateViewController.h"
#import "ReservationsViewController.h"
#import "WelcomeViewController.h"
#import "ProfileViewController.h"
#import "ContactUsViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define headerHeight 100

enum MenuOptions{
    Profile,
    Reserve,
    Celebrate,
    Reservations,
    ContactUs
};

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"Background"];
    [self.view insertSubview:imageView atIndex:0];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, headerHeight - 5, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor = RGB(146, 121, 66);
    backView.alpha = 0.6;
    [self.view insertSubview:backView atIndex:1];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 65;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
    return imageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    UIImage *image;
    switch (indexPath.row) {
        case Profile:
            cell.textLabel.text = @"MI PERFIL";
            image = [UIImage imageNamed:@"MiPerfil"];
            break;
        case Reserve:
            cell.textLabel.text = @"RESERVA VIP";
            image = [UIImage imageNamed:@"ReservaVIP"];
            break;
        case Celebrate:
            cell.textLabel.text = @"MI FESTEJO";
            image = [UIImage imageNamed:@"MiFestejo"];
            break;
        case Reservations:
            cell.textLabel.text = @"MIS RESERVACIONES";
            image = [UIImage imageNamed:@"MisReservaciones"];
            break;
        case ContactUs:
            cell.textLabel.text = @"CONTACTANOS";
            image = [UIImage imageNamed:@"Contactanos"];
            break;
        default:
            break;
    }
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(-5, 5, cell.frame.size.width - 60, cell.frame.size.height + 10)];
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.alpha = 0.5;
    backView.layer.cornerRadius = 5;
    [cell.contentView insertSubview:backView atIndex:0];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 12, 40, 40)];
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller;
    
    switch (indexPath.row) {
        case Profile:
            controller = [[ProfileViewController alloc]init];
            break;
        case Reserve:
            controller = [[WelcomeViewController alloc]init];
            break;
        case Celebrate:
            controller = [[CelebrateViewController alloc]init];
            break;
        case Reservations:
            controller = [[ReservationsViewController alloc]init];
            break;
        case ContactUs:
            controller = [[ContactUsViewController alloc]init];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES
         completion:nil];
}

@end
