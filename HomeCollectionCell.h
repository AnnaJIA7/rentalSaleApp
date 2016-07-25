//
//  HomeCollectionCell.h
//  rentalSaleApp
//
//  Created by Xiangna Jia on 7/22/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
