//
//  NSData+Extensions.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ID3Extensions)

- (uint8_t)byteAtIndex:(NSInteger)index;
- (NSRange)rangeOfSequence:(const uint8_t *)sequence length:(NSInteger)length;
- (ID3Mime)imageFormat;

@end

NS_ASSUME_NONNULL_END
