//
//  ALAssetsLibrary+DWKKit.h
//  DWKKit
//
//  Created by pisen on 16/10/12.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (DWKKit)

- (void)saveImage:(UIImage*)image
           toAlum:(NSString*)albumName
       completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
          failure:(ALAssetsLibraryAccessFailureBlock)failure;

- (void)saveVideo:(NSURL*)videoUrl
           toAlum:(NSString*)albumName
       completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
          failure:(ALAssetsLibraryAccessFailureBlock)failure;

- (void)saveImageData:(NSData*)imageData
           toAlum:(NSString*)albumName
         metadata:(NSDictionary*)metadata
       completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
          failure:(ALAssetsLibraryAccessFailureBlock)failure;

- (void)addAssetURL:(NSURL*)assetUrl
           toAlum:(NSString*)albumName
       completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
          failure:(ALAssetsLibraryAccessFailureBlock)failure;


- (void)loadAssetsForProperty:(NSString*)property
                    fromAlbum:(NSString*)albumName
                   completion:(void (^)(NSMutableArray *array, NSError *error))completion;

- (void)loadImagesFromAlbum:(NSString *)albumName
                 completion:(void (^)(NSMutableArray *images, NSError *error))completion;
@end
