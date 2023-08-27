//
//  ID3FrameBuilder.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 27.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

@class ID3Meta;

@interface ID3FrameBuilder : NSObject

@property (nonatomic) NSStringEncoding encoding;

- (ID3FrameBuilder *)title:(NSString *)text;

- (ID3FrameBuilder *)artist:(NSString *)text;

- (ID3FrameBuilder *)album:(NSString *)text;

- (ID3FrameBuilder *)attachedPicture:(ID3Image *)image error:(NSError **)error;

- (ID3Meta *)build;

@end

NS_ASSUME_NONNULL_END
