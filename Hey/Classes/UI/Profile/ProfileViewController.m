//
//  ProfileViewController.m
//  Hey
//
//  Created by Ascen on 2017/1/13.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileViewModel.h"
#import "ProfileTableViewCell.h"
#import "ProfileTitleTableViewCell.h"
#import "ProfileHeaderView.h"
#import "Store.h"
#import "UIColor+Help.h"
#import "StatusViewController.h"
#import "AboutViewController.h"

#import <YYWebImage/YYWebImage.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ProfileHeaderView *headerView;

@property (nonatomic, strong) ProfileViewModel *viewModel;


@end

@implementation ProfileViewController

- (instancetype)init {
    if (self = [super init]) {
        _viewModel = [[ProfileViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xCCC9CD];
    
    [self addView];
    [self bindData];
}

- (void)addView {
    [self.view addSubview:self.tableView];
}

- (void)bindData {
    User *user = [Store sharedStore].userSignal.first;
    [self.headerView.avatarImageView yy_setImageWithURL:[NSURL URLWithString:user.avatar] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
    self.headerView.nameLabel.text = user.name;
    self.headerView.IdLabel.text = [NSString stringWithFormat:@"帐号: %@", user.Id];
    
    [[self.viewModel.logoutCommand.executionSignals deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        self.view.window.rootViewController = [[UIStoryboard storyboardWithName:@"LoginViewController" bundle:nil] instantiateInitialViewController];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIViewController *statusVC = [[StatusViewController alloc] initWithFromMyStatus:YES];
        [statusVC setTitle:@"我的动态"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:statusVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        UIViewController *aboutVC = [[AboutViewController alloc] init];
        [aboutVC setTitle:@"关于"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if (indexPath.section == self.viewModel.infos.count - 1) {
        [self.viewModel.logoutCommand execute:nil];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *infos = self.viewModel.infos[section];
    return infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *infos = self.viewModel.infos[indexPath.section];
    NSDictionary *info = infos[indexPath.row];
    NSString *icon = [info objectForKey:@"icon"];
    NSString *title = [info objectForKey:@"title"];
    
    if (indexPath.section == self.viewModel.infos.count - 1) {
        ProfileTitleTableViewCell *cell = [ProfileTitleTableViewCell cellWithTableView:tableView];
        return cell;
    } else {
        ProfileTableViewCell *cell = [ProfileTableViewCell cellWithTableView:tableView];
        cell.iconImageView.image = [UIImage imageNamed:icon];
        cell.titleLabel.text = title;
        return cell;;
    }
}

#pragma mark - lazy laod

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.rowHeight = 44;
        [_tableView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:kProfileTableViewCellId];
        [_tableView registerNib:[UINib nibWithNibName:@"ProfileTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfileTitleTableViewCellID"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (ProfileHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:nil options:nil].firstObject;
    }
    return _headerView;
}

@end
