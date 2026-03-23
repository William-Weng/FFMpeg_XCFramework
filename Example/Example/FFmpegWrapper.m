//
//  FFMpegWrapper.m
//  Example
//
//  Created by iOS on 2026/3/20.
//

#import "FFmpegWrapper.h"
#import <libavformat/avformat.h>
#import <libavutil/dict.h>

@implementation FFmpegWrapper

+ (NSTimeInterval)getDurationOfVideoAtURL: (NSURL *)url {
    
    AVFormatContext *formatContext = NULL;
    
    avformat_network_init();
    
    int result = avformat_open_input(&formatContext, [url.path UTF8String], NULL, NULL);
    
    if (result != 0) {
        NSLog (@"Could not open video file: %s", av_err2str(result));
        return 0;
    }
    
    result = avformat_find_stream_info(formatContext, NULL);
    
    if (result < 0) {
        NSLog (@"Could not retrieve stream info: %s", av_err2str(result));
        avformat_close_input(&formatContext);
        return 0;
    }
    
    NSTimeInterval durationInSeconds = (NSTimeInterval) formatContext-> duration / AV_TIME_BASE;
    
    avformat_close_input(&formatContext);
    avformat_network_deinit();
    
    return durationInSeconds;
}

@end
