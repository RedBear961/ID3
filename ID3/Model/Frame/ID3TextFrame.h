//
//  ID3TextFrame.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

@interface ID3TextFrame : ID3Frame

@property (strong, nonatomic) NSString *text;
@property (nonatomic) NSStringEncoding encoding;

@end

NS_ASSUME_NONNULL_END
