//
//  RegisterViewController.m
//  testApp
//
//  Created by Xiangna Jia on 7/14/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import "RegisterViewController.h"
#import "loginViewController.h"

@interface RegisterViewController()
- (IBAction)registerBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *address2Text;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

- (IBAction)maleBtnTapped:(id)sender;
- (IBAction)femaleBtnTapped:(id)sender;
- (IBAction)backToLoginBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *dobText;
@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)imageBtnPressed:(id)sender;
@property(nonatomic, strong)UIImagePickerController *picker;

@property(nonatomic,readwrite)BOOL isRegisterSuccess;

@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerClicked:(id)sender;


- (IBAction)doneBtnTapped:(id)sender;
- (IBAction)cancelDateBtnTapped:(id)sender;
@property(strong,nonatomic)NSString *tempDate;
@property(strong, nonatomic)NSString *userType;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgView.layer.borderWidth = 1.0f;
    _imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgView.layer.cornerRadius = 5.0f;
    NSString *path = [[self imageDirPath]stringByAppendingPathComponent:@"wallpaper.png"];
    
   // NSLog(@"this is the path:******* %@", path);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        _imgView.image = [UIImage imageWithContentsOfFile:path];
    }
}

#pragma -mark UI Image Picker Controller Delegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    self.imgView.image = image;
    [self saveImageIntoDirectory:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveImageIntoDirectory:(UIImage*)img{
    // convert the image to nsdata
    NSData *data = UIImagePNGRepresentation(img);
    if (data) {
        [self writeDataToImageFileName:@"wallpaper.png" withData:data];
    }
}

-(void)writeDataToImageFileName:(NSString*)name withData:(NSData*)data{
    NSString *path = [[self imageDirPath]stringByAppendingPathComponent:name];
    //NSLog(@"%@", path);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        // _usrImgView.image = [UIImage imageWithContentsOfFile:path];
        
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil]; // create a file
    }
}

-(NSString*)imageDirPath{
    NSLog(@"Home Directory path: %@", [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/"]);//temperary path
    
    //the path you want create a file
    NSString *documentPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/Images"];
    return documentPath;
}
// ************************

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnPressed:(id)sender {
        [self RegisterValidation];
}



-(NSString*)checkGender{
    if (!_femaleBtn.selected && !_maleBtn.selected) {
        [self showAlert:@"choose userType"];
    } else if(_maleBtn){
        return @"seller";
    }
    return @"buyer";
}

-(void)RegisterValidation
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rjtmobile.com/realestate/register.php?signup"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    NSString *postString =[NSString stringWithFormat:@"username=%@&password=%@&dob=%@&email=%@&mobile==%@&address1=%@&address2=%@usertype=%@&usertstatus=%@",_userNameText.text,_passwordText.text, _dobText.text, _emailText.text, _mobileText.text, _addressText.text, _address2Text.text, [self checkGender], @"yes"];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *uid = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if ([uid isEqualToString:@"bool(false)\n"]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSString *msg = @"Register is falled";
                    [self showAlert:msg];
                });
            }
            else {
                NSLog(@"Register Info : %@",uid);

                dispatch_sync(dispatch_get_main_queue(), ^{
                    loginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                    [self presentViewController:controller animated:YES completion:nil];
                });
                
            }
        }
    }] resume];
}


-(void)showAlert:(NSString*)text{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okBtn];
    [self presentViewController:alert animated:YES completion:nil];
}

-(BOOL)validUsername:(UITextField*) textField{
    if ([textField.text length] < 4 || [textField.text length] > 10) {
        return NO;
    }else {
        return YES;
    }
}

-(BOOL)validateMobile:(UITextField*)textfield{
    NSString *mobile = @"[0-9]{10}$";
    NSPredicate *emailList = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    
    return [emailList evaluateWithObject:textfield.text];
}

-(BOOL)validatePassword:(UITextField*)textfield{
    BOOL lowerCaseLetter = NO,upperCaseLetter = NO,digit = NO;
    if([textfield.text length] >= 5 && [textfield.text length] <= 10)
    {
        for (int i = 0; i < [textfield.text length]; i++)
        {
            unichar c = [textfield.text characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!upperCaseLetter)
            {
                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
        }
        if( digit && lowerCaseLetter && upperCaseLetter)
        {
            return YES;
        }
        else
        {
            NSLog(@"wrong password!");
        }
    }
    return NO;
}

- (IBAction)imageBtnPressed:(id)sender {
    _picker = [[UIImagePickerController alloc]init];
    _picker.allowsEditing = YES;
    _picker.delegate = self;
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"select the image" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCameraUsingPickerContrller];
    }];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openGalleryUsingPickerContrller];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addAction:cameraAction];
    } // if in samulator, there is no camera, avoid call camera crash
    
    
    [actionSheet addAction:galleryAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)openCameraUsingPickerContrller{
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_picker animated:YES completion:nil];
}

-(void)openGalleryUsingPickerContrller{
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_picker animated:YES completion:nil];
}

- (IBAction)datePickerClicked:(id)sender {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
        NSString *formateDate = [dateFormatter stringFromDate:self.datePicker.date];
        _tempDate = formateDate;
}

- (IBAction)doneBtnTapped:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    NSDate *date = [NSDate date];
    NSString *formateDate = [dateFormatter stringFromDate:date];
    _tempDate = formateDate;
    _dobText.text = _tempDate;
    [_subView setHidden:YES];
    [_dobText resignFirstResponder];
}

- (IBAction)cancelDateBtnTapped:(id)sender {
    [_subView setHidden:YES];
    [_dobText resignFirstResponder];
}

#pragma -mark text Field
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _dobText) {
        [_subView setHidden:NO];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (IBAction)maleBtnTapped:(id)sender {
    if (_femaleBtn.selected) {
        _femaleBtn.selected = false;
    }
    _maleBtn.selected = true;
    _userType = @"seller";
}

- (IBAction)femaleBtnTapped:(id)sender {
    if (_maleBtn.selected) {
        _maleBtn.selected = false;
    }
    _femaleBtn.selected = true;
    _userType = @"buyer";
}

- (IBAction)backToLoginBtnClicked:(id)sender {
    loginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}
@end
