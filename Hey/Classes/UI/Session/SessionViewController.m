//
//  HeyViewController.m
//  Hey
//
//  Created by Ascen on 2017/1/13.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "SessionViewController.h"
#import "SessionTableViewCell.h"
#import "ChatViewController.h"
#import "SessionViewModel.h"
#import "Store.h"
#import "UserManager.h"
#import <YYWebImage/YYWebImage.h>



@interface SessionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) SessionViewModel *viewModel;

@end

@implementation SessionViewController


- (instancetype)init {
    if (self = [super init]) {
        _viewModel = [[SessionViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupTableView];
    [self bindData];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
}

- (void)bindData {
//    [[[[Store sharedStore].chatSessionSignal distinctUntilChanged] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
//       [self.tableView reloadData];
//    }];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatSession *session = self.viewModel.sessions[indexPath.row];
    User *user = [[UserManager sharedManager] getUserById:session.userId];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:user];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.sessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionTableViewCell *cell = [SessionTableViewCell cellWithTableView:tableView];
    ChatSession *session = self.viewModel.sessions[indexPath.row];
    cell.nameLabel.text = session.sessionName;
    [cell.iconImageView yy_setImageWithURL:[NSURL URLWithString:session.iconURL] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
    cell.timeLabel.text = session.time;
    cell.lastSentLabel.text = session.lastSentence;
    return cell;
}

#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"SessionTableViewCell" bundle:nil] forCellReuseIdentifier:kSessionTableViewCellId];
        _tableView.rowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    }
    return _tableView;
}

@end
