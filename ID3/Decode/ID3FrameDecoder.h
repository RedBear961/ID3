//
//  ID3FrameDecoder.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 24.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

@class ID3FrameHeader;
@protocol ID3Frame;

@interface ID3FrameDecoder : NSObject

+ (instancetype)decoderWithFrameHeader:(ID3FrameHeader *)header data:(NSData *)data;

- (id<ID3Frame>)decode:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
