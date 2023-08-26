//
//  ID3Header.h
//  ID3
//
//  Created by Georgiy Cheremnykh on 22.08.2023.
//  Copyright © 2023 WebView, Lab. All rights reserved.
//

#import <ID3/ID3.h>

NS_ASSUME_NONNULL_BEGIN

/// Флаги заголовка.
typedef NS_OPTIONS(UInt8, ID3HeaderFlag)
{
	ID3HeaderFlagExperimentalHeader = 1 << 5,
	ID3HeaderFlagExtendedHeader = 1 << 6,
	ID3HeaderFlagUnsynchronisation = 1 << 7
};

/// Версия ID3.
typedef NS_ENUM(UInt8, ID3Version)
{
	ID3VersionV2 NS_SWIFT_NAME(v2) = 2,
	ID3VersionV3 NS_SWIFT_NAME(v3) = 3,
	ID3VersionV4 NS_SWIFT_NAME(v4) = 4
};

/// Заголовок метадаты ID3. Всегда должен присутствовать.
/// Имеет размер 10 байт и содержит указание версии ID3, флаги и размер содержимого.
///
/// Представление в памяти:
///  ["ID3"] - Маркер ID3
///  [$03 00] - Версия, первый байт мажорная версия, второй минорная.
///  [%abc00000] - Флаги
///  [4 * %0xxxxxxx] - Размер содержимого
///
@interface ID3Header : NSObject

/// Версия ID3.
@property (nonatomic, readonly) ID3Version version;

/// Флаги заголовка.
@property (nonatomic, readonly) ID3HeaderFlag flags;

/// Размер содержимого ID3, не включая размер самого заголовка.
@property (nonatomic, readonly) NSInteger frameSize;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
