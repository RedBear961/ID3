//
//  ID3DecodeHeaderTest.m
//  ID3Tests
//
//  Created by Georgiy Cheremnykh on 22.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ID3/ID3.h>
#import "ID3Private.h"
#import "ID3FramePrivate.h"

@interface ID3DecodeHeaderTest : XCTestCase

@property (nonatomic) NSBundle *bundle;
@property (nonatomic) ID3Decoder *decoder;

@end

@implementation ID3DecodeHeaderTest

- (void)setUp
{
	self.bundle = [NSBundle bundleForClass:[self class]];
	self.decoder = [[ID3Decoder alloc] init];
}

- (void)tearDown
{
	self.bundle = nil;
	self.decoder = nil;
}

- (void)testDecodeSong001
{
	NSError *error = nil;
	NSURL *url = [self.bundle URLForResource:@"song001" withExtension:@"mp3"];
	NSURL *imageURL = [self.bundle URLForImageResource:@"song001_attachedImage"];
	NSImage *image = [[NSImage alloc] initWithContentsOfURL:imageURL];
	NSData *imageData = [image TIFFRepresentation];

	ID3Meta *meta = [self.decoder decode:url error:&error];
	XCTAssertNil(error);

	ID3Header *header = meta.header;
	XCTAssertNotNil(header);
	XCTAssertEqual(header.version, ID3VersionV3);
	XCTAssertEqual(header.frameSize, 2332);

	NSDictionary *frames = meta.frames;
	XCTAssertTrue(frames.count == 4);

	ID3TextFrame *title = frames[@(ID3FrameHeaderIDTitle)];
	XCTAssertTrue([title.text isEqualToString:@"song001 Title"]);

	ID3TextFrame *artist = frames[@(ID3FrameHeaderIDArtist)];
	XCTAssertTrue([artist.text isEqualToString:@"song001 Artist"]);

	ID3TextFrame *album = frames[@(ID3FrameHeaderIDAlbum)];
	XCTAssertTrue([album.text isEqualToString:@"song001 Album"]);

	ID3AttachedPictureFrame *attachedImage = frames[@(ID3FrameHeaderIDAttachedPicture)];
	XCTAssertTrue([attachedImage.image.TIFFRepresentation isEqualToData:imageData]);
}

- (void)testBuildMeta
{
	NSURL *imageURL = [self.bundle URLForImageResource:@"song001_attachedImage"];
	NSImage *image = [[NSImage alloc] initWithContentsOfURL:imageURL];

	NSError *error = nil;
	NSURL *url = [self.bundle URLForResource:@"song001" withExtension:@"mp3"];
	ID3Meta *meta = [self.decoder decode:url error:&error];
	XCTAssertNil(error);
	ID3Header *header = meta.header;
	NSDictionary *frames = meta.frames;

	ID3TextFrame *title = frames[@(ID3FrameHeaderIDTitle)];
	ID3TextFrame *artist = frames[@(ID3FrameHeaderIDArtist)];
	ID3TextFrame *album = frames[@(ID3FrameHeaderIDAlbum)];
	ID3AttachedPictureFrame *attachedImage = frames[@(ID3FrameHeaderIDAttachedPicture)];

	ID3FrameBuilder *builder = [[ID3FrameBuilder alloc] init];
	[builder title:@"song001 Title"];
	[builder artist:@"song001 Artist"];
	[builder album:@"song001 Album"];
	[builder attachedPicture:image error:&error];
	XCTAssertNil(error);

	ID3Meta *buildedMeta = [builder build];
	ID3Header *buildedHeader = buildedMeta.header;
	XCTAssertEqual(header.frameSize, buildedHeader.frameSize);
	NSDictionary *buildedFrames = buildedMeta.frames;

	ID3TextFrame *buildedTitle = buildedFrames[@(ID3FrameHeaderIDTitle)];
	XCTAssertTrue([title isEqual:buildedTitle]);

	ID3TextFrame *buildedArtist = buildedFrames[@(ID3FrameHeaderIDArtist)];
	XCTAssertTrue([artist isEqual:buildedArtist]);

	ID3TextFrame *buildedAlbum = buildedFrames[@(ID3FrameHeaderIDAlbum)];
	XCTAssertTrue([album isEqual:buildedAlbum]);

	ID3AttachedPictureFrame *buildedAttachedImage = buildedFrames[@(ID3FrameHeaderIDAttachedPicture)];
	XCTAssertTrue([attachedImage isEqual:buildedAttachedImage]);
}

@end
