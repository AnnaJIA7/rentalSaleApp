//
//  HomeViewController.h
//  rentalSaleApp
//
//  Created by Xiangna Jia on 7/21/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDRTranslucentSideBar.h"
@import GoogleMaps;
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController : UIViewController<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate,CDRTranslucentSideBarDelegate,UIScrollViewDelegate, GMSMapViewDelegate, CLLocationManagerDelegate>

@end
