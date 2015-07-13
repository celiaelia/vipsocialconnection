//
//  AreasViewController.m
//  SocialConnection
//
//  Created by Celia on 11/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "AreasViewController.h"
#import "AreaDetailsViewController.h"
#import "ServiceHelper.h"
#import "VenuesResult.h"

#define CellSize 90

@interface AreasViewController ()

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation AreasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [_area.name uppercaseString];
    
    self.bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 77, self.view.frame.size.width, 100)];
    self.bannerView.backgroundColor = [UIColor whiteColor];
    [self loadAdvertising];
    [self.view addSubview:self.bannerView];
    
    [self fetchData];
}

- (void)fetchData
{
    [self startLoadingView];
    
    [[ServiceHelper sharedServiceHelper]venuesForArea:_area.id
                                              success:^(id result)
    {
        [self stopLoadingView];
        NSError *error;
        VenuesResult *venues = [[VenuesResult alloc]initWithDictionary:result error:&error];
        _dataArray = venues.data;
        [self createCollectionViewWithFetchedData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)createCollectionViewWithFetchedData
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 190, self.view.frame.size.width - 20,
                                                                                          self.view.frame.size.height - 200)
                                                          collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [self.view addSubview:collectionView];
}


#pragma mark - CollectionView Delegate Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor lightGrayColor];
    cell.layer.cornerRadius = 10;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *url = [[_dataArray objectAtIndex:indexPath.row]logo_url];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIGraphicsBeginImageContext(CGSizeMake(CellSize, CellSize));
            [image drawInRect:CGRectMake(0, 0, CellSize, CellSize)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.backgroundColor = [UIColor colorWithPatternImage:newImage];
        });
    });
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CellSize, CellSize);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AreaDetailsViewController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"AreaDetailsViewController"];
    detailsViewController.navigationItem.title = _area.name;
    detailsViewController.venue = [_dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}


#pragma mark - Memory managment
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
