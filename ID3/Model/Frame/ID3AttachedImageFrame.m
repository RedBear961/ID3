//
//  ID3AttachedImageFrame.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3AttachedImageFrame.h"
#import "ID3FramePrivate.h"

@implementation ID3AttachedImageFrame

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

@end
