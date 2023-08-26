//
//  ID3Private.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#ifndef __ID3_PRIVATE__
#define __ID3_PRIVATE__

#import "ID3Meta.h"

FOUNDATION_EXPORT const NSInteger kID3HeaderWidth;
FOUNDATION_EXPORT const NSInteger kUnknown;

#define _CheckIfError(error) if (*(error)) { return nil; }

typedef struct _ID3RawHeader _ID3RawHeader;
struct _ID3RawHeader
{
	char title[3];
	uint8_t version[2];
	uint8_t flags;
	uint32_t size;
} __attribute__((packed));

typedef struct _ID3RawFrameHeader _ID3RawFrameHeader;
struct _ID3RawFrameHeader
{
	char frameID[4];
	uint32_t size;
	uint16_t flags;
} __attribute__((packed));

@interface ID3Meta (Private)

@property (strong, nonatomic, readonly) NSDictionary<NSNumber *, ID3Frame *> *frames;
- (instancetype)initWithHeader:(ID3Header *)header frames:(NSDictionary *)frames;

@end

@interface ID3Header (Private)

- (instancetype)initWithVersion:(ID3Version)version
						  flags:(ID3HeaderFlag)flags
					  frameSize:(NSInteger)frameSize;

@end

#endif /* __ID3_PRIVATE__ */
