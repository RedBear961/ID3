//
//  ID3Frame.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 24.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3Frame.h"
#import "ID3Private.h"

#import "ID3TextFrame.h"
#import "ID3AttachedPictureFrame.h"

const NSInteger kEncodingMarkerLength = 1;

@implementation ID3Frame

- (instancetype)initWithHeader:(ID3FrameHeader *)header
{
	if (self = [super init])
	{
		_header = header;
	}
	return self;
}

+ (instancetype)decodeData:(NSData *)data
					header:(ID3FrameHeader *)header
					 error:(NSError **)error
{
	switch (header.id)
	{
		case ID3FrameHeaderIDTitle:
		case ID3FrameHeaderIDArtist:
		case ID3FrameHeaderIDAlbum:
			return [ID3TextFrame decodeData:data
									 header:header
									  error:error];
		case ID3FrameHeaderIDAttachedPicture:
			return [ID3AttachedPictureFrame decodeData:data
												header:header
												 error:error];
	}
}

@end

@implementation ID3Frame (Decoding)

+ (NSStringEncoding)textEncodingFromData:(NSData *)data error:(NSError **)error
{
	uint8_t marker;
	[data getBytes:&marker length:kEncodingMarkerLength];
	switch (marker)
	{
		case 0x0:	return NSISOLatin1StringEncoding;
		case 0x1:	return NSUTF16StringEncoding;
		case 0x2:	return NSUTF16StringEncoding;
		default:
		{
			*error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
			return kUnknown;
		}
	}
}

@end
