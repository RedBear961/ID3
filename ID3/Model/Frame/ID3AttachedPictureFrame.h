//
//  ID3AttachedPictureFrame.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

@interface ID3AttachedPictureFrame : ID3Frame

@property (nonatomic) NSStringEncoding encoding;
@property (nonatomic) ID3Mime mime;
@property (nonatomic) ID3PictureType pictureType;
@property (strong, nonatomic, nullable) NSString *frameDescription;
@property (strong, nonatomic) ID3Image *image;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
