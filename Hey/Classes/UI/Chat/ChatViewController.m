//
//  ChatViewController.m
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMyselfTableViewCell.h"
#import "ChatOthersTableViewCell.h"
#import "UIColor+Help.h"
#import <M80AttributedLabel/M80AttributedLabel.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "SIMPConnection.h"
#import "SIMPMessage.h"
#import "ChatBottomView.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ChatBottomView *bottomView;

@property (nonatomic, strong) SIMPConnection *connection;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xF2F6FA alpha:0.77f];
    
    [self addView];
    [self defineLayout];
    [self bindData];
    
}

- (void)addView {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    self.bottomView.textView.delegate = self;
}

- (void)defineLayout {
    CGRect rect = self.view.bounds;
    self.bottomView.frame = CGRectMake(0, rect.size.height - 56, rect.size.width, 56);
    self.tableView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height - 56);
}

- (void)bindData {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    CGSize size = self.view.bounds.size;
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height - height - 56);
    self.bottomView.frame = CGRectMake(0, size.height - 56 - height, size.width, 56);
    
//    [self scrollTableToFoot:YES];
}

- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

- (void)keyBoardHide:(NSNotification *)notification {
    CGSize size = self.view.bounds.size;
    self.bottomView.frame = CGRectMake(0, size.height - 56, size.width, 56);
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height - 56);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMyselfTableViewCell *cell = [ChatMyselfTableViewCell cellWithTableView:tableView];
    
//    cell.contentLabel.text      = @"安赛飞安赛飞安赛飞安赛飞安赛飞安赛飞很高123123123安赛飞看阿东嫩啊等是哦啊额捐款阿灿附着奥赛晶立方阿囧订了饭安赛飞";
//    cell.contentLabel.font      = [UIFont systemFontOfSize:14];
//    cell.contentLabel.textColor = [UIColor colorWithHex:0x4E5973 alpha:0.80f];
//    cell.contentLabel.textAlignment = NSTextAlignmentLeft;
    
//    cell.attributedLabel.shadowColor = [UIColor grayColor];
//    cell.attributedLabel.shadowOffset= CGSizeMake(1, 1);
//    cell.attributedLabel.shadowBlur = 1;
    
//    [cell.contentLabel appendImage:[UIImage imageNamed:@"stan"] maxSize:CGSizeMake(396, 396)];
//        [cell.contentLabel appendImage:[UIImage imageNamed:@"heart"] maxSize:CGSizeMake(20, 20)];
    
    return cell;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self send];
        return NO;
    }
    
    return YES;
}

- (void)send {
    NSLog(@"send");
}


#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"ChatMyselfTableViewCell" bundle:nil] forCellReuseIdentifier:myselfCellId];
        [_tableView registerNib:[UINib nibWithNibName:@"ChatOthersTableViewCell" bundle:nil] forCellReuseIdentifier:othersCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithHex:0xF2F6FA alpha:0.77f];
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

- (ChatBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ChatBottomView" owner:nil options:nil].firstObject;
    }
    return _bottomView;
}


- (SIMPConnection *)connection {
    if (!_connection) {
        _connection = [SIMPConnection sharedConnection];
    }
    return _connection;
}

#pragma mark - SIMPConnectionDelegate

- (void)connection:(SIMPConnection *)connection didConnectToAdress:(NSData *)adress bySocket:(id)sock {
    NSLog(@"didConnectToAdress");
}
- (void)connection:(SIMPConnection *)connection didClosedWithError:(NSError *)error bySocket:(id)sock {
    NSLog(@"didClosedWithError");
}
- (void)connection:(SIMPConnection *)connection didSendData:(NSData *)data bySocket:(id)sock {
    NSLog(@"didSendData");
}
- (void)connection:(SIMPConnection *)connection didReceiveData:(NSData *)data bySocket:(id)sock {
    NSLog(@"didReceiveData");
}
- (void)connection:(SIMPConnection *)connection didSendDataFailedDueToError:(NSError *)err bySocket:(id)sock {
    NSLog(@"didSendDataFailedDueToError");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}

@end
