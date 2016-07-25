//
//  RegisterViewController.h
//  testApp
//
//  Created by Xiangna Jia on 7/14/16.
//  Copyright © 2016 xiangna jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic,readwrite)BOOL isRegister;
@property(nonatomic,readwrite)int userId;

@end
