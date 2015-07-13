//
//  AdvertisingImageViewController.m
//  VIPApp
//
//  Created by Celia on 12/01/15.
//  Copyright (c) 2015 VIPTeam. All rights reserved.
//

#import "AdvertisingImageViewController.h"

@interface AdvertisingImageViewController ()

@end

@implementation AdvertisingImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _promotion.name.uppercaseString;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 77, self.view.frame.size.width, 400)];
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_promotion.full_image_url]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize size = imageView.frame.size;
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            imageView.image = newImage;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
