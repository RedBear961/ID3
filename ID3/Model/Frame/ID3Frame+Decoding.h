//
//  ID3Frame+Decoding.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3Frame.h"

NS_ASSUME_NONNULL_BEGIN

@interface ID3Frame (Decoding)

- (instancetype)initWithHeader:(ID3FrameHeader *)header;
+ (NSStringEncoding)textEncodingFromData:(NSData *)data error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
