//
//  PropertyListViewController.m
//  rentalSaleApp
//
//  Created by Xiangna Jia on 7/24/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import "PropertyListViewController.h"
#import "propertyListCollectionViewCell.h"
#import "AddPropertyViewController.h"

@interface PropertyListViewController()
@property (weak, nonatomic) IBOutlet UICollectionView *listCollectionView;
@property(strong, nonatomic)NSMutableArray *arrResult;
- (IBAction)addNewPropertyBtnPressed:(id)sender;
@end

@implementation PropertyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
}

-(void)viewWillAppear:(BOOL)animated{
 [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getData {
//    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
//    NSString *uid = [userDefault valueForKey:@"kUID"];
      NSString *foodUrlString = @"";
        foodUrlString  = [NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/getproperty.php?all=&userid=%@",@"21"] ;
        NSURL *foodUrl = [NSURL URLWithString:foodUrlString];
        
        [[[NSURLSession sharedSession] dataTaskWithURL:foodUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                _arrResult = json;
                NSLog(@"%@", _arrResult);
                [_listCollectionView performSelectorOnMainThread:@selector(reloadData)
                                                          withObject:nil
                                                       waitUntilDone:NO];
            }
        }] resume];
}

#pragma -mark collection data sources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSLog(@"%d",[_arrResult count]);
   return [_arrResult count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"listCell";
    propertyListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *dict = [_arrResult objectAtIndex:indexPath.row];
    NSString *url1 = [dict valueForKey:@"Property Image 1"];
    NSString *url11 = [url1 stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString *string1 = [NSString stringWithFormat:@"http://%@",url11];
    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:string1]];
    cell.image1View.image = [UIImage imageWithData:data1];
    
    NSString *url2 = [dict valueForKey:@"Property Image 2"];
    NSString *url22 = [url2 stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString *string2 = [NSString stringWithFormat:@"http://%@",url22];
    NSData *data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:string2]];
    cell.image2View.image = [UIImage imageWithData:data2];
    
    NSString *url3 = [dict valueForKey:@"Property Image 3"];
    NSString *url33 = [url3 stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString *string3 = [NSString stringWithFormat:@"http://%@",url33];
    NSData *data3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:string3]];
    cell.image3View.image = [UIImage imageWithData:data3];
    cell.nameLabel.text = [dict valueForKey:@"Property Name"];
    if ([[dict valueForKey:@"Property Category"]intValue]) {
        cell.categoryLabel.text = @"Sale";
    }else{
        cell.categoryLabel.text = @"Rental";
    }
    cell.typeLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Type"]];
    cell.sizeLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Size"]];
    cell.zipCodeLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Zip"]];
    cell.latLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Latitude"]];
    cell.lonLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Longitude"]];
    cell.descLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Desc"]];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Address1"]];
    cell.address2Label.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Address2"]];
    cell.costLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Cost"]];
    
    cell.shareBtn.tag = indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(shareBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editBtnTapped: event:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = [[dict valueForKey:@"Property Id"] intValue];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

-(void)deleteBtnTapped:(UIButton*)sender{
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"9a347726-d17a-36d2-66fc-b28d5168568f" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/register.php?property&edit&pptyid=%d",sender.tag]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        //NSLog(@"delete success");
                                                        [self showAlert:@"delete success"];
                                                        
                                                    }
                                                }];
    [dataTask resume];
    [self getData];
}

-(void)editBtnTapped:(UIButton*)sender event:(int)event{

}

-(void)shareBtnTapped:(UIButton*)sender{
    NSString *content = [NSString stringWithFormat:@"Name:%@ \n address:%@ \n Price:%.2f \n",[[_arrResult objectAtIndex:sender.tag] valueForKey:@"Property Name"],[[_arrResult objectAtIndex:sender.tag] valueForKey:@"Property Address1"],[[[_arrResult objectAtIndex:sender.tag] valueForKey:@"Property Cost"] floatValue]];
    
    if ([content length]) {
        NSArray *arrResult = @[@"Hello, friend, share you a good products", content];
        
        UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:arrResult applicationActivities:nil];
        
        NSArray *array = @[UIActivityTypePrint, UIActivityTypeOpenInIBooks, UIActivityTypePostToWeibo];
        activity.excludedActivityTypes = array;
        [self presentViewController:activity animated:YES completion:nil];
    }
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


- (IBAction)addNewPropertyBtnPressed:(id)sender {
        AddPropertyViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPropertyViewController"];
        [self.navigationController pushViewController:controller animated:true];
}

-(void)showAlert: (NSString*)msg {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}
@end
