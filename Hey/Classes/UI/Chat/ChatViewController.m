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
#import "ChatViewModel.h"
#import "User.h"
#import "Store.h"
#import <YYWebImage/YYWebImage.h>
#import <DateTools/NSDate+DateTools.h>


@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ChatBottomView *bottomView;
@property (nonatomic, strong) SIMPConnection *connection;

@property (nonatomic, strong) ChatViewModel *viewModel;

@end

@implementation ChatViewController

- (instancetype)initWithUser:(User *)user {
    if (self = [super init]) {
        _viewModel = [[ChatViewModel alloc] initWithUser:user];
    }
    return self;
}

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
    self.bottomView.frame = CGRectMake(0, size.height - 56 - height, size.width, 56);
    self.tableView.transform = CGAffineTransformMakeTranslation(0, -height);
}

- (void)keyBoardHide:(NSNotification *)notification {
    CGSize size = self.view.bounds.size;
    self.bottomView.frame = CGRectMake(0, size.height - 56, size.width, 56);
    self.tableView.transform = CGAffineTransformMakeTranslation(0, 0);
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.chatRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    cell.contentLabel.text      = @"安赛飞安赛飞安赛飞安赛飞安赛飞安赛飞很高123123123安赛飞看阿东嫩啊等是哦啊额捐款阿灿附着奥赛晶立方阿囧订了饭安赛飞";
//    cell.contentLabel.font      = [UIFont systemFontOfSize:14];
//    cell.contentLabel.textColor = [UIColor colorWithHex:0x4E5973 alpha:0.80f];
//    cell.contentLabel.textAlignment = NSTextAlignmentLeft;
    
//    cell.attributedLabel.shadowColor = [UIColor grayColor];
//    cell.attributedLabel.shadowOffset= CGSizeMake(1, 1);
//    cell.attributedLabel.shadowBlur = 1;
    
//    [cell.contentLabel appendImage:[UIImage imageNamed:@"stan"] maxSize:CGSizeMake(396, 396)];
//        [cell.contentLabel appendImage:[UIImage imageNamed:@"heart"] maxSize:CGSizeMake(20, 20)];
    User *user = [[Store sharedStore].userSignal first];
    SIMPMessage *msg = self.viewModel.chatRecords[indexPath.row];
    if ([msg.fromUser isEqualToString:user.Id.stringValue]) {
        ChatMyselfTableViewCell *cell = [ChatMyselfTableViewCell cellWithTableView:tableView];
        if (msg.type == SIMPMessageTypeText) {
            cell.contentLabel.text = msg.content;
            cell.contentLabel.font      = [UIFont systemFontOfSize:14];
            cell.contentLabel.textColor = [UIColor colorWithHex:0x4E5973 alpha:0.80f];
            cell.timeLabel.text = [msg.time formattedDateWithFormat:@"HH:mm:ss"];
            cell.nameLabel.text = user.name;
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;
        }
        else if (msg.type == SIMPMessageTypeImage) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView yy_setImageWithURL:[NSURL URLWithString:msg.imageURL] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
            [cell.contentLabel appendView:imageView];
        }
        return cell;
    } else {
        ChatOthersTableViewCell *cell = [ChatOthersTableViewCell cellWithTableView:tableView];
        if (msg.type == SIMPMessageTypeText) {
            cell.contentLabel.text = msg.content;
            cell.contentLabel.font      = [UIFont systemFontOfSize:14];
            cell.contentLabel.textColor = [UIColor colorWithHex:0x4E5973 alpha:0.80f];
            cell.timeLabel.text = [msg.time formattedDateWithFormat:@"HH:mm:ss"];
            cell.nameLabel.text = user.name;
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;
        }
        else if (msg.type == SIMPMessageTypeImage) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView yy_setImageWithURL:[NSURL URLWithString:msg.imageURL] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
            [cell.contentLabel appendView:imageView];
        }
//        cell.attributedLabel.shadowColor = [UIColor grayColor];
//        cell.attributedLabel.shadowOffset= CGSizeMake(1, 1);
//        cell.attributedLabel.shadowBlur = 1;
        return cell;
    }
    
    
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
    if (self.bottomView.textView.text == nil
        || [self.bottomView.textView.text isEqualToString:@""]) {
        return;
    }
    
    User *fromUser = [[Store sharedStore].userSignal first];
    SIMPMessage *msg = [[SIMPMessage alloc] initWithType:SIMPMessageTypeText];
    msg.content = self.bottomView.textView.text;
    msg.time = [NSDate date];
    msg.fromUser = fromUser.Id.stringValue;
    msg.toUser = self.viewModel.user.Id.stringValue;
    [self.connection sendMessage:msg];
    [self.viewModel.chatRecords addObject:msg];
    self.bottomView.textView.text = @"";
    [self.tableView reloadData];
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
        _tableView.backgroundColor = [UIColor colorWithHex:0xF2F6FA];
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
- (void)connection:(SIMPConnection *)connection didSendMessageBySocket:(id)sock {
    NSLog(@"didSendMessage");
}

- (void)connection:(SIMPConnection *)connection didReceiveMessage:(SIMPMessage *)msg bySocket:(id)sock {
    [self.viewModel.chatRecords addObject:msg];
    [self.tableView reloadData];
    NSLog(@"-----didReceiveMessage \n %@ \n %@ \n %@ \n %@",msg.content, msg.fromUser, msg.toUser, [msg.time formattedDateWithFormat:@"hh:MM:ss"]);
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
