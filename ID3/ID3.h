//
//  ID3.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 22.08.2023.
//

#ifndef __ID3_ID3__
#define __ID3_ID3__

#import <Foundation/Foundation.h>

#if __has_include(<UIKit/UIKit.h>)
#import <UIKit/UIKit.h>
typedef UIImage ID3Image;
#else
#import <AppKit/AppKit.h>
typedef NSImage ID3Image;
#endif

#import <ID3/ID3FrameHeaderID.h>
#import <ID3/ID3Decoder.h>
#import <ID3/ID3FrameHeader.h>
#import <ID3/ID3Header.h>
#import <ID3/ID3Frame.h>
#import <ID3/ID3Error.h>
#import <ID3/ID3Meta.h>

#endif /* __ID3_ID3__ */
