//
//  ChatViewController.m
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatViewController.h"
#import "UIColor+Help.h"
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
#import <Qiniu/QiniuSDK.h>
#import "ChatTableViewCell.h"


@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, SIMPConnectionDelegate>

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
    self.title = self.viewModel.user.name;
    self.view.backgroundColor = [UIColor colorWithHex:0xF2F6FA alpha:0.77f];
    
    [self addView];
    [self defineLayout];
    [self bindData];
    
    [self scrollTableToFoot:NO];
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
    
    [[[self.bottomView.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.delegate = self;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerVC.allowsEditing = NO;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
}

#pragma mark - operating methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
    
    Viewer *viewer = [[Store sharedStore].viewerSignal first];
    NSMutableArray *sessions = [NSMutableArray array];
    ChatSession *session = [[ChatSession alloc] initWithUser:self.viewModel.user];
    for (int i = 0; i < viewer.chatSessions.count; ++i) {
        ChatSession *s = viewer.chatSessions[i];
        if (![s isEqualToSession:session]) {
            [sessions addObject:s];
        }
    }
    session.lastSentence = chatRecord.content;
    [sessions insertObject:session atIndex:0];
    [[Store sharedStore] updateSessions:sessions];
}

- (void)sendImage:(UIImage *)image {
//    Viewer *viewer = [[Store sharedStore].viewerSignal first];
    NSString *qiniuToken = @"tDr4Ga9QlnMTI5b7Mq30SApbRvmbJtieEgDTSS6t:dr25PzRVBmX7kotCTapvpvS4-HU=:eyJzY29wZSI6InRlc3QtY29udGVudCIsImRlYWRsaW5lIjoxNTk1OTEzMDg4fQ==";
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone2];
    }];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyddMMHHmmss";
    NSString *time = [formatter stringFromDate:now];
    NSString *imageName = [NSString stringWithFormat:@"image_%@",time];
    
    NSString *imageURL = [NSString stringWithFormat:@"http://on1svswrl.bkt.clouddn.com/%@",imageName];
    User *fromUser = [[Store sharedStore].userSignal first];
    SIMPMessage *msg = [[SIMPMessage alloc] initWithType:SIMPMessageTypeImage];
    uint64_t messageId = [[NSDate date] timeIntervalSince1970] - [[NSDate dateWithYear:2000 month:1 day:1] timeIntervalSince1970];
    [msg setMessageId:messageId];
    [msg setImageScale:image.size.width / image.size.height];
    [msg setTime:[NSDate date]];
    [msg setImageURL:imageURL];
    [msg setFromUser:fromUser.Id.stringValue];
    [msg setToUser:self.viewModel.user.Id.stringValue];
    
    [[YYImageCache sharedCache] setImage:image forKey:imageURL];
    
    ChatRecord *chatRecord = [[ChatRecord alloc] initWithSIMPMessage:msg];
    [self.viewModel.chatRecords addObject:chatRecord];
    [[Store sharedStore] updateChatRecords:self.viewModel.chatRecords];
    [self.tableView reloadData];
    
    Viewer *viewer = [[Store sharedStore].viewerSignal first];
    NSMutableArray *sessions = [NSMutableArray array];
    ChatSession *session = [[ChatSession alloc] initWithUser:self.viewModel.user];
    for (int i = 0; i < viewer.chatSessions.count; ++i) {
        ChatSession *s = viewer.chatSessions[i];
        if (![s isEqualToSession:session]) {
            [sessions addObject:s];
        }
    }
    session.lastSentence = @"[图片]";
    [sessions insertObject:session atIndex:0];
    [[Store sharedStore] updateSessions:sessions];
    
    @weakify(self)
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    [upManager putData:data key:imageName token:qiniuToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  @strongify(self)
                  if (info.statusCode == 200) {
                      [self.connection sendMessage:msg];
                  } else {
                      NSLog(@"上传失败");
                  }
                  
              } option:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:self.viewModel.chatRecords[indexPath.row] keyPath:@"chatRecord" cellClass:[ChatTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.chatRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    User *user = [[Store sharedStore].userSignal first];
    ChatRecord *chatRecord = self.viewModel.chatRecords[indexPath.row];

    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatTableViewCellId forIndexPath:indexPath];
    [cell setChatRecord:chatRecord];
    if (chatRecord.fromUserId.integerValue == user.Id.integerValue) {
        [cell.iconButton yy_setBackgroundImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"icon_placeholder"]];
    }
    else {
        [cell.iconButton yy_setBackgroundImageWithURL:[NSURL URLWithString:self.viewModel.user.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"icon_placeholder"]];
    }
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self sendImage:image];
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - SIMPConnectionDelegate

- (void)connection:(SIMPConnection *)connection didConnectToAddress:(NSData *)address bySocket:(id)sock {
    NSLog(@"didConnectToAdress--%@--bySocket:%@", address,sock);
}
- (void)connection:(SIMPConnection *)connection didClosedWithError:(NSError *)error bySocket:(id)sock {
    NSLog(@"didClosedWithErrorBySocket:%@--error--%@", sock,error.localizedDescription);
}
- (void)connection:(SIMPConnection *)connection didSendMessageBySocket:(id)sock {
    NSLog(@"didSendMessageBySocket:%@", sock);
}

- (void)connection:(SIMPConnection *)connection didReceiveMessage:(SIMPMessage *)msg bySocket:(id)sock {
    
    NSLog(@"didReceiveMessage--%@", msg.content);
    ChatRecord *chatRecord = [[ChatRecord alloc] initWithSIMPMessage:msg];
    [self.viewModel.chatRecords addObject:chatRecord];
    [self.tableView reloadData];
    [self scrollTableToFoot:YES];
    [[Store sharedStore] updateChatRecords:self.viewModel.chatRecords];
}

- (void)connection:(SIMPConnection *)connection didSendMessageFailedDueToError:(NSError *)err bySocket:(id)sock {
    NSLog(@"didSendDataFailedDueToErrorbySocket:%@", sock);
}



#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:kChatTableViewCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithHex:0xF2F6FA];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
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



@end
