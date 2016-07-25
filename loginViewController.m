//
//  loginViewController.m
//  rentalSaleApp
//
//  Created by Xiangna Jia on 7/24/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import "loginViewController.h"
#import <QuickLook/QuickLook.h>
#import "HomeViewController.h"
#import "RegisterViewController.h"
#import "TabBarController.h"

@interface loginViewController()
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *sellerBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyerBtn;
- (IBAction)sellerBtnTapped:(id)sender;
- (IBAction)buyerBtnTapped:(id)sender;
- (IBAction)submitBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property(nonatomic,strong)NSString *usertype;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
- (IBAction)signUpBtnTapped:(id)sender;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"back1" withExtension:@"gif"];
    self.backgroundImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    [[_submitBtn layer] setBorderWidth:1.0f];
    [[_submitBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sellerBtnTapped:(id)sender {
    if (_buyerBtn.selected) {
        _buyerBtn.selected = NO;
    }
    _sellerBtn.selected = YES;
    _usertype = @"seller";
}

- (IBAction)buyerBtnTapped:(id)sender {
    if (_sellerBtn.selected) {
        _sellerBtn.selected = NO;
    }
    _buyerBtn.selected = YES;
    _usertype = @"buyer";
}

- (IBAction)submitBtnTapped:(id)sender {
    [self loginValidation];
}

- (IBAction)signUpBtnTapped:(id)sender {
    RegisterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)loginValidation {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rjtmobile.com/realestate/register.php?login"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSString *postString =[NSString stringWithFormat:@"email=%@&password=%@&usertype=%@",_emailText.text,_passwordText.text,_usertype];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *uid = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if ([uid isEqualToString:@"bool(false)\n"]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSString *msg = @"Email address or password is invalid";
                    [self alertForLogin:msg];
                });
            }
            else {
                NSLog(@"%@",uid);
                NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
                    [userDefault setObject:uid forKey:@"UserId"];

                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    TabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                    [self presentViewController:controller animated:YES completion:nil];
                });
                
            }
        }
    }] resume];
}

-(void)alertForLogin: (NSString*)msg {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}
@end













