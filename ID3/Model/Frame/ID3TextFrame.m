//
//  ID3TextFrame.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3TextFrame.h"
#import "ID3FramePrivate.h"

@implementation ID3TextFrame

- (instancetype)initWithHeader:(ID3FrameHeader *)header text:(NSString *)text
{
	if (self = [super initWithHeader:header])
	{
		_text = text;
	}
	return self;
}

@end
