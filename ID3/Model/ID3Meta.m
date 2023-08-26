//
//  ID3Meta.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 22.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import "ID3Meta.h"

@interface ID3Meta ()

@property (strong, nonatomic) NSDictionary<NSNumber *, ID3Frame *> *frames;

@end

@implementation ID3Meta

- (instancetype)initWithHeader:(ID3Header *)header frames:(NSDictionary *)frames
{
	if (self = [super init])
	{
		_header = header;
		_frames = frames;
	}
	return self;
}

- (ID3Frame *)textFrameForFrameHeaderID:(ID3FrameHeaderID)frameID
{
	return nil;
}

@end
