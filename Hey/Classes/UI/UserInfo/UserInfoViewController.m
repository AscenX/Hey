//
//  UserInfoViewController.m
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoViewModel.h"
#import "UserInfoTableViewCell.h"
#import <YYWebImage/YYWebImage.h>
#import "ProfileHeaderView.h"
#import "UserInfoFooterView.h"
#import "UIColor+Help.h"
#import "User.h"
#import "ChatViewController.h"
#import "ChatSession.h"
#import "Store.h"

@interface UserInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ProfileHeaderView *headerView;
@property (nonatomic, strong) UserInfoFooterView *footerView;

@property (nonatomic, strong) UserInfoViewModel *viewModel;

@end

@implementation UserInfoViewController

- (instancetype)initWithUser:(User *)user {
    if (self = [super init]) {
        _viewModel = [[UserInfoViewModel alloc] initWithUser:user];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细资料";
    self.view.backgroundColor = [UIColor colorWithHex:0xCCC9CD];
    
    
    [self addView];
    [self bindViewModel];
    
}

- (void)addView {
    [self.view addSubview:self.tableView];
}

- (void)bindViewModel {
    [self.headerView.avatarImageView yy_setImageWithURL:[NSURL URLWithString: self.viewModel.imageURL] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
    self.headerView.nameLabel.text = self.viewModel.name;
    self.headerView.IdLabel.text = self.viewModel.userId;
    
    [[RACObserve(self.footerView.comeToChatButton, highlighted) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            self.footerView.comeToChatButton.backgroundColor = [UIColor colorWithHex:0x4990E2 alpha:0.6f];
        }
        else {
            self.footerView.comeToChatButton.backgroundColor = [UIColor colorWithHex:0x4990E2 alpha:1.0f];
        }
    }];
    
    [[[self.footerView.comeToChatButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        Viewer *viewer = [[Store sharedStore].viewerSignal first];
        NSMutableArray *sessions = [NSMutableArray array];
        ChatSession *session = [[ChatSession alloc] initWithUser:self.viewModel.user];
        for (int i = 0; i < viewer.chatSessions.count; ++i) {
            ChatSession *s = viewer.chatSessions[i];
            if (![s isEqualToSession:session]) {
                [sessions addObject:s];
            }
        }
        [sessions insertObject:session atIndex:0];
        [[Store sharedStore] updateSessions:sessions];
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:self.viewModel.user];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.viewModel.userInfo.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoTableViewCell *cell = [UserInfoTableViewCell cellWithTableView:tableView];
    if (self.viewModel.statusImages.count > 0) {
        NSString *image1string = self.viewModel.statusImages[0];
        [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:image1string] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
        
        NSString *image2string = self.viewModel.statusImages[1];
        if (image2string) {
            [cell.imageView2 yy_setImageWithURL:[NSURL URLWithString:image2string] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
        }
        
        NSString *image3string = self.viewModel.statusImages[2];
        if (image3string) {
            [cell.imageView3 yy_setImageWithURL:[NSURL URLWithString:image3string] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
        }
        
        NSString *image4string = self.viewModel.statusImages[3];
        if (image4string) {
            [cell.imageView4 yy_setImageWithURL:[NSURL URLWithString:image4string] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
        }
    }
    
    return cell;
}


#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.rowHeight = 80;
        [_tableView registerNib:[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoTableViewCellID"];
    }
    return _tableView;
}

- (ProfileHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:nil options:nil].firstObject;
    }
    return _headerView;
}

- (UserInfoFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"UserInfoFooterView" owner:nil options:nil].firstObject;
    }
    return _footerView;
}

@end
