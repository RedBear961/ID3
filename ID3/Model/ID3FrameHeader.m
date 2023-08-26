//
//  ID3FrameHeader.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 23.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3FrameHeader.h"

const NSInteger kID3FrameHeaderWidth = 10;

@implementation ID3FrameHeader

- (instancetype)initWithID:(ID3FrameHeaderID)id frameSize:(NSInteger)frameSize flags:(ID3FrameHeaderFlag)flags
{
	if (self = [super init])
	{
		_id = id;
		_size = frameSize;
		_flags = flags;
	}
	return self;
}

@end
