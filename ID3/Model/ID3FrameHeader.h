//
//  ID3FrameHeader.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 23.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(UInt16, ID3FrameHeaderFlag)
{
	ID3FrameHeaderFlagGroupingIdentity = 1 << 5,
	ID3FrameHeaderFlagEncryption = 1 << 6,
	ID3FrameHeaderFlagCompression = 1 << 7,

	ID3FrameHeaderFlagReadOnly = 1 << 13,
	ID3FrameHeaderFlagFileAlterPreservation = 1 << 14,
	ID3FrameHeaderFlagTagAlterPreservation = 1 << 15
};

@interface ID3FrameHeader : NSObject

@property (nonatomic, readonly) ID3FrameHeaderID id;
@property (nonatomic, readonly) NSInteger size;
@property (nonatomic, readonly) ID3FrameHeaderFlag flags;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
