//
//  ID3TextFrame.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3TextFrame.h"
#import "ID3Private.h"
#import "ID3FramePrivate.h"
#import "ID3Frame+Decoding.h"

#import "NSData+Extensions.h"

@implementation ID3TextFrame

- (instancetype)initWithHeader:(ID3FrameHeader *)header text:(NSString *)text encoding:(NSStringEncoding)encoding
{
	if (self = [super initWithHeader:header])
	{
		_text = text;
		_encoding = encoding;
	}
	return self;
}

+ (instancetype)decodeData:(NSData *)data
					header:(ID3FrameHeader *)header
					 error:(NSError **)error
{
	NSParameterAssert(header != nil);
	NSParameterAssert(data.length == header.size);

	// Получаем кодировку.
	NSStringEncoding encoding = [self textEncodingFromData:data
													 error:error];
	_CheckIfError(error);

	// Нуль-терминатор не требуется по стандарту, отрезаем для унификации.
	NSInteger offset = ![data byteAtIndex:header.size - 1];
	if (offset)
	{
		header = [[ID3FrameHeader alloc] initWithID:header.id
										  frameSize:header.size - offset
											  flags:header.flags];
	}

	// Декодируем текст.
	NSInteger length = header.size - kEncodingMarkerLength;// - offset;
	NSRange range = NSMakeRange(kEncodingMarkerLength, length);
	NSData *textData = [data subdataWithRange:range];
	NSString *text = [[NSString alloc] initWithData:textData encoding:encoding];
	return [[ID3TextFrame alloc] initWithHeader:header
										   text:text
									   encoding:encoding];
}

- (NSData *)encode:(NSError *)error
{
	return nil;
}

// MARK: - Override

- (BOOL)isEqual:(ID3TextFrame *)other {
	return self.class == other.class &&
		  [self.header isEqual:other.header] &&
		  [self.text isEqualToString:other.text];
}

@end
