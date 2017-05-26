//
//  ContactsViewController.m
//  Hey
//
//  Created by Ascen on 2017/1/13.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsViewModel.h"
#import <YYWebImage/YYWebImage.h>
#import "ContactsTableViewCell.h"
#import "UserInfoViewController.h"
#import "User.h"

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ContactsViewModel *viewModel;

@end

@implementation ContactsViewController

- (instancetype)init {
    if (self = [super init]) {
        _viewModel = [[ContactsViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewModel.fetchContactsCommand execute:nil];
    
    [self addView];
    [self bindViewModel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)addView {
    [self.view addSubview:self.tableView];
}

- (void)bindViewModel {
    @weakify(self)
    [[[RACObserve(self.viewModel, contacts) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *user = self.viewModel.contacts[indexPath.row];
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithUser:user];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDataSource

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.viewModel sectionIndexString];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return self.viewModel.contacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactsTableViewCell *cell = [ContactsTableViewCell cellWithTableView:tableView];
    [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[self.viewModel avatarWithIndex:indexPath.row]] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
    cell.nameLabel.text = [self.viewModel nameWithIndex:indexPath.row];
    return cell;
}


#pragma mark - lazy laod

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ContactsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactsTableViewCellID"];
        _tableView.rowHeight = 66;
        
    }
    return _tableView;
}

@end
