//
//  ReservationFormViewController.m
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "ReservationFormViewController.h"
#import "ServiceHelper.h"

@interface ReservationFormViewController ()

@property (weak, nonatomic) IBOutlet UITextField *guestsTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTimeTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation ReservationFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = _venue.name.uppercaseString;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_venue.image_url]];
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
    
    [self initializeDatePickerView];
}


- (IBAction)bookButtonPressed:(id)sender {
    [self hideKeyboard];
    
    if(!_guestsTextField.text.length || !_dateTimeTextField.text.length || !_phoneNumber.text.length)
    {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Completa todos los campos para reservar." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
        return;
    }
    
    NSInteger promotionId = _promotion ? _promotion.id : 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if([_commentsTextField.text isEqualToString:@"COMENTARIOS"])
        _commentsTextField.text = @"";
    
    NSMutableDictionary *reservation = [[NSMutableDictionary alloc]initWithDictionary:
                            @{@"guests": @(_guestsTextField.text.integerValue),
                              @"phone" : _phoneNumber.text,
                              @"date": [formatter stringFromDate:self.datePickerView.date],
                              @"comments": _commentsTextField.text}];
    [reservation setObject:@(promotionId) forKey:@"promotion_id"];
    [reservation setObject:@(_venue.id) forKey:@"venue_id"];
    
    [self startLoadingView];
    
    [[ServiceHelper sharedServiceHelper]createNewReservations:reservation success:^(id myResults) {
        [self stopLoadingView];
        
        [[[UIAlertView alloc]initWithTitle:@"Tu reservación ha sido recibida" message:@"Se te enviará un correo electrónico para la confirmación" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Inténtalo más tarde" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
    }];
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.frame.size.height + 220);
    
    CGPoint offset = CGPointMake(0, textField.center.y - 25);
    [UIView animateWithDuration:0.4 animations:^{
        _scrollView.contentOffset = offset;
    }];
    
    if(textField == _dateTimeTextField)
    {
        [self.view endEditing:YES];
        [self presentPickerView];

        return NO;
    }
    
    if(self.isPickerVisible)
        [self dismissPickerView];
    
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"COMENTARIOS"])
        textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(!textView.text)
        textView.text = @"COMENTARIOS";
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.4 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)donePressed
{
    [self dismissPickerView];
    
    NSDate *selectedDate = self.datePickerView.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:00"];
    _dateTimeTextField.text = [formatter stringFromDate:selectedDate];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

#pragma mark - Memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
