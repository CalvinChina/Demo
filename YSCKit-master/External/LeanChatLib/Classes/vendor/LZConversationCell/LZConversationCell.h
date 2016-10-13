//
//  LeanChatConversationTableViewCell.h
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/17.
//  Copyright (c) 2015年 lzwjava QQ: 651142978
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

@interface LZConversationCell : UITableViewCell

+ (CGFloat)heightOfCell;

+ (LZConversationCell *)dequeueOrCreateCellByTableView :(UITableView *)tableView;

+ (void)registerCellToTableView: (UITableView *)tableView ;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel  *messageTextLabel;
@property (nonatomic, strong) JSBadgeView *badgeView;
@property (nonatomic, strong) UIView *litteBadgeView;
@property (nonatomic, strong) UILabel *timestampLabel;


@end
