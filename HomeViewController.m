//
//  HomeViewController.m
//  rentalSaleApp
//
//  Created by Xiangna Jia on 7/21/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import "HomeViewController.h"
#import "CDRTranslucentSideBar.h"
#import <UNIRest.h>
#import "HomeCollectionCell.h"
@import GoogleMaps;
#import "detailViewController.h"

@interface HomeViewController(){
    NSArray *resultArray;
    NSArray *photoArray;
    GMSMapView *mapView_;
}

@property (weak, nonatomic) IBOutlet UIView *mapView;
@property(nonatomic,strong)NSMutableArray *arrResult;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
- (IBAction)sideBarBtnTapped:(id)sender;

@property(nonatomic,strong)NSString *log;
@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *info;
@property(nonatomic,strong)NSString *address;
@property (weak, nonatomic) IBOutlet UICollectionView *homeCollectionView;
@property(nonatomic,strong)NSMutableArray *photoArr;
@property(nonatomic,strong)NSMutableArray<GMSMarker*> *markersArr;
@property(nonatomic, readwrite)int indexItem;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllData];
    _lat = @"47.6226289";
    _log = @"-122.33548200000001";
    _markersArr = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    // Create SideBar and Set Properties
    self.sideBar = [[CDRTranslucentSideBar alloc] init];
    self.sideBar.sideBarWidth = 200;
    self.sideBar.delegate = self;
    self.sideBar.tag = 0;
    
    // Add PanGesture to Show SideBar by PanGesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    // Create Content of SideBar
    UITableView *tableView = [[UITableView alloc] init];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    v.backgroundColor = [UIColor clearColor];
    [tableView setTableHeaderView:v];
    [tableView setTableFooterView:v];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    // Set ContentView in SideBar
    [self.sideBar setContentViewInSideBar:tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getAllData{
    
    NSDictionary *headers = @{@"X-Mashape-Key": @"hhjfxbbrB0mshpGeX0dIIuw2eQxzp1lSwcrjsn4hJxHi5Z7fvM", @"Accept": @"application/json"};
    UNIUrlConnection *asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://zilyo.p.mashape.com/search?isinstantbook=true&nelatitude=47.6226289&nelongitude=-122.33548200000001&provider=airbnb%2Chousetrip&swlatitude=46.6226289&swlongitude=-123.52999999999997"];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSInteger code = response.code;
        NSDictionary *responseHeaders = response.headers;
        UNIJsonNode *body = response.body;
        NSData *rawBody = response.rawBody;
        resultArray = [NSArray arrayWithArray:[body.object objectForKey:@"result"]];
        _arrResult = [[NSMutableArray alloc] initWithArray:resultArray];
        
        [self createMaps];
    }];
}


-(void)createMaps {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"*********************%d", _arrResult.count);
        
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[_lat doubleValue]
                                                                    longitude:[_log doubleValue]
                                                                         zoom:13];
        
            mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, _mapView.frame.size.width, _mapView.frame.size.height) camera:camera];
            mapView_.delegate = self;
            mapView_.myLocationEnabled = YES;
            [_mapView addSubview:mapView_];
        
        for (int i = 0;  i < _arrResult.count; i++) {
            NSDictionary *dict = [_arrResult objectAtIndex:i];
            
            // Creates a marker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];

            marker.position = CLLocationCoordinate2DMake([[[dict valueForKey:@"latLng"] objectAtIndex:0] doubleValue], [[[dict valueForKey:@"latLng"] objectAtIndex:1] doubleValue]);
            
            NSLog(@"lat:%f",[[[dict valueForKey:@"latLng"] objectAtIndex:0] doubleValue] );
            NSLog(@"log:%f",[[[dict valueForKey:@"latLng"] objectAtIndex:1] doubleValue] );
            //marker.title = [[dict valueForKey:@"location"] valueForKey:@"all"];
            marker.title = [NSString stringWithFormat:@"%d", i];
            marker.icon = [UIImage imageNamed:@"unselected"];
            //    marker.snippet = [NSString stringWithFormat:@"%@",[[NSArray alloc]initWithArray:[[_detail valueForKey:@"location"] valueForKey:@"formattedAddress"]]];
            marker.map = mapView_;
            [_markersArr addObject:marker];
        }
    });
}

-(BOOL) mapView:(GMSMapView *) mapView didTapMarker:(GMSMarker *)marker
{
    int index = [marker.title intValue];
    marker.icon = [UIImage imageNamed:@"selected"];
    photoArray = [NSArray arrayWithArray:[[_arrResult objectAtIndex:index] valueForKey:@"photos"]];
    _photoArr = [[NSMutableArray alloc] initWithArray:photoArray];
    
    for (int i = 0; i < _markersArr.count; i++) {
        if ([_markersArr[i].title intValue] != index) {
            _markersArr[i].icon = [UIImage imageNamed:@"unselected"];
        }
    }

    _indexItem = index;
    
   // NSLog(@"%@",_photoArr);
    _price = [NSString stringWithFormat:@"%@", [[[_arrResult objectAtIndex:index]valueForKey:@"price"] valueForKey:@"monthly"]];
    _address = [NSString stringWithFormat:@"%@",[[[_arrResult objectAtIndex:index]valueForKey:@"location"] valueForKey:@"all"]];
    _homeCollectionView.hidden = NO;
    [_homeCollectionView reloadData];
    return YES;
}



#pragma mark - Gesture Handler
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    // if you have left and right sidebar, you can control the pan gesture by start point.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = [recognizer locationInView:self.view];
        
        // Left SideBar
        if (startPoint.x < self.view.bounds.size.width / 2.0) {
            self.sideBar.isCurrentPanGestureTarget = YES;
        }
    }
    
    [self.sideBar handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - CDRTranslucentSideBarDelegate
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated {
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated {
    
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated {
    
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated {
    
}

// This is just a sample for tableview menu
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        if (section == 0) {
            return 1;
        }
        else if (section == 1) {
            return 1;
        }else if(section == 2){
            return 1;
        }
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        if (section == 0) {
            // StatuBar Height
            return 20;
        }
        else if (section == 1) {
            return 44;
        } else if (section == 2) {
            return 10;
        }else{
            return 10;
        }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        if (section == 0) {
            UIView *clearView = [[UIView alloc] initWithFrame:CGRectZero];
            clearView.backgroundColor = [UIColor clearColor];
            return clearView;
        }
        else if (section == 1) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
            headerView.backgroundColor = [UIColor clearColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.bounds.size.width - 15, 44)];
            UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44, tableView.bounds.size.width, 0.5f)];
            separatorLineView.backgroundColor = [UIColor blackColor];
            [headerView addSubview:separatorLineView];
            label.text = @"Info";
            [headerView addSubview:label];
            return headerView;
        }else{
            UIView *clearView = [[UIView alloc] initWithFrame:CGRectZero];
            clearView.backgroundColor = [UIColor clearColor];
            return clearView;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 0) {
            // StatuBar Height
            return 20;
        }
        else if (indexPath.section == 1) {
            return 44;
        }else if (indexPath.section == 2) {
            return 35;
        }else{
            return 35;
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        if (indexPath.section == 0) {
            return cell;
        }
        else if (indexPath.section == 1) {
//            NSDictionary *dict = [_arrResult objectAtIndex:indexPath.row];
//            UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
//            cell.textLabel.font  = myFont;
//            cell.textLabel.text = [dict valueForKey:@"CatagoryName"];
            UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 16.0 ];
            cell.textLabel.font  = myFont;
            cell.textLabel.text = @"Likes";
        }else if (indexPath.section == 2) {
            UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 16.0 ];
            cell.textLabel.font  = myFont;
            cell.textLabel.text = @"History";
            return cell;
        }else{
            UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 18.0 ];
            cell.textLabel.font  = myFont;
            cell.textLabel.text = @"Sign Out";
            return cell;
        }
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.detailTblView != tableView) {
//        if (indexPath.section == 0) {
//            
//        }
//        else if (indexPath.section == 1) {
//            [self viewDidLayoutSubviews:(int)indexPath.row];
//            _currentIndex = 107 + (int)indexPath.row;
//            [_detailTblView reloadData];
//            self.sideBar.isCurrentPanGestureTarget = NO;
//            [self.sideBar dismiss];
//            
//        }else if(indexPath.section == 2){
//            HistoryViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
//            [self presentViewController:controller animated:YES completion:nil];
//            
//        } else if(indexPath.section == 3){
//            ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//            [self presentViewController:controller animated:YES completion:nil];
//        }
//    }else {
//        ItemViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemViewController"];
//        NSString *temp = [NSString stringWithFormat:@"%d",_currentIndex];
//        [controller setCategoryIndex:temp];
//        [controller setSubCategoryIndex:(int)indexPath.row];
//        [self presentViewController:controller animated:YES completion:nil];
//    }
}

- (IBAction)sideBarBtnTapped:(id)sender {
    [self.sideBar show];
}

#pragma -mark collection data sources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //NSLog(@"%d",[_arrResult count]);
    return [_photoArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"homeCell";
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //NSDictionary *dict = [_arrResult objectAtIndex:indexPath.row];
    NSString *url = [[_photoArr objectAtIndex:indexPath.row] valueForKey:@"large"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    cell.priceLabel.text = _price;
    cell.imgView.image = [UIImage imageWithData:data];
    cell.addressLabel.text = _address;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    detailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    [controller setInfo:[_arrResult objectAtIndex:_indexItem]];
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

@end
