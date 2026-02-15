//
//  Asset.swift
//  SkyView
//
//  Created by Adam on 15.02.2026.
//

enum Asset {
    /// SF Symbol имена для иконок в UI.
    enum Symbols {
        static var calendar: String { "calendar" }
        static var arrowUpRight: String { "arrow.up.right" }
        static var mappin: String { "mappin" }
        static var arrowClockwise: String { "arrow.clockwise" }
        static var thermometerMedium: String { "thermometer.medium" }
        static var wind: String { "wind" }
        static var humidityFill: String { "humidity.fill" }
        static var gaugeMedium: String { "gauge.medium" }
        static var eye: String { "eye" }
        static var cloudFill: String { "cloud.fill" }
        
        // Погода по коду OpenWeather (day/night)
        static var moonStarsFill: String { "moon.stars.fill" }
        static var sunMaxFill: String { "sun.max.fill" }
        static var cloudMoonFill: String { "cloud.moon.fill" }
        static var cloudSunFill: String { "cloud.sun.fill" }
        static var cloudRainFill: String { "cloud.rain.fill" }
        static var cloudBoltFill: String { "cloud.bolt.fill" }
        static var snowflake: String { "snowflake" }
        static var waterWaves: String { "water.waves" }
    }
}
