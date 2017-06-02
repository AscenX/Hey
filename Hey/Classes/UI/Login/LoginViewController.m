//
//  LoginViewController.m
//  Hey
//
//  Created by Ascen on 2017/3/31.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"

#import "TabBarViewController.h"
#import "SIMPConnection.h"
#import "Store.h"

#import <SVProgressHUD/SVProgressHUD.h>

@import ReactiveObjC;
@import SDAutoLayout;


@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTFcentY;

@property (nonatomic, strong) LoginViewModel *viewModel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [[LoginViewModel alloc] init];
    
    self.usernameTF.delegate = self;
    self.passwordTF.delegate = self;
    [self.usernameTF becomeFirstResponder];
    

    
    [self bindData];
}

- (void)bindData {
//    RAC(self.loginBtn, enabled) = [[RACSignal combineLatest:@[self.usernameTF.rac_textSignal, self.passwordTF.rac_textSignal] reduce:^id _Nonnull(NSString *username, NSString *password){
//        return @(username.length > 0 && password.length > 0);
//    }] distinctUntilChanged];
    
    RAC(self.viewModel, userId) = self.usernameTF.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTF.rac_textSignal;
    
    @weakify(self)
    [[self.viewModel.loginCommand.executing deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];

    [[[self.viewModel.loginCommand.executionSignals switchToLatest] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x boolValue]) {
            UIViewController *tabBarVc = [[TabBarViewController alloc] init];
            self.view.window.rootViewController = tabBarVc;
        } else {
            NSLog(@"连接socket服务器失败");
            [[Store sharedStore] clearViewer];
            [SVProgressHUD showErrorWithStatus:@"连接失败，请重试"];
        }
    }];
    
    [[self.viewModel.loginCommand.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    self.loginBtn.rac_command = self.viewModel.loginCommand;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.usernameTF]) {
        [self.passwordTF becomeFirstResponder];
    } else if([textField isEqual:self.passwordTF]){
        [self.viewModel.loginCommand execute:nil];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
