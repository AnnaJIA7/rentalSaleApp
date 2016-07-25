//
//  detailViewController.m
//  rentalSaleApp
//
//  Created by Xiangna Jia on 7/24/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import "detailViewController.h"
#import "detailCollectionCell.h"

@interface detailViewController(){
    NSArray *photoArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *colletionView;
@property(nonatomic,strong)NSMutableArray *photoArr;
@property (weak, nonatomic) IBOutlet UILabel *namePropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *address1Label;
@property (weak, nonatomic) IBOutlet UILabel *address2Label;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longtitudeLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipCodeLabel;

@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", _info);
    photoArray = [NSArray arrayWithArray:[_info valueForKey:@"photos"]];
    _photoArr = [[NSMutableArray alloc] initWithArray:photoArray];
    [_colletionView reloadData];
    
    _namePropertyLabel.text = [[_info valueForKey:@"attr"] valueForKey:@"heading"];
    int temp = [self getRandomNumberBetween:0 to:4];
    switch (temp) {
        case 0:
            _typeLabel.text = @"Plot";
            break;
        case 1:
            _typeLabel.text = @"Flat";
            break;
        case 2:
            _typeLabel.text = @"House";
            break;
        case 3:
            _typeLabel.text = @"Office";
            break;
        case 4:
            _typeLabel.text = @"Villa";
            break;
        default:
            break;
    }
    int category = [self getRandomNumberBetween:0 to:1];
    if (category) {
        _categaryLabel.text = @"Sale";
    }else{
        _categaryLabel.text = @"Rent";
    }
    _address1Label.text = [[_info valueForKey:@"location"] valueForKey:@"streetName"];
    _address2Label.text = [[_info valueForKey:@"location"] valueForKey:@"neighbourhood"];
    _longtitudeLabel.text = [NSString stringWithFormat:@"%d",[[[_info valueForKey:@"latLng"] objectAtIndex:0]intValue]];
    _latitudeLabel.text = [NSString stringWithFormat:@"%d",[[[_info valueForKey:@"latLng"] objectAtIndex:1]intValue]];    _descriptionLabel.text = [_info valueForKey:@"description"];
    _sizeLabel.text = [NSString stringWithFormat:@"%d",[self getRandomNumberBetween:1000 to:5000]];
    _descriptionLabel.text = [[_info valueForKey:@"attr"] valueForKey:@"description"];
    _zipCodeLabel.text = [NSString stringWithFormat:@"%d",[[[_info valueForKey:@"location"] valueForKey:@"postalCode"] intValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

#pragma -mark collection data sources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //NSLog(@"%d",[_arrResult count]);
    return [_photoArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"detailCell";
    detailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    NSString *url = [[_photoArr objectAtIndex:indexPath.row] valueForKey:@"large"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    cell.nameLabel.text = [[_photoArr objectAtIndex:indexPath.row] valueForKey:@"caption"];
    cell.imgView.image = [UIImage imageWithData:data];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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


@end
