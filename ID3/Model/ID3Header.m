//
//  ID3Header.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 22.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3Header.h"

@implementation ID3Header

- (instancetype)initWithVersion:(ID3Version)version
						  flags:(ID3HeaderFlag)flags
					  frameSize:(NSInteger)frameSize
{
	if (self = [super init])
	{
		_version = version;
		_flags = flags;
		_frameSize = frameSize;
	}
	return self;
}

@end
