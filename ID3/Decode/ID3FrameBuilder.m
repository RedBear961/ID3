//
//  ID3FrameBuilder.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 27.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3FrameBuilder.h"
#import "ID3Private.h"
#import "ID3FramePrivate.h"
#import "NSData+Extensions.h"

const NSStringEncoding kDefaultEncoding = NSUTF16StringEncoding;

@interface ID3FrameBuilder ()

@property (nonatomic) NSMutableDictionary *frames;

@end

@implementation ID3FrameBuilder

- (instancetype)init
{
	if (self = [super init])
	{
		_frames = @{}.mutableCopy;
	}
	return self;
}

- (ID3FrameBuilder *)title:(NSString *)text {
	return [self appendTextFrame:text
						 frameID:ID3FrameHeaderIDTitle
						encoding:kDefaultEncoding];
}

- (ID3FrameBuilder *)artist:(NSString *)text {
	return [self appendTextFrame:text
						 frameID:ID3FrameHeaderIDArtist
						encoding:kDefaultEncoding];
}

- (ID3FrameBuilder *)album:(NSString *)text {
	return [self appendTextFrame:text
						 frameID:ID3FrameHeaderIDAlbum
						encoding:kDefaultEncoding];
}

- (ID3FrameBuilder *)attachedPicture:(ID3Image *)image error:(NSError **)error {

	CGImageRef cgImage = [image CGImageForProposedRect:nil context:nil hints:nil];
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
	NSData *binary = [rep representationUsingType:NSBitmapImageFileTypeJPEG properties:@{}];
	ID3Mime mime = [binary imageFormat];
	if (mime == ID3MimeUnsupported())
	{
		*error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
		return self;
	}

	NSString *mimeType = [self stringWithMime:mime];
	NSInteger frameSize = 1 + mimeType.length + 1 + 1 + binary.length;
	ID3FrameHeader *header = [[ID3FrameHeader alloc] initWithID:ID3FrameHeaderIDAttachedPicture
													  frameSize:frameSize
														  flags:0];
	ID3AttachedPictureFrame *frame = [[ID3AttachedPictureFrame alloc] initWithHeader:header
																			encoding:kDefaultEncoding
																				mime:mime
																		 pictureType:ID3PictureTypeOther
																	frameDescription:nil
																			   image:image];
	self.frames[@(ID3FrameHeaderIDAttachedPicture)] = frame;
	return self;
}

- (ID3Meta *)build
{
	__block NSInteger size = 0;
	[self.frames.allValues enumerateObjectsUsingBlock:^(ID3Frame *frame, NSUInteger idx, BOOL *stop) {
		size += frame.header.size;
	}];

	ID3Header *header = [[ID3Header alloc] initWithVersion:ID3VersionV4
													 flags:0
												 frameSize:size];
	ID3Meta *meta = [[ID3Meta alloc] initWithHeader:header
											 frames:self.frames];
	return meta;
}

#pragma mark - Private

- (ID3FrameBuilder *)appendTextFrame:(NSString *)text frameID:(ID3FrameHeaderID)frameID encoding:(NSStringEncoding)encoding
{
	ID3FrameHeader *header = [[ID3FrameHeader alloc] initWithID:frameID
													  frameSize:text.length + 1
														  flags:0];
	ID3TextFrame *frame = [[ID3TextFrame alloc] initWithHeader:header
														  text:text
													  encoding:encoding];
	self.frames[@(frameID)] = frame;
	return self;
}

- (NSString *)stringWithMime:(ID3Mime)mime
{
	switch (mime)
	{
		case ID3MimeJPEG:
			return @"image/jpeg";
		case ID3MimePNG:
			return @"image/png";
	}
}

@end
