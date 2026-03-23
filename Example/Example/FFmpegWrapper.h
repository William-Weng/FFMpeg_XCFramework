//
//  FFmpegWrapper.h
//  Example
//
//  Created by iOS on 2026/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFmpegWrapper : NSObject

+ (NSTimeInterval)getDurationOfVideoAtURL: (NSURL *)url;

@end

NS_ASSUME_NONNULL_END
