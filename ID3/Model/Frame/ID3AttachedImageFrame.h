//
//  ID3AttachedImageFrame.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ID3Mime)
{
	ID3MimeJPEG,
	ID3MimePNG
};

typedef NS_ENUM(NSInteger, ID3PictureType)
{
	ID3PictureTypeOther = 0
};

@interface ID3AttachedImageFrame : ID3Frame

@property (nonatomic) ID3Mime mime;
@property (nonatomic) ID3PictureType pictureType;
@property (strong, nonatomic) NSString *frameDescription;
@property (strong, nonatomic) ID3Image *image;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
