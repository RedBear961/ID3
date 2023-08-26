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

@protocol ID3Frame

@end

@interface ID3TextFrame : NSObject <ID3Frame>

@property (strong, nonatomic) ID3FrameHeader *header;
@property (strong, nonatomic) NSString *text;

@end

typedef NS_ENUM(NSInteger, ID3Mime)
{
	ID3MimeJPEG,
	ID3MimePNG
};

typedef NS_ENUM(NSInteger, ID3PictureType)
{
	ID3PictureTypeOther = 0
};

@interface ID3AttachedImageFrame : NSObject <ID3Frame>

@property (strong, nonatomic) ID3FrameHeader *header;
@property (nonatomic) ID3Mime mime;
@property (nonatomic) ID3PictureType pictureType;
@property (strong, nonatomic) NSString *frameDescription;
@property (strong, nonatomic) ID3Image *image;

@end

NS_ASSUME_NONNULL_END
