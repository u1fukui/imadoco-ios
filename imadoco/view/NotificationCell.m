//
//  NotificationyCell.m
//  imadoco
//
//  Created by u1 on 2013/07/20.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "NotificationCell.h"
#import "Notification.h"
#import "FlatUIKit.h"

@interface NotificationCell()

@property (strong, nonatomic) UILabel *createdTimeLabel;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@end


@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 名前
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,
                                                                       3.0f,
                                                                       150.0f,
                                                                       20.0f)];
        self.userNameLabel.backgroundColor = [UIColor clearColor];
        self.userNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [self addSubview:self.userNameLabel];
        
        // メッセージ
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,
                                                                      24.0f,
                                                                      150.0f,
                                                                      20.0f)];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font = [UIFont systemFontOfSize:14.0f];
        self.messageLabel.textColor = [UIColor grayColor];
        [self addSubview:self.messageLabel];
        
        // 受信日時
        self.createdTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,
                                                                          45.0f,
                                                                          150.0f,
                                                                          20.0f)];
        self.createdTimeLabel.backgroundColor = [UIColor clearColor];
        self.createdTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        self.createdTimeLabel.textColor = [UIColor greenSeaColor];
        [self addSubview:self.createdTimeLabel];
        
        // アクセサリ
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // ハイライト無効
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Class Method

+ (CGFloat)cellHeight
{
    return 68.0f;
}

#pragma mark - Public Method

- (void)setNotificationInfo:(Notification *)notification
{
    self.userNameLabel.text = notification.name;
    self.messageLabel.text = notification.message;
    self.createdTimeLabel.text = notification.updatedAt;
}

@end
