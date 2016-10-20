//
//  FileDownloadModel.m
//
//  Created by pisen on 16/1/22.
//  Copyright © 2016年 zbx. All rights reserved.
//

#import "FileDownloadModel.h"

@implementation FileDownloadModel

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _downloadStartDate = @"";
        
        _fileName = @"";
        
        _url = @"";
        
        _orignalCount = @"";
        
        _downloadProgress = @"";
        
        _downloadState = @"";
        
        _downloadID = @"";
        
        _savePath = @"";
        
        _cachePath = @"";
        
        _downloadEndDate = @"";
        
        _fileType = @"0";
        
        _fromUrl = @"";
        
        _qualityName = @"";
        
        _curFileSize = @"";
        
        _urlCount = @"";
        
        _coverUrl = @"";
        
        _jsonStr = @"";
        
        _curSegmental = @"";
        
        _fileSuffix = @"";
        
        _programId = @"";
        
        _programType = @"";
        
        _episode = @"";
        
        _curSegmental = @"0";
        
        _website = @"0";
        
        _hiddenType = @"0";
        
        _br = @"0";
    }
    
    return self;
}

- (void)dealloc {
    
    _delegate = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

- (void)progressChange:(NSProgress*)pro {
    
    self.progress = pro;
    
    if (_delegate&&[_delegate respondsToSelector:@selector(handleDownloadProgress:)]) {
        
        [_delegate handleDownloadProgress:self];
    }
}

- (void)progressChange_ASI:(CGFloat)pro {
    
    self.downloadProgress = [NSString stringWithFormat:@"%f", pro];
    
    if (_delegate&&[_delegate respondsToSelector:@selector(handleDownloadProgress:)]) {
        
        [_delegate handleDownloadProgress:self];
    }
}

- (void)progressFinish {
    
    self.downloadState = @"2";
    
    if (_delegate&&[_delegate respondsToSelector:@selector(handleDownloadFinish:)]) {
        
        [_delegate handleDownloadFinish:self];
    }
}

- (void)progressFail {
    
    if (_delegate&&[_delegate respondsToSelector:@selector(handleDownloadFail:)]) {
        
        [_delegate handleDownloadFail:self];
    }
}

-(NSString*)savePath {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentPath=[paths lastObject];
    
    NSLog(@"%@",documentPath);
    
    NSString *fileDir = @"";
    
    NSString *fullPath = @"";
    
    if ([_fileType integerValue] == 1) {
        
        
        fileDir = [documentPath stringByAppendingPathComponent:@"ysj_cache"];

        fullPath = [fileDir stringByAppendingPathComponent:_downloadID];
    }
    else {
        
        fileDir = [documentPath stringByAppendingPathComponent:@"download"];
        
        fullPath = [fileDir stringByAppendingPathComponent:_fileName];
    }
  
    
    return fullPath;
    
}
@end
