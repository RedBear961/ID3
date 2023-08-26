//
//  ID3FramePrivate.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

#import "ID3TextFrame.h"
#import "ID3AttachedPictureFrame.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT const NSInteger kEncodingMarkerLength;

@interface ID3Frame (Private)

+ (nullable instancetype)decodeData:(NSData *)data header:(ID3FrameHeader *)header error:(NSError **)error;

@end

@interface ID3FrameHeader (Private)

- (instancetype)initWithID:(ID3FrameHeaderID)id
				 frameSize:(NSInteger)frameSize
					 flags:(ID3FrameHeaderFlag)flags;

@end

@interface ID3TextFrame (Private)

- (instancetype)initWithHeader:(ID3FrameHeader *)header text:(NSString *)text;

@end

@interface ID3AttachedPictureFrame (Private)

- (instancetype)initWithHeader:(ID3FrameHeader *)header
						  mime:(ID3Mime)mime
				   pictureType:(ID3PictureType)pictureType
			  frameDescription:(NSString *)frameDescription
						 image:(ID3Image *)image;

@end

NS_ASSUME_NONNULL_END
