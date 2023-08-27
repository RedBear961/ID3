//
//  ID3Frame.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 24.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

@class ID3FrameHeader;

@interface ID3Frame : NSObject

@property (strong, nonatomic) ID3FrameHeader *header;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
