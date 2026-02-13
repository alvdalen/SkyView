//
//  SkyViewJSONBridge.mm
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

#import "SkyViewJSONBridge.h"

#include <tao/json.hpp>
#include <string>

// Keys
NSString *const kSkyViewKeyTemp        = @"temp";
NSString *const kSkyViewKeyFeelsLike   = @"feels_like";
NSString *const kSkyViewKeyHumidity    = @"humidity";
NSString *const kSkyViewKeyPressure    = @"pressure";
NSString *const kSkyViewKeyWindSpeed   = @"wind_speed";
NSString *const kSkyViewKeyVisibility  = @"visibility";
NSString *const kSkyViewKeyClouds      = @"clouds";
NSString *const kSkyViewKeyDescription = @"description";
NSString *const kSkyViewKeyIcon        = @"icon";
NSString *const kSkyViewKeyDt          = @"dt";
NSString *const kSkyViewKeyTempMin     = @"temp_min";
NSString *const kSkyViewKeyTempMax     = @"temp_max";

namespace {

// Извлекает число (double) по ключу, 0.0 если нет
double safeDouble(const tao::json::value &obj, const std::string &key) {
    try {
        const auto &val = obj.at(key);
        if (val.is_double()) return val.get_double();
        if (val.is_signed()) return static_cast<double>(val.get_signed());
        if (val.is_unsigned()) return static_cast<double>(val.get_unsigned());
    } catch (...) {}
    return 0.0;
}

// Извлекает целое число
long long safeInt(const tao::json::value &obj, const std::string &key) {
    try {
        const auto &val = obj.at(key);
        if (val.is_signed()) return val.get_signed();
        if (val.is_unsigned()) return static_cast<long long>(val.get_unsigned());
        if (val.is_double()) return static_cast<long long>(val.get_double());
    } catch (...) {}
    return 0;
}

// Извлекает строку
std::string safeString(const tao::json::value &obj, const std::string &key) {
    try {
        const auto &val = obj.at(key);
        if (val.is_string()) return val.get_string();
    } catch (...) {}
    return "";
}

// Достаёт description и icon из массива "weather"
std::pair<std::string, std::string> extractWeatherInfo(const tao::json::value &obj) {
    try {
        const auto &arr = obj.at("weather").get_array();
        if (!arr.empty()) {
            return {
                safeString(arr[0], "description"),
                safeString(arr[0], "icon")
            };
        }
    } catch (...) {}
    return {"", ""};
}

}  

@implementation SkyViewJSONBridge

+ (nullable NSDictionary<NSString *, id> *)parseCurrentFromJSON:(NSString *)jsonString
                                                          error:(NSError **)error {
    if (!jsonString || jsonString.length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"SkyViewJSONBridge" code:1
                                     userInfo:@{NSLocalizedDescriptionKey: @"Empty JSON"}];
        }
        return nil;
    }

    try {
        std::string str = [jsonString UTF8String];
        const auto root = tao::json::from_string(str);

        // Проверяем наличие "current"
        if (!root.find("current")) {
            if (error) {
                *error = [NSError errorWithDomain:@"SkyViewJSONBridge" code:2
                                         userInfo:@{NSLocalizedDescriptionKey: @"Missing 'current' object"}];
            }
            return nil;
        }

        const auto &current = root.at("current");
        auto [desc, icon] = extractWeatherInfo(current);

        return @{
            kSkyViewKeyTemp:        @(safeDouble(current, "temp")),
            kSkyViewKeyFeelsLike:   @(safeDouble(current, "feels_like")),
            kSkyViewKeyHumidity:    @(safeInt(current, "humidity")),
            kSkyViewKeyPressure:    @(safeInt(current, "pressure")),
            kSkyViewKeyWindSpeed:   @(safeDouble(current, "wind_speed")),
            kSkyViewKeyVisibility:  @(safeInt(current, "visibility")),
            kSkyViewKeyClouds:      @(safeInt(current, "clouds")),
            kSkyViewKeyDescription: [NSString stringWithUTF8String:desc.c_str()],
            kSkyViewKeyIcon:        [NSString stringWithUTF8String:icon.c_str()],
            kSkyViewKeyDt:          @(safeInt(current, "dt")),
        };
    } catch (const tao::pegtl::parse_error &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"SkyViewJSONBridge" code:3
                                     userInfo:@{NSLocalizedDescriptionKey:
                [NSString stringWithFormat:@"Parse error: %s", e.what()]}];
        }
        return nil;
    } catch (const std::exception &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"SkyViewJSONBridge" code:4
                                     userInfo:@{NSLocalizedDescriptionKey:
                [NSString stringWithFormat:@"C++ error: %s", e.what()]}];
        }
        return nil;
    }
}

+ (nullable NSArray<NSDictionary<NSString *, id> *> *)parseDailyFromJSON:(NSString *)jsonString
                                                                   error:(NSError **)error {
    if (!jsonString || jsonString.length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"SkyViewJSONBridge" code:1
                                     userInfo:@{NSLocalizedDescriptionKey: @"Empty JSON"}];
        }
        return nil;
    }

    try {
        std::string str = [jsonString UTF8String];
        const auto root = tao::json::from_string(str);

        if (!root.find("daily") || !root.at("daily").is_array()) {
            if (error) {
                *error = [NSError errorWithDomain:@"SkyViewJSONBridge" code:2
                                         userInfo:@{NSLocalizedDescriptionKey: @"Missing 'daily' array"}];
            }
            return nil;
        }

        const auto &dailyArr = root.at("daily").get_array();
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:dailyArr.size()];

        for (const auto &day : dailyArr) {
            auto [desc, icon] = extractWeatherInfo(day);

            // temp — объект с min/max
            double tempMin = 0, tempMax = 0;
            try {
                const auto &temp = day.at("temp");
                tempMin = safeDouble(temp, "min");
                tempMax = safeDouble(temp, "max");
            } catch (...) {}

            // visibility может отсутствовать в daily
            long long visibility = safeInt(day, "visibility");

            [result addObject:@{
                kSkyViewKeyDt:          @(safeInt(day, "dt")),
                kSkyViewKeyTempMin:     @(tempMin),
                kSkyViewKeyTempMax:     @(tempMax),
                kSkyViewKeyPressure:    @(safeInt(day, "pressure")),
                kSkyViewKeyHumidity:    @(safeInt(day, "humidity")),
                kSkyViewKeyVisibility:  @(visibility),
                kSkyViewKeyClouds:      @(safeInt(day, "clouds")),
                kSkyViewKeyDescription: [NSString stringWithUTF8String:desc.c_str()],
                kSkyViewKeyIcon:        [NSString stringWithUTF8String:icon.c_str()],
            }];
        }

        return [result copy];
    } catch (const tao::pegtl::parse_error &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"SkyViewJSONBridge" code:3
                                     userInfo:@{NSLocalizedDescriptionKey:
                [NSString stringWithFormat:@"Parse error: %s", e.what()]}];
        }
        return nil;
    } catch (const std::exception &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"SkyViewJSONBridge" code:4
                                     userInfo:@{NSLocalizedDescriptionKey:
                [NSString stringWithFormat:@"C++ error: %s", e.what()]}];
        }
        return nil;
    }
}

@end
