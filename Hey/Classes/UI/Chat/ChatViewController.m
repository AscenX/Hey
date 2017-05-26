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


@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SIMPConnectionDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ChatBottomView *bottomView;
@property (nonatomic, strong) SIMPConnection *connection;

@property (nonatomic, strong) ChatViewModel *viewModel;

@property (nonatomic, assign) BOOL keyboardShowed;

@end

@implementation ChatViewController

- (instancetype)initWithUser:(User *)user {
    if (self = [super init]) {
        _viewModel = [[ChatViewModel alloc] initWithUser:user];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.connection.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.connection.delegate = nil;
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
    self.keyboardShowed = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    CGSize size = self.view.bounds.size;
    self.bottomView.frame = CGRectMake(0, size.height - 56 - height, size.width, 56);
    self.tableView.transform = CGAffineTransformMakeTranslation(0, -height);
    [self scrollTableToFoot:YES];
}

- (void)keyBoardHide:(NSNotification *)notification {
    self.keyboardShowed = NO;
    CGSize size = self.view.bounds.size;
    self.bottomView.frame = CGRectMake(0, size.height - 56, size.width, 56);
    self.tableView.transform = CGAffineTransformMakeTranslation(0, 0);
    [self scrollTableToFoot:YES];
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.chatRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    User *user = [[Store sharedStore].userSignal first];
    ChatRecord *chatRecord = self.viewModel.chatRecords[indexPath.row];
    if (chatRecord.fromUserId.integerValue == user.Id.integerValue) {
        ChatMyselfTableViewCell *cell = [ChatMyselfTableViewCell cellWithTableView:tableView];
        [cell.iconButton yy_setBackgroundImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"icon_placeholder"]];
        
        if (chatRecord.chatRecordType == ChatRecordTypeText) {
            cell.contentLabel.text = chatRecord.content;
            cell.contentLabel.font      = [UIFont systemFontOfSize:14];
            cell.contentLabel.textColor = [UIColor colorWithHex:0x4E5973 alpha:0.80f];
            cell.timeLabel.text = chatRecord.time;
            cell.nameLabel.text = user.name;
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;
        }
        else if (chatRecord.chatRecordType == ChatRecordTypeImage) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView yy_setImageWithURL:[NSURL URLWithString:chatRecord.imageURL] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
            [cell.contentLabel appendView:imageView];
        }
        return cell;
    } else {
        ChatOthersTableViewCell *cell = [ChatOthersTableViewCell cellWithTableView:tableView];
        [cell.iconButton yy_setBackgroundImageWithURL:[NSURL URLWithString:self.viewModel.user.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"icon_placeholder"]];
        cell.nameLabel.text = self.viewModel.user.name;
        if (chatRecord.chatRecordType == ChatRecordTypeText) {
            cell.contentLabel.text = chatRecord.content;
            cell.contentLabel.font      = [UIFont systemFontOfSize:14];
            cell.contentLabel.textColor = [UIColor colorWithHex:0x4E5973 alpha:0.80f];
            cell.timeLabel.text = chatRecord.time;
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;
        }
        else if (chatRecord.chatRecordType == ChatRecordTypeImage) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView yy_setImageWithURL:[NSURL URLWithString:chatRecord.imageURL] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
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
    uint64_t messageId = [[NSDate date] timeIntervalSince1970] - [[NSDate dateWithYear:2000 month:1 day:1] timeIntervalSince1970];
    [msg setMessageId:messageId];
    [msg setContent:self.bottomView.textView.text];
    [msg setTime:[NSDate date]];
    [msg setFromUser:fromUser.Id.stringValue];
    [msg setToUser:self.viewModel.user.Id.stringValue];
    [self.connection sendMessage:msg];
    self.bottomView.textView.text = @"";
    ChatRecord *chatRecord = [[ChatRecord alloc] initWithSIMPMessage:msg];
    [self.viewModel.chatRecords addObject:chatRecord];
    [[Store sharedStore] updateChatRecords:self.viewModel.chatRecords];
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
    NSLog(@"didConnectToAdressbySocket:%@", sock);
}
- (void)connection:(SIMPConnection *)connection didClosedWithError:(NSError *)error bySocket:(id)sock {
    NSLog(@"didClosedWithErrorbySocket:%@", sock);
}
- (void)connection:(SIMPConnection *)connection didSendMessageBySocket:(id)sock {
    NSLog(@"didSendMessageBySocket:%@", sock);
}

- (void)connection:(SIMPConnection *)connection didReceiveMessage:(SIMPMessage *)msg bySocket:(id)sock {
    
    ChatRecord *chatRecord = [[ChatRecord alloc] initWithSIMPMessage:msg];
    [self.viewModel.chatRecords addObject:chatRecord];
    [self.tableView reloadData];
    [self scrollTableToFoot:YES];
    [[Store sharedStore] updateChatRecords:self.viewModel.chatRecords];
}

- (void)connection:(SIMPConnection *)connection didSendMessageFailedDueToError:(NSError *)err bySocket:(id)sock {
    NSLog(@"didSendDataFailedDueToErrorbySocket:%@", sock);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}



@end
