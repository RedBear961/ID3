//
//  ID3FramePrivate.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

#import "ID3Meta.h"
#import "ID3TextFrame.h"
#import "ID3AttachedImageFrame.h"

@interface ID3Meta (Private)

@property (strong, nonatomic, readonly) NSDictionary<NSNumber *, ID3Frame *> *frames;
- (instancetype)initWithHeader:(ID3Header *)header frames:(NSDictionary *)frames;

@end

@interface ID3Frame (Private)

- (instancetype)initWithHeader:(ID3FrameHeader *)header;

@end

@interface ID3FrameHeader (Private)

- (instancetype)initWithID:(ID3FrameHeaderID)id frameSize:(NSInteger)frameSize flags:(ID3FrameHeaderFlag)flags;

@end

@interface ID3Header (Private)

- (instancetype)initWithVersion:(ID3Version)version
						  flags:(ID3HeaderFlag)flags
					  frameSize:(NSInteger)frameSize;

@end

@interface ID3TextFrame (Private)

- (instancetype)initWithHeader:(ID3FrameHeader *)header text:(NSString *)text;

@end

@interface ID3AttachedImageFrame (Private)

- (instancetype)initWithHeader:(ID3FrameHeader *)header mime:(ID3Mime)mime pictureType:(ID3PictureType)pictureType frameDescription:(NSString *)frameDescription image:(ID3Image *)image;

@end
