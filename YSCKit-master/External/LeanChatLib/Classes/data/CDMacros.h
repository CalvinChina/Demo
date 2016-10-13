//
//  CDMacros.h
//  LeanChatLib
//
//  Created by lzw on 15/7/13.
//  Copyright (c) 2015年 lzwjava@LeanCloud QQ: 651142978. All rights reserved.
//

#ifndef LeanChatLib_CDMacros_h
#define LeanChatLib_CDMacros_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#   define DLog(...)
#endif


#ifndef WEAKSELF
#define WEAKSELF  typeof(self) __weak weakSelf = self;
#endif


#endif
