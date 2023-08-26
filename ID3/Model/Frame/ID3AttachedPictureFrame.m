//
//  ID3AttachedPictureFrame.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3AttachedPictureFrame.h"

#import "ID3Private.h"
#import "ID3Frame+Decoding.h"

@implementation ID3AttachedPictureFrame

- (instancetype)initWithHeader:(ID3FrameHeader *)header
						  mime:(ID3Mime)mime
				   pictureType:(ID3PictureType)pictureType
			  frameDescription:(NSString *)frameDescription
						 image:(ID3Image *)image
{
	if (self = [super initWithHeader:header])
	{
		_mime = mime;
		_pictureType = pictureType;
		_frameDescription = frameDescription;
		_image = image;
	}
	return self;
}

+ (instancetype)decodeData:(NSData *)data
					header:(ID3FrameHeader *)header
					 error:(NSError **)error
{
	NSStringEncoding encoding = [self textEncodingFromData:data error:error];
	_CheckIfError(error);

	NSString *mimeString = [NSString stringWithCString:data.bytes + 1
											  encoding:encoding];
	ID3Mime mime = [self mimeFromString:mimeString error:error];
	_CheckIfError(error);

	ID3PictureType pictureType = ((uint8_t *)data.bytes)[mimeString.length + 2];

	NSRange imageHeader = [self rangeOfImageInData:data mime:mime];
	NSAssert(imageHeader.location != NSNotFound, @"");
	NSRange binaryRange = NSMakeRange(imageHeader.location, data.length - imageHeader.location);
	NSData *binaryData = [data subdataWithRange:binaryRange];
	ID3Image *image = [[ID3Image alloc] initWithData:binaryData];

	NSRange descriptionRange = NSMakeRange(mimeString.length + 3, imageHeader.location - mimeString.length - 3);
	NSString *description = [[NSString alloc] initWithData:[data subdataWithRange:descriptionRange]
												  encoding:encoding];

	return [[ID3AttachedPictureFrame alloc] initWithHeader:header
													  mime:mime
											   pictureType:pictureType
										  frameDescription:description
													 image:image];
}

+ (ID3Mime)mimeFromString:(NSString *)mime error:(NSError **)error
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

+ (NSRange)rangeOfImageInData:(NSData *)data mime:(ID3Mime)mime
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

	NSRange range = [data rangeOfData:imageHeader
								   options:0
							   range:NSMakeRange(0, data.length)];
	return range;
}

@end
