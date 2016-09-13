//
//  PSKNetworkingAdapter.m
//  PisenKit
//
//  Created by 杨胜超 on 16/7/5.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PSKNetworkingAdapter.h"

@implementation PSKNetworkingAdapter

+ (instancetype)adapter {
    id object = [NSClassFromString(@"PSKNetworkingAFN") new];
    if ( ! [object respondsToSelector:@selector(dataTaskWithUrl:apiName:normalParams:httpHeaderParams:imageData:requestType:completionHandler:)]) {
        return nil;
    }
    PSKNetworkingAdapter *networkingAdapter = [PSKNetworkingAdapter new];
    networkingAdapter.delegate = object;
    return networkingAdapter;
}

@end
