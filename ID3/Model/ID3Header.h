//
//  ID3Header.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 22.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(UInt8, ID3HeaderFlag)
{
	ID3HeaderFlagExperimentalHeader = 1 << 5,
	ID3HeaderFlagExtendedHeader = 1 << 6,
	ID3HeaderFlagUnsynchronisation = 1 << 7
};

typedef NS_ENUM(UInt8, ID3Version)
{
	ID3VersionV2 NS_SWIFT_NAME(v2) = 2,
	ID3VersionV3 NS_SWIFT_NAME(v3) = 3,
	ID3VersionV4 NS_SWIFT_NAME(v4) = 4
};

@interface ID3Header : NSObject

@property (nonatomic, readonly) ID3Version version;
@property (nonatomic, readonly) ID3HeaderFlag flags;
@property (nonatomic, readonly) NSInteger frameSize;

- (nullable instancetype)initWithVersion:(ID3Version)version
								   flags:(ID3HeaderFlag)flags
							   frameSize:(NSInteger)frameSize;

@end

NS_ASSUME_NONNULL_END
