//
//  AddPropertyViewController.m
//  rentalSaleApp
//
//  Created by Xiangna Jia on 7/24/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import "AddPropertyViewController.h"

@interface AddPropertyViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *typeText;
@property (weak, nonatomic) IBOutlet UITextField *categoryText;
@property (weak, nonatomic) IBOutlet UITextField *address1Text;
@property (weak, nonatomic) IBOutlet UITextField *address2Text;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeText;
@property (weak, nonatomic) IBOutlet UITextField *latText;
@property (weak, nonatomic) IBOutlet UITextField *logText;
@property (weak, nonatomic) IBOutlet UITextField *descText;
@property (weak, nonatomic) IBOutlet UITextField *sizeText;
@property (weak, nonatomic) IBOutlet UIImageView *img1View;
@property (weak, nonatomic) IBOutlet UIImageView *img2View;
@property (weak, nonatomic) IBOutlet UIImageView *img3View;
- (IBAction)addBtnTapped:(id)sender;
- (IBAction)img1BtnTapped:(id)sender;
- (IBAction)img2BtnTapped:(id)sender;
- (IBAction)img3BtnTapped:(id)sender;
@property(nonatomic, strong) UIImagePickerController *picker;
@property(nonatomic,readwrite)int index;
@property (weak, nonatomic) IBOutlet UITextField *costText;

@end

@implementation AddPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addBtnTapped:(id)sender {
    [self addToDataBase];
}


-(void)addToDataBase{
//    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
//    NSLog(@"%@",[userDefault valueForKey:@"UserId"]);
//    int userid = [[[[userDefault valueForKey:@"UserId"] objectAtIndex:0] valueForKey:@"User Id"]intValue];
//    NSLog(@"%d", userid);
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"%@",_nameText.text] forKey:@"propertyname"];
    [_params setObject:[NSString stringWithFormat:@"%@",_typeText.text] forKey:@"propertytype"];
    [_params setObject:[NSString stringWithFormat:@"%@",_categoryText] forKey:@"propertycat"];
    [_params setObject:[NSString stringWithFormat:@"%@",_address1Text.text] forKey:@"propertyaddress1"];
    [_params setObject:[NSString stringWithFormat:@"%@",_address2Text.text] forKey:@"propertyaddress2"];
    [_params setObject:[NSString stringWithFormat:@"%@",_zipcodeText.text] forKey:@"propertyzip"];
    [_params setObject:[NSString stringWithFormat:@"%@",_latText.text] forKey:@"propertylat"];
    [_params setObject:[NSString stringWithFormat:@"%@",_logText.text] forKey:@"propertylong"];
    [_params setObject:[NSString stringWithFormat:@"%@",_sizeText.text] forKey:@"propertysize"];
    [_params setObject:[NSString stringWithFormat:@"%@",_descText.text] forKey:@"propertydesc"];
    [_params setObject:[NSString stringWithFormat:@"%@",_costText.text] forKey:@"propertycost"];
    [_params setObject:[NSString stringWithFormat:@"%@",@"21"] forKey:@"userid"];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaxxxxKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"userimage";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://www.rjtmobile.com/realestate/register.php?property&add"];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(_img1View.image, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", @"propertyimg1",@"propertyimg1"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSData *imageData1 = UIImageJPEGRepresentation(_img2View.image, 1.0);
    if (imageData1) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", @"propertyimg2",@"propertyimg2"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData1];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSData *imageData2 = UIImageJPEGRepresentation(_img3View.image, 1.0);
    if (imageData2) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", @"propertyimg3",@"propertyimg3"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData2];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",dataString);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([dataString isEqualToString:@"bool(true)\n"]) {
                //[self dismissViewControllerAnimated:YES completion:nil];
                NSLog(@"%@", dataString);
                [self showAlert:@"Add Success!"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Wrong" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [controller addAction:action];
                [self presentViewController:controller animated:YES completion:nil];
            }
        });
        
    }] resume];
}

- (IBAction)img1BtnTapped:(id)sender {
    _index = 1;
    [self getAlert];
}

- (IBAction)img2BtnTapped:(id)sender {
    _index = 2;
    [self getAlert];
}

- (IBAction)img3BtnTapped:(id)sender {
    _index = 3;
    [self getAlert];
}

-(void)getAlert{
    _picker = [[UIImagePickerController alloc] init];
    _picker.allowsEditing = YES;
    _picker.delegate = self;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"Select the source" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCameraUsingPickerController];
    }];
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openGalleryUsingPickerController];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addAction:cameraAction];
    }
    [actionSheet addAction:galleryAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma  mark-  Image Picker Controller Delegate Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    if(_index == 1){
        _img1View.image = image;
    }else if (_index == 2){
        _img2View.image = image;
    } else{
        _img3View.image = image;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) openCameraUsingPickerController {
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_picker animated:YES completion:nil];
    
}

-(void) openGalleryUsingPickerController {
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_picker animated:YES completion:nil];
}

#pragma mark- TextField Delegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if (textField == _retypePswdTextField || textField == _addressLine1TextField || textField == _addressLine2TextField || textField == _weightTextField || textField == _heightTextField || textField == _userStatusTextField) {
//        [self animatedTextField:textField UP:YES];
//    }
    if (textField == _typeText) {
        [self chooseType];
    }
    if (textField == _categoryText) {
        [self chooseCategory];
    }
    return YES;
}// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField == _retypePswdTextField || textField == _addressLine1TextField || textField == _addressLine2TextField || textField == _heightTextField || textField == _weightTextField || textField == _userStatusTextField) {
//        [self animatedTextField:textField UP:NO];
//    }
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}// return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameText) {
        [_typeText becomeFirstResponder];
    }
    else if (textField == _typeText) {
        [_categoryText becomeFirstResponder];
    }
    else if (textField == _categoryText) {
        [_address1Text becomeFirstResponder];
    }
    else if (textField == _address1Text){
        [_address2Text becomeFirstResponder];
    }
    else if (textField == _address2Text) {
        [_zipcodeText becomeFirstResponder];
    }
    else if (textField == _zipcodeText) {
        [_latText becomeFirstResponder];
    }
    else if (textField == _latText) {
        [_logText becomeFirstResponder];
    }
    else if (textField == _logText) {
        [_descText becomeFirstResponder];
    }
    else if (textField == _descText) {
        [_sizeText becomeFirstResponder];
    }else{
        [_sizeText resignFirstResponder];
    }
    return YES;
}



-(void) animatedTextField: (id)text UP: (BOOL) up {
    const int movementDistance = 200;
    const float movementDuration = 0.3f;
    int move = up ? -movementDistance:movementDistance;
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, move);
    [UIView commitAnimations];
}

-(void)chooseType{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Choose Type" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *plotAction = [UIAlertAction actionWithTitle:@"Plot" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _typeText.text = @"Plot";
    }];
    
    UIAlertAction *flatAction = [UIAlertAction actionWithTitle:@"Flat" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _typeText.text = @"Flat";
    }];
    
    UIAlertAction *houseAction = [UIAlertAction actionWithTitle:@"House" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _typeText.text = @"House";
        
    }];
    UIAlertAction *OfficeAction = [UIAlertAction actionWithTitle:@"Office" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _typeText.text = @"Office";
        
    }];
    UIAlertAction *VillaAction = [UIAlertAction actionWithTitle:@"Villa" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _typeText.text = @"Villa";
        
    }];
    
    [actionSheet addAction:plotAction];
    [actionSheet addAction:flatAction];
    [actionSheet addAction:OfficeAction];
    [actionSheet addAction:houseAction];
    [actionSheet addAction:VillaAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)chooseCategory{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Choose Category" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saleAction = [UIAlertAction actionWithTitle:@"Sale" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _categoryText.text = @"Sale";
    }];
    
    UIAlertAction *rentalAction = [UIAlertAction actionWithTitle:@"Rental" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _categoryText.text = @"Rental";
    }];
    [actionSheet addAction:saleAction];
    [actionSheet addAction:rentalAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)showAlert: (NSString*)msg {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
