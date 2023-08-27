//
//  ID3Private.m
//  ID3
//
//  Created by Georgiy Cheremnykh on 26.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

const NSInteger kUnknown = -1;
const NSInteger kID3HeaderWidth = 10;

const uint8_t kJPEGHeader[] = {0xFF, 0xD8, 0xFF, 0xE0};
const uint8_t kPNGHeader[] = {0x89, 0x50, 0x4E, 0x47};

ID3Mime ID3MimeUnsupported(void)
{
	return NSIntegerMax;
}
