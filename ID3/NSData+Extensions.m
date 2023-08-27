//
//  NSData+Extensions.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "NSData+Extensions.h"
#import "ID3Private.h"

@implementation NSData (ID3Extensions)

- (uint8_t)byteAtIndex:(NSInteger)index
{
	NSParameterAssert(index < self.length);
	return ((uint8_t *)self.bytes)[index];
}

- (NSRange)rangeOfSequence:(const uint8_t *)sequence length:(NSInteger)length
{
	NSData *search = [NSData dataWithBytes:sequence length:4];
	return [self rangeOfData:search
					 options:0
					   range:NSMakeRange(0, self.length)];
}

- (ID3Mime)imageFormat
{
	uint8_t byte = *(uint8_t *)self.bytes;
	switch (byte)
	{
		case 0xFF:
			return ID3MimeJPEG;
		case 0x89:
			return ID3MimePNG;
		default:
			return ID3MimeUnsupported();
	}
}

@end
