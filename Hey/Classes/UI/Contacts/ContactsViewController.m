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
    
    [self addView];
    [self bindViewModel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
    [self.viewModel.fetchContactsCommand execute:nil];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCellId" forIndexPath:indexPath];
    [cell.imageView yy_setImageWithURL:[NSURL URLWithString:[self.viewModel avatarWithIndex:indexPath.row]] placeholder:[UIImage new]];
    cell.textLabel.text = [self.viewModel nameWithIndex:indexPath.row];
    return cell;
}

#pragma mark - lazy laod

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ContactsTableViewCellId"];
    }
    return _tableView;
}

@end
