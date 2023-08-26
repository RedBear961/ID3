//
//  ID3Decoder.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 22.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

@class ID3Header;
@class ID3Meta;

@interface ID3Decoder : NSObject

- (nullable ID3Meta *)decode:(NSURL *)url error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
