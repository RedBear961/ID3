//
//  ID3Meta.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 22.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

@interface ID3Meta : NSObject

@property (nonatomic, readonly) ID3Header *header;
@property (nonatomic, readonly) ID3FrameHeaderID id;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
