//
//  SkyViewJSONBridge.h
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Ключи для current weather
extern NSString *const kSkyViewKeyTemp;
extern NSString *const kSkyViewKeyFeelsLike;
extern NSString *const kSkyViewKeyHumidity;
extern NSString *const kSkyViewKeyPressure;
extern NSString *const kSkyViewKeyWindSpeed;
extern NSString *const kSkyViewKeyVisibility;
extern NSString *const kSkyViewKeyClouds;
extern NSString *const kSkyViewKeyDescription;
extern NSString *const kSkyViewKeyIcon;
extern NSString *const kSkyViewKeyDt;

// Доп. ключи для daily forecast
extern NSString *const kSkyViewKeyTempMin;
extern NSString *const kSkyViewKeyTempMax;

@interface SkyViewJSONBridge : NSObject

/// Парсит current weather из JSON
+ (nullable NSDictionary<NSString *, id> *)parseCurrentFromJSON:(NSString *)jsonString
                                                          error:(NSError **)error;

/// Парсит массив daily forecast из JSON
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)parseDailyFromJSON:(NSString *)jsonString
                                                                   error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
