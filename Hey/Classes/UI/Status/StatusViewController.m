//
//  StatusViewController.m
//  Hey
//
//  Created by Ascen on 2017/1/13.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "StatusViewController.h"
#import "StatusViewModel.h"
#import "StatusTableViewCell.h"
#import "UIColor+Help.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <MJRefresh/MJRefresh.h>
#import <YYWebImage/YYWebImage.h>
#import "Status.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "StatusSendView.h"
#import <DateTools/NSDate+DateTools.h>
#import <Qiniu/QiniuSDK.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface StatusViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) StatusSendView *sendView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIAlertController *alertController;

@property (nonatomic, strong) StatusViewModel *viewModel;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL selectedImage;
    
@property (nonatomic, assign) BOOL fromMyStatus;

@end

@implementation StatusViewController

- (instancetype)initWithFromMyStatus:(BOOL)fromMyStatus {
    if (self = [super init]) {
        _fromMyStatus = fromMyStatus;
        _viewModel = [[StatusViewModel alloc] initWithFromMyStatus:fromMyStatus];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    
    [self setupView];
    [self bindData];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    
    if (!self.fromMyStatus) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    //上拉加载
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self) {
            [self.viewModel.fetchStatusCommand execute:nil];
        }
    }];
    [header setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"松开加载更多" forState:MJRefreshStatePulling];
    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
    self.tableView.mj_header = header;
    
    [self.sendView.sendButton setTitleColor:[UIColor colorWithHex:0x0080FF alpha:0.4f] forState:UIControlStateDisabled];
}

- (void)bindData {
    @weakify(self)
    [[RACObserve(self.viewModel, statuses) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
    }];
    
    [[self.viewModel.fetchStatusCommand.errors deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
    }];
    
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            [self.view addSubview:self.maskView];
            [self.view addSubview:self.sendView];
            self.sendView.center = self.view.center;
            self.sendView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
            [UIView animateWithDuration:0.25f animations:^{
                self.sendView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            }];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }] deliverOnMainThread];
    }];
    
    [[[self.sendView.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.maskView removeFromSuperview];
        [self.sendView removeFromSuperview];
    }];
    
    [[[self.viewModel.sendStatusCommand.executionSignals switchToLatest] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功啦~"];
        self.sendView.textView.text = @"";
       [self.sendView.imageButton setImage:nil forState:UIControlStateNormal];
    }];
    
    [[self.sendView.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
        uint64_t statusId = [[NSDate date] timeIntervalSince1970] - [[NSDate dateWithYear:2000 month:1 day:1] timeIntervalSince1970];
        @strongify(self)
        
        NSString *qiniuToken = @"tDr4Ga9QlnMTI5b7Mq30SApbRvmbJtieEgDTSS6t:dr25PzRVBmX7kotCTapvpvS4-HU=:eyJzY29wZSI6InRlc3QtY29udGVudCIsImRlYWRsaW5lIjoxNTk1OTEzMDg4fQ==";
        NSData *data = UIImageJPEGRepresentation(self.image, 0.1);
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.zone = [QNZone zone2];
        }];
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyddMMHHmmss";
        NSString *time = [formatter stringFromDate:now];
        NSString *imageName = [NSString stringWithFormat:@"image_%@",time];
        
        NSString *imageURL = [NSString stringWithFormat:@"http://on1svswrl.bkt.clouddn.com/%@",imageName];

        Status *status = [[Status alloc] init];
        status.Id = @(statusId);
        status.content = self.sendView.textView.text ?: @"";
        
        
        if (data) {
            status.imageScale = @(self.image.size.width / self.image.size.height);
            status.imageURL = imageURL;
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            [upManager putData:data key:imageName token:qiniuToken
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          @strongify(self)
                          if (info.statusCode == 200) {
                              NSLog(@"上传成功");
                              [self.viewModel.sendStatusCommand execute:status];
                          } else {
                              NSLog(@"上传失败");
                          }
                          
                      } option:nil];
        }
        else {
            [self.viewModel.sendStatusCommand execute:status];
        }
        
        
        [self.maskView removeFromSuperview];
        [self.sendView removeFromSuperview];
    }];
    
    [[[self.sendView.textView.rac_textSignal distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSString *text) {
        @strongify(self)
        self.sendView.placeholderLabel.hidden = text.length > 0;
        self.sendView.sendButton.enabled = text.length > 0;
    }];
    
    self.sendView.imageButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self)
            if (self.selectedImage) {
                [self presentViewController:self.alertController animated:YES completion:nil];
            }
            else {
                UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
                imagePickerVC.delegate = self;
                imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerVC.allowsEditing = NO;
                [self presentViewController:imagePickerVC animated:YES completion:nil];
            }
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
//    [[self.viewModel.likeStatusCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        [self.tableView reloadData];
//    }];
}

#pragma mark - others methods

- (UIImage *)setupImage:(UIImage *)image {
    CGSize size = image.size;
    // fix orientation
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (image.imageOrientation == UIImageOrientationRight) {
        transform = CGAffineTransformTranslate(transform, 0, size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        CGContextRef ctx = CGBitmapContextCreate(NULL, size.width, size.height,CGImageGetBitsPerComponent(image.CGImage), 0,CGImageGetColorSpace(image.CGImage),CGImageGetBitmapInfo(image.CGImage));
        CGContextConcatCTM(ctx, transform);
        CGContextDrawImage(ctx, CGRectMake(0,0,size.height, size.width), image.CGImage);
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        image = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
    }
    
    
    CGRect rect;
    if (size.width >= size.height) {
        rect = CGRectMake((size.width- size.height) * 0.5, 0, size.height, size.height);
    }
    else {
        rect = CGRectMake(0, (size.height - size.width) * 0.5, size.width, size.width);
    }
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect clipsBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(clipsBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipsBounds, subImageRef);
    UIImage *clipImage  = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return clipImage;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Status *status = self.viewModel.statuses[indexPath.row];
    CGFloat height = 0.0;
    CGFloat w;
    CGFloat h;
    
    CGRect rect = [status.content boundingRectWithSize:CGSizeMake(self.view.width - 2 * 15, 500) options:NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    if ([status.imageURL isEqualToString:@""] || status.imageURL == nil) {
        h = 0;
        height = h + 75 + rect.size.height + 15  + 15 + 44;
    }
    else {
        if (status.imageScale.floatValue >= 1.0f) {
            w = self.view.bounds.size.width - 2 * 15;
            h = w / status.imageScale.floatValue;
        }
        else {
            h = 300;
            w = h * status.imageScale.floatValue;
        }
        height = h + 75 + rect.size.height + 15  + 15 + 10 + 44;
    }
    
    return height;
}

#pragma mark - UITableViewDataSource
    
    

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatusTableViewCellId" forIndexPath:indexPath];
    Status *status = self.viewModel.statuses[indexPath.row];
    @weakify(self)
    cell.likeButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self.viewModel likeStatus:status];
        return [RACSignal empty];
    }];
    [cell setStatus:status];

    return cell;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.selectedImage = YES;
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *clipImage = [self setupImage:self.image];
    [self.sendView.imageButton setImage:clipImage forState:UIControlStateNormal];
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerNib:[UINib nibWithNibName:@"StatusTableViewCell" bundle:nil] forCellReuseIdentifier:@"StatusTableViewCellId"];
        [_tableView registerClass:[StatusTableViewCell class] forCellReuseIdentifier:@"StatusTableViewCellId"];
//        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    }
    return _tableView;
}

- (StatusSendView *)sendView {
    if (!_sendView) {
        _sendView = [[NSBundle mainBundle] loadNibNamed:@"StatusSendView" owner:nil options:nil].firstObject;
        _sendView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 60, 400);
    }
    return _sendView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    }
    return _maskView;
}

- (UIAlertController *)alertController {
    if (!_alertController) {
        @weakify(self)
        _alertController = [UIAlertController alertControllerWithTitle:nil message:@"你想干嘛" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            self.image = nil;
            self.selectedImage = NO;
            [self.sendView.imageButton setImage:nil forState:UIControlStateNormal];
        }];
        UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"更换图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
            imagePickerVC.delegate = self;
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerVC.allowsEditing = NO;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [_alertController addAction:deleteAction];
        [_alertController addAction:changeAction];
        [_alertController addAction:cancelAction];
    }
    return _alertController;
}

@end
