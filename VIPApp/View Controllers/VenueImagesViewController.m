//
//  VenueImagesViewController.m
//  SocialConnection
//
//  Created by Celia on 15/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "VenueImagesViewController.h"
#import "VIPButton.h"

@interface VenueImagesViewController ()

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIImageView *fullImage;
@property (nonatomic, strong)NSMutableArray *images;

@end

@implementation VenueImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:_venue.name.uppercaseString];
    
    _images = [[NSMutableArray alloc]init];
    
    for(int x = 0; x < _venue.photos.count; x++)
    {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90)];
        [_images addObject:image];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 77, self.view.frame.size.width, 100)];
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_venue.image_url]];
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
    
    [self createCollectionViewWithFetchedData];
}

- (void)createCollectionViewWithFetchedData
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 190, self.view.frame.size.width - 20,
                                                                                          self.view.frame.size.height - 200)
                                                          collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - CollectionView Delegate Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _venue.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor lightGrayColor];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *url = [[_venue.photos objectAtIndex:indexPath.row]image_url];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIGraphicsBeginImageContext(CGSizeMake(93, 93));
            [image drawInRect:CGRectMake(0, 0, 93, 93)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.backgroundColor = [UIColor colorWithPatternImage:newImage];
            [[_images objectAtIndex:indexPath.row]setImage:image];
        });
    });
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(93, 93);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_fullImage)
        return;
    
    UIView *view = [collectionView cellForItemAtIndexPath:indexPath];
    _fullImage = [_images objectAtIndex:indexPath.row];
    _fullImage.frame = view.frame;
    _fullImage.userInteractionEnabled = YES;
    _fullImage.center = CGPointMake(_fullImage.center.x + 10, _fullImage.center.y + 190);
    _fullImage.tag = indexPath.row;
    [self.view addSubview:_fullImage];
    
    [UIView animateWithDuration:0.5 animations:^{
        _fullImage.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 100);
    } completion:^(BOOL finished){
        VIPButton *button = [[VIPButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80, 10, 70, 30)];
        [button setTitle:@"Cerrar" forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(closeFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [_fullImage addSubview:button];
    
    }];
}

- (void)closeFullScreen:(UIButton*)sender
{
    [sender removeFromSuperview];
    UIView *view = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_fullImage.tag inSection:0]];
    [UIView animateWithDuration:0.5 animations:^{
        _fullImage.frame = CGRectMake(view.frame.origin.x + 10, view.frame.origin.y + 190, view.frame.size.width, view.frame.size.height);
    } completion:^(BOOL finished){
        [_fullImage removeFromSuperview];
        _fullImage = nil;
    }];
}


#pragma mark - Memory managment
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
