//
//  NSData+Extensions.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "NSData+Extensions.h"

@implementation NSData (ID3Extensions)

- (uint8_t)byteAtIndex:(NSInteger)index
{
	NSParameterAssert(index < self.length);
	return ((uint8_t *)self.bytes)[index];
}

@end
