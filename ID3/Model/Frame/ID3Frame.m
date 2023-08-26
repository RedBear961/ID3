//
//  ID3Frame.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 24.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3Frame.h"

@implementation ID3Frame

- (instancetype)initWithHeader:(ID3FrameHeader *)header
{
	if (self = [super init])
	{
		_header = header;
	}
	return self;
}

@end
