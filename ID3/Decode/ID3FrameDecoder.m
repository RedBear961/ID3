//
//  ID3FrameDecoder.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 24.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3FrameDecoder.h"
#import "ID3FrameHeader.h"
#import "ID3Frame.h"
#import "ID3Private.h"

const NSInteger kEncodingMarkerLength = 1;

@interface ID3FrameDecoder ()

@property (nonatomic) ID3FrameHeader *frameHeader;
@property (nonatomic) NSData *data;

@end

@implementation ID3FrameDecoder

+ (instancetype)decoderWithFrameHeader:(ID3FrameHeader *)header data:(NSData *)data
{
	ID3FrameDecoder *decoder = [[self alloc] init];
	decoder.frameHeader = header;
	decoder.data = data;
	return decoder;
}

- (id<ID3Frame>)decode:(NSError **)error
{
	id<ID3Frame> frame;
	switch (self.frameHeader.id)
	{
		case ID3FrameHeaderIDTitle:
		case ID3FrameHeaderIDArtist:
		case ID3FrameHeaderIDAlbum:
			frame = [self decodeTextFrame:error];
			break;
		case ID3FrameHeaderIDAttachedPicture:
			frame = [self decodeAttachedImageFrame:error];
			break;
	}
	return frame;
}

- (id<ID3Frame>)decodeTextFrame:(NSError **)error
{
	NSStringEncoding encoding = [self encoding:error];
	_CheckIfError(error);

	uint8_t lastSymbol = ((uint8_t *)self.data.bytes)[self.frameHeader.frameSize - 1];
	NSInteger offset = lastSymbol == 0x0 ? 1 : 0;
	NSRange textRange = NSMakeRange(kEncodingMarkerLength, self.frameHeader.frameSize - kEncodingMarkerLength - offset);
	NSData *textData = [self.data subdataWithRange:textRange];
	NSString *text = [[NSString alloc] initWithData:textData encoding:encoding];
	ID3TextFrame *frame = [[ID3TextFrame alloc] init];
	frame.header = self.frameHeader;
	frame.text = text;
	return frame;
}

- (id<ID3Frame>)decodeAttachedImageFrame:(NSError **)error
{
	NSStringEncoding encoding = [self encoding:error];
	_CheckIfError(error);

	NSString *mimeString = [NSString stringWithCString:self.data.bytes + 1
											  encoding:encoding];
	ID3Mime mime = [self mimeFromString:mimeString error:error];
	_CheckIfError(error);

	ID3PictureType pictureType = ((uint8_t *)self.data.bytes)[mimeString.length + 2];

	NSRange imageHeader = [self rangeOfImageWithMime:mime];
	NSAssert(imageHeader.location != NSNotFound, @"");
	NSRange binaryRange = NSMakeRange(imageHeader.location, self.data.length - imageHeader.location);
	NSData *binaryData = [self.data subdataWithRange:binaryRange];
	ID3Image *image = [[ID3Image alloc] initWithData:binaryData];

	NSRange descriptionRange = NSMakeRange(mimeString.length + 3, imageHeader.location - mimeString.length - 3);
	NSString *description = [[NSString alloc] initWithData:[self.data subdataWithRange:descriptionRange]
												  encoding:encoding];

	ID3AttachedImageFrame *frame = [[ID3AttachedImageFrame alloc] init];
	frame.header = self.frameHeader;
	frame.mime = mime;
	frame.pictureType = pictureType;
	frame.frameDescription = description;
	frame.image = image;
	return frame;
}

- (NSStringEncoding)encoding:(NSError **)error
{
	uint8_t marker;
	[self.data getBytes:&marker length:kEncodingMarkerLength];
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

- (ID3Mime)mimeFromString:(NSString *)mime error:(NSError **)error
{
	if ([mime isEqualToString:@"image/jpeg"] ||
		[mime isEqualToString:@"image/jpg"])
	{
		return ID3MimeJPEG;
	}
	else if ([mime isEqualToString:@"image/png"])
	{
		return ID3MimePNG;
	}

	*error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
	return kUnknown;
}

- (NSRange)rangeOfImageWithMime:(ID3Mime)mime
{
	NSData *imageHeader;
	switch (mime)
	{
		case ID3MimeJPEG:
		{
			uint8_t header[] = {0xFF, 0xD8, 0xFF, 0xE0};
			imageHeader = [NSData dataWithBytes:header
										 length:4];
			break;
		}
		case ID3MimePNG:
		{
			uint8_t header[] = {0x89, 0x50, 0x4E, 0x47};
			imageHeader = [NSData dataWithBytes:header
										 length:4];
			break;
		}
		default:
			assert(true);
	}

	NSRange range = [self.data rangeOfData:imageHeader
								   options:0
							   range:NSMakeRange(0, self.data.length)];
	return range;
}

@end
