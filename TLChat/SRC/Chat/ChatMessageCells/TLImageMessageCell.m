//
//  TLImageMessageCell.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/14.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLImageMessageCell.h"
#import "TLMessageImageView.h"

#define     MSG_SPACE_TOP       2

@interface TLImageMessageCell ()

@property (nonatomic, strong) TLMessageImageView *msgImageView;

@end

@implementation TLImageMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgImageView];
    }
    return self;
}

- (void)setMessage:(TLMessage *)message
{
    if (self.message && [self.message.messageID isEqualToString:message.messageID]) {
        return;
    }
    TLMessageOwnerType lastOwnType = self.message ? self.message.ownerTyper : -1;
    [super setMessage:message];
    
    if (message.imagePath) {
        NSString *imagePath = [NSFileManager pathUserChatAvatar:message.imagePath forUser:message.userID];
        [self.msgImageView setThumbnailPath:imagePath highDefinitionImageURL:message.imageURL];
    }
    else {
        [self.msgImageView setThumbnailPath:nil highDefinitionImageURL:message.imageURL];
    }

    if (lastOwnType != message.ownerTyper) {
        if (message.ownerTyper == TLMessageOwnerTypeSelf) {
            [self.msgImageView setBackgroundImage:[UIImage imageNamed:@"message_sender_bg"]];
            [self.msgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.messageBackgroundView);
                make.right.mas_equalTo(self.messageBackgroundView);
            }];
        }
        else if (message.ownerTyper == TLMessageOwnerTypeFriend){
            [self.msgImageView setBackgroundImage:[UIImage imageNamed:@"message_receiver_bg"]];
            [self.msgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.messageBackgroundView);
                make.left.mas_equalTo(self.messageBackgroundView);
            }];
        }
    }
    [self.msgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(message.frame.contentSize);
    }];
}

#pragma mark - Getter -
- (TLMessageImageView *)msgImageView
{
    if (_msgImageView == nil) {
        _msgImageView = [[TLMessageImageView alloc] init];
    }
    return _msgImageView;
}

@end
