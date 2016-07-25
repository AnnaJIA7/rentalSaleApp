//
//  RecentViewController.m
//  rentalSaleApp
//
//  Created by Xiangna Jia on 7/21/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import "RecentViewController.h"
#import <UNIRest.h>
#import "CustomPropertyCollectionCell.h"
#import "detailViewController.h"

@interface RecentViewController(){
    NSArray *resultArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *propertyCollectionView;
@property(nonatomic,strong)NSMutableArray *arrResult;


@end

@implementation RecentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllData];
    [_propertyCollectionView reloadData];
}

-(void)getAllData{
    
    NSDictionary *headers = @{@"X-Mashape-Key": @"hhjfxbbrB0mshpGeX0dIIuw2eQxzp1lSwcrjsn4hJxHi5Z7fvM", @"Accept": @"application/json"};
    UNIUrlConnection *asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://zilyo.p.mashape.com/search?isinstantbook=true&nelatitude=22.37&nelongitude=-154.48000000000002&provider=airbnb%2Chousetrip&swlatitude=18.55&swlongitude=-160.52999999999997"];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSInteger code = response.code;
        NSDictionary *responseHeaders = response.headers;
        UNIJsonNode *body = response.body;
        NSData *rawBody = response.rawBody;
        resultArray = [NSArray arrayWithArray:[body.object objectForKey:@"result"]];
        _arrResult = [[NSMutableArray alloc] initWithArray:resultArray];
        
//        NSLog(@"%@",[_arrResult objectAtIndex:0]);
//        NSLog(@"%@",[[[_arrResult objectAtIndex:0] valueForKey:@"location"] valueForKey:@"all"]);
        
        [_propertyCollectionView performSelectorOnMainThread:@selector(reloadData)
                                   withObject:nil
                                waitUntilDone:NO];
        
//        NSLog(@"%@", [[[body.object valueForKey:@"result"] objectAtIndex:0] valueForKey:@"photos"]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark collection data sources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%d",[_arrResult count]);
    return [_arrResult count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"propertyCell";
    CustomPropertyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *dict = [_arrResult objectAtIndex:indexPath.row];
    NSString *url = [[[dict valueForKey:@"photos"] objectAtIndex:1] valueForKey:@"large"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"price"] valueForKey:@"monthly"]];
    cell.imgView.image = [UIImage imageWithData:data];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"location"] valueForKey:@"all"]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    detailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    [controller setInfo:[_arrResult objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:controller animated:true];
}

- (void)viewDidLayoutSubviews:(int)someInt
{

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10; // This is the minimum inter item spacing, can be more
}



@end
