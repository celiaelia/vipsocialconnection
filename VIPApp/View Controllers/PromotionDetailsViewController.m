//
//  PromotionDetailsViewController.m
//  SocialConnection
//
//  Created by Celia on 13/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "PromotionDetailsViewController.h"
#import "ReservationFormViewController.h"
#import "ServiceHelper.h"

@interface PromotionDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *promotionDayLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@end

@implementation PromotionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:_venueName.uppercaseString];
    
    NSDictionary *days = @{ @"lu" : @"LUNES",
                            @"ma" : @"MARTES",
                            @"mi" : @"MIERCOLES",
                            @"ju" : @"JUEVES",
                            @"vi" : @"VIERNES",
                            @"sa" : @"SABADO",
                            @"do" : @"DOMINGO"};
    
    if([_promotion respondsToSelector:@selector(schedules)])
    for(Schedule *schedule in _promotion.schedules)
    {
        if(_promotionDayLabel.text.length)
           _promotionDayLabel.text = [_promotionDayLabel.text stringByAppendingString:@", "];
        _promotionDayLabel.text = [_promotionDayLabel.text stringByAppendingString:[days valueForKey:schedule.day]];
    }
    _promotionDayLabel.adjustsFontSizeToFitWidth = YES;
    
    _descriptionText.text = _promotion.description;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_promotion.image_url]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize size = _imageView.frame.size;
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            _imageView.image = newImage;
        });
    });
    
}

- (void)fetchVenueInfo:(NSInteger)venueId
{
    [self startLoadingView];
    [[ServiceHelper sharedServiceHelper]loadVenueWithId:venueId success:^(id myResults) {
        NSError *error;
        AdverVenuesResult *result = [[AdverVenuesResult alloc]initWithDictionary:myResults error:&error];
        _venue = result.data.firstObject;
        self.navigationItem.title = _venue.name.uppercaseString;
        [self stopLoadingView];
    } failure:^(NSError *error) {}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bookButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ReservationFormViewController *reservation = [storyboard instantiateViewControllerWithIdentifier:@"ReservationFormViewController"];
    reservation.promotion = _promotion;
    reservation.navigationItem.title = _venueName;
    if(_venue)
        reservation.venue = _venue;
    [self.navigationController pushViewController:reservation animated:YES];
}


@end
