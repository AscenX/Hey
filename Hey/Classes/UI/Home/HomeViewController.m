//
//  HeyViewController.m
//  Hey
//
//  Created by Ascen on 2017/1/13.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "ChatViewController.h"
#import "HomeViewModel.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) HomeViewModel *viewModel;

@end

@implementation HomeViewController


- (instancetype)init {
    if (self = [super init]) {
        _viewModel = [[HomeViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel updateSessions];
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *vc = [[ChatViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.sessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [HomeTableViewCell cellWithTableView:tableView];
//    cell.iconImageView.image = [UIImage imageNamed:@"stan"];
//    cell.nameLabel.text = @"Ascen";
//    cell.lastSentLabel.text = @"life is a struggle";
//    cell.timeLabel.text = @"昨天";
    return cell;
}

#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCellID"];
        _tableView.rowHeight = 54;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
