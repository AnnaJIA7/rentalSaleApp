//
//  CustomPropertyCollectionCell.h
//  rentalSaleApp
//
//  Created by Xiangna Jia on 7/21/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPropertyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedroomLabel;
@property (weak, nonatomic) IBOutlet UIButton *heartBtn;

@end
