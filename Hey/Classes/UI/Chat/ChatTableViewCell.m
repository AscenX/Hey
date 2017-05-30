//
//  ChatTableViewCell.m
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "Store.h"
#import <YYWebImage/YYWebImage.h>
#import "UIColor+Help.h"

#define kLabelMargin 10.f
#define kLabelTopMargin 8.f
#define kLabelBottomMargin 8.f

#define kChatCellItemMargin 15.f

#define kChatCellIconImageViewWH 35.f

#define kMaxContainerWidth 220.f
#define kMaxLabelWidth (kMaxContainerWidth - kLabelMargin * 2)

#define kMaxChatImageViewWidth 200.f
#define kMaxChatImageViewHeight 200.f

NSString *const kChatTableViewCellId = @"ChatTableViewCellId";

@interface ChatTableViewCell () <MLEmojiLabelDelegate>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *containerBackgroundView;
@property (nonatomic, strong) MLEmojiLabel *label;

@property (nonatomic, strong) UIImageView *messageImageView;
//@property (nonatomic, strong) UIImageView *maskImageView;

@end

@implementation ChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    _iconButton = [UIButton new];
    _iconButton.layer.masksToBounds = YES;
    _iconButton.layer.cornerRadius = 17.5f;
    [self.contentView addSubview:_iconButton];
    
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _label = [MLEmojiLabel new];
    _label.delegate = self;
    _label.font = [UIFont systemFontOfSize:14.0f];
    _label.numberOfLines = 0;
    _label.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _label.isAttributedContent = YES;
    _label.textColor = [UIColor colorWithHex:0x4E5973 alpha:0.80f];
    [_container addSubview:_label];
    
    _messageImageView = [[UIImageView alloc] init];
    [_container addSubview:_messageImageView];
    
    _containerBackgroundView = [UIView new];
    [_container insertSubview:_containerBackgroundView atIndex:0];
    
//    _maskImageView = [UIImageView new];
    
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    // 设置containerBackgroundImageView填充父view
    _containerBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
}

- (void)setChatRecord:(ChatRecord *)chatRecord {
    _chatRecord = chatRecord;
    
    _label.text = chatRecord.content;
    
    [self setMessageOriginWithChatRecord:chatRecord];
    
    if ([chatRecord.type isEqualToString:@"image"]) { // 有图片的先看下设置图片自动布局
        
        // cell重用时候清除只有文字的情况下设置的container宽度自适应约束
        [self.container clearAutoWidthSettings];
        self.messageImageView.hidden = NO;
        
        UIImage *localImage = [[YYImageCache sharedCache] getImageForKey:chatRecord.imageURL];
        
        // 根据图片的宽高尺寸设置图片约束
        CGFloat widthHeightRatio = 0;
        if (localImage) {
            self.messageImageView.image = localImage;
            CGFloat h = localImage.size.height;
            CGFloat w = localImage.size.width;
            
            if (w > kMaxChatImageViewWidth || w > kMaxChatImageViewHeight) {
                
                widthHeightRatio = chatRecord.imageScale.floatValue;
                
                if (widthHeightRatio > 1.0f) {
                    w = kMaxChatImageViewWidth;
                    h = w / widthHeightRatio;
                }
                else {
                    h = kMaxChatImageViewHeight;
                    w = h * widthHeightRatio;
                }
            }
            
            self.messageImageView.size = CGSizeMake(w, h);
            _container.sd_layout.widthIs(w).heightIs(h);
        }
        else {
//            [self.messageImageView yy_setImageWithURL:[NSURL URLWithString:chatRecord.imageURL] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
            [self.messageImageView yy_setImageWithURL:[NSURL URLWithString:chatRecord.imageURL] placeholder:[UIImage imageNamed:@"icon_placeholder"] options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                self.messageImageView.image = image;
            }];
            widthHeightRatio = chatRecord.imageScale.floatValue;
            
            CGFloat h;
            CGFloat w;
            if (widthHeightRatio > 1.0f) {
                w = kMaxChatImageViewWidth;
                h = w / widthHeightRatio;
            }
            else {
                h = kMaxChatImageViewHeight;
                w = h * widthHeightRatio;
            }
            self.messageImageView.size = CGSizeMake(w, h);
            _container.sd_layout.widthIs(w).heightIs(h);
        }
        
        
        // 设置container以messageImageView为bottomView高度自适应
        [_container setupAutoHeightWithBottomView:self.messageImageView bottomMargin:0];
        
        // container按照maskImageView裁剪
//        self.container.layer.mask = self.maskImageView.layer;
        
//        __weak typeof(self) weakself = self;
        [_containerBackgroundView setDidFinishAutoLayoutBlock:^(CGRect frame) {
            // 在_containerBackgroundImageView的frame确定之后设置maskImageView的size等于containerBackgroundImageView的size
//            weakself.maskImageView.size = frame.size;
        }];
        
        self.messageImageView.layer.masksToBounds = YES;
        self.messageImageView.layer.cornerRadius = 5.0f;
        
    }
    else if ([chatRecord.type isEqualToString:@"text"]) { // 没有图片有文字情况下设置文字自动布局
        
        // 清除展示图片时候用到的mask
//        [_container.layer.mask removeFromSuperlayer];
        _container.backgroundColor = [UIColor clearColor];
        self.messageImageView.hidden = YES;
        
        // 清除展示图片时候_containerBackgroundImageView用到的didFinishAutoLayoutBlock
        _containerBackgroundView.didFinishAutoLayoutBlock = nil;
        
        _label.sd_resetLayout
        .leftSpaceToView(_container, kLabelMargin)
        .topSpaceToView(_container, kLabelTopMargin)
        .autoHeightRatio(0); // 设置label纵向自适应
        
        // 设置label横向自适应
        [_label setSingleLineAutoResizeWithMaxWidth:kMaxContainerWidth];
        
        // container以label为rightView宽度自适应
        [_container setupAutoWidthWithRightView:_label rightMargin:kLabelMargin];
        
        // container以label为bottomView高度自适应
        [_container setupAutoHeightWithBottomView:_label bottomMargin:kLabelBottomMargin];
        

        
        // container按照maskImageView裁剪
        //        self.container.layer.mask = self.maskImageView.layer;
        
        //        __weak typeof(self) weakself = self;
        [_containerBackgroundView setDidFinishAutoLayoutBlock:^(CGRect frame) {
            // 在_containerBackgroundImageView的frame确定之后设置maskImageView的size等于containerBackgroundImageView的size
            //            weakself.maskImageView.size = frame.size;
        }];
        
    }
}


- (void)setMessageOriginWithChatRecord:(ChatRecord *)chatRecord
{
    User *user = [[Store sharedStore].userSignal first];
    if (chatRecord.fromUserId.integerValue == user.Id.integerValue) {
        // 发出去的消息设置居右样式
        self.iconButton.sd_resetLayout
        .rightSpaceToView(self.contentView, kChatCellItemMargin)
        .topSpaceToView(self.contentView, kChatCellItemMargin)
        .widthIs(kChatCellIconImageViewWH)
        .heightIs(kChatCellIconImageViewWH);
        
        _container.sd_resetLayout.topEqualToView(self.iconButton).rightSpaceToView(self.iconButton, kChatCellItemMargin);
    }
    else {
        // 收到的消息设置居左样式
        self.iconButton.sd_resetLayout
        .leftSpaceToView(self.contentView, kChatCellItemMargin)
        .topSpaceToView(self.contentView, kChatCellItemMargin)
        .widthIs(kChatCellIconImageViewWH)
        .heightIs(kChatCellIconImageViewWH);
        
        _container.sd_resetLayout.topEqualToView(self.iconButton).leftSpaceToView(self.iconButton, kChatCellItemMargin);
        
    }
    _containerBackgroundView.backgroundColor = [UIColor whiteColor];
    _containerBackgroundView.layer.masksToBounds = YES;
    _containerBackgroundView.layer.cornerRadius = 5;
    
//    _maskImageView.image = _containerBackgroundView.image;
}


#pragma mark - MLEmojiLabelDelegate

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (self.didSelectLinkTextOperationBlock) {
        self.didSelectLinkTextOperationBlock(link, type);
    }
}

@end
