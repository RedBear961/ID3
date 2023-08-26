//
//  ID3Decoder.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 22.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3Decoder.h"
#import "ID3Header.h"
#import "ID3FrameHeader.h"
#import "ID3Private.h"
#import "ID3FrameDecoder.h"

const NSInteger kUnknownFrameHeaderID = -1;

@implementation ID3Decoder

- (ID3Meta *)decode:(NSURL *)url error:(NSError **)error
{
	NSInputStream *stream = [NSInputStream inputStreamWithURL:url];
	[stream open];

	uint8_t headerBuffer[kID3HeaderWidth];
	NSInteger count = [stream read:headerBuffer maxLength:kID3HeaderWidth];
	if (count != kID3HeaderWidth)
	{
		*error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
		return nil;
	}

	_ID3RawHeader _header = *((_ID3RawHeader *)headerBuffer);
	NSUInteger frameSize = CFSwapInt32HostToBig(_header.size);
	frameSize = [self synchsafeInteger:frameSize];
	ID3Header *header = [[ID3Header alloc] initWithVersion:_header.version[0]
													 flags:_header.flags
												 frameSize:frameSize];

	uint8_t *body = malloc(frameSize);
	NSInteger bodyCount = [stream read:body maxLength:frameSize];
	if (bodyCount != frameSize)
	{
		*error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
		free(body);
		return nil;
	}
	NSData *data = [NSData dataWithBytes:body length:frameSize];
	[stream close];
	free(body);

	NSMutableDictionary *frames = @{}.mutableCopy;
	NSInteger position = 0;
	uint8_t frameHeaderBuffer[kID3HeaderWidth];
	while (position < data.length - 10)
	{
		NSRange headerRange = NSMakeRange(position, kID3HeaderWidth);
		[data getBytes:frameHeaderBuffer range:headerRange];

		_ID3RawFrameHeader _frameHeader = *((_ID3RawFrameHeader *)frameHeaderBuffer);
		NSUInteger frameSize = CFSwapInt32HostToBig(_frameHeader.size);
		NSString *idString = [[NSString alloc] initWithData:[NSData dataWithBytes:_frameHeader.frameID length:4] encoding:NSUTF8StringEncoding];
		ID3FrameHeaderID headerID = [self IDFromHeaderFrameIDString:idString];

		if (headerID == kUnknownFrameHeaderID)
		{
			position += frameSize + kID3HeaderWidth;
			continue;
		}

		ID3FrameHeader *frameHeader = [[ID3FrameHeader alloc] initWithID:headerID
															   frameSize:frameSize
																   flags:_frameHeader.flags];

		position += kID3HeaderWidth;
		NSRange bodyRange = NSMakeRange(position, frameHeader.frameSize);
		NSData *frameBody = [data subdataWithRange:bodyRange];

		ID3FrameDecoder *decoder = [ID3FrameDecoder decoderWithFrameHeader:frameHeader data:frameBody];
		id<ID3Frame> frame = [decoder decode:error];
		_CheckIfError(error);
		if (frame)
		{
			frames[@(frameHeader.id)] = frame;
		}

		position += frameHeader.frameSize;
	}

	ID3Meta *meta = [[ID3Meta alloc] initWithHeader:header frames:frames];
	return meta;
}

- (NSUInteger)synchsafeInteger:(NSUInteger)integer
{
	uint32_t decoded = 0;
	uint32_t mask = 0x7F000000;

	while (mask)
	{
		decoded >>= 1;
		decoded = decoded | (integer & mask);
		mask >>= 8;
	}

	return decoded;
}

- (ID3FrameHeaderID)IDFromHeaderFrameIDString:(NSString *)idString
{
	if ([idString isEqualToString:@"TIT2"])
	{
		return ID3FrameHeaderIDTitle;
	}
	else if ([idString isEqualToString:@"TPE1"])
	{
		return ID3FrameHeaderIDArtist;
	}
	else if ([idString isEqualToString:@"TALB"])
	{
		return ID3FrameHeaderIDAlbum;
	}
	else if ([idString isEqualToString:@"APIC"])
	{
		return ID3FrameHeaderIDAttachedPicture;
	}

	return kUnknownFrameHeaderID;
}

@end
