//
//  ID3AttachedPictureFrame.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3AttachedPictureFrame.h"

#import "ID3Private.h"
#import "ID3FramePrivate.h"
#import "ID3Frame+Decoding.h"
#import "NSData+Extensions.h"

@implementation ID3AttachedPictureFrame

- (instancetype)initWithHeader:(ID3FrameHeader *)header
					  encoding:(NSStringEncoding)encoding
						  mime:(ID3Mime)mime
				   pictureType:(ID3PictureType)pictureType
			  frameDescription:(NSString *)frameDescription
						 image:(ID3Image *)image
{
	if (self = [super initWithHeader:header])
	{
		_encoding = encoding;
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
	NSParameterAssert(header != nil);
	NSParameterAssert(data.length == header.size);

	// Получаем кодировку.
	NSStringEncoding encoding = [self textEncodingFromData:data
													 error:error];
	_CheckIfError(error);

	// Получаем MIME.
	NSString *mimeString = [NSString stringWithCString:(data.bytes + kEncodingMarkerLength)
											  encoding:encoding];
	ID3Mime mime = [self mimeFromString:mimeString error:error];
	_CheckIfError(error);

	// Получаем тип изображения.
	NSInteger picTypeOffset = kEncodingMarkerLength + 1;
	ID3PictureType pictureType = [data byteAtIndex:mimeString.length + picTypeOffset];

	NSRange imageHeader = [self rangeOfImageInData:data mime:mime];
	if (imageHeader.location == NSNotFound)
	{
		*error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
		return nil;
	}

	// Получаем изображение.
	NSRange range = NSMakeRange(imageHeader.location, data.length - imageHeader.location);
	NSData *binaryData = [data subdataWithRange:range];
	ID3Image *image = [[ID3Image alloc] initWithData:binaryData];
	if (!image)
	{
		*error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
		return nil;
	}

	// Описание фрейма.
	NSInteger contentLength = mimeString.length + kEncodingMarkerLength + 2;
	NSRange descriptionRange = NSMakeRange(contentLength, imageHeader.location - contentLength);
	NSString *description = [[NSString alloc] initWithData:[data subdataWithRange:descriptionRange]
												  encoding:encoding];

	return [[ID3AttachedPictureFrame alloc] initWithHeader:header
												  encoding:encoding
													  mime:mime
											   pictureType:pictureType
										  frameDescription:description
													 image:image];
}

- (NSData *)encode:(NSError *)error
{
	return nil;
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
	switch (mime)
	{
		case ID3MimeJPEG:
			return [data rangeOfSequence:kJPEGHeader
								  length:4];
		case ID3MimePNG:
			return [data rangeOfSequence:kPNGHeader
								  length:4];
	}
}

// MARK: - Override

- (BOOL)isEqual:(ID3AttachedPictureFrame *)other {
	return self.class == other.class &&
		  [self.header isEqual:other.header] &&
		  self.encoding == other.encoding &&
		  self.mime == other.mime &&
		  self.pictureType == other.pictureType &&
		  [self.image.TIFFRepresentation isEqualToData:other.image.TIFFRepresentation];
}

@end
