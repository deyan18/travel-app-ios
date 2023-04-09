//
//  WeatherModel.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 9/4/23.
//

import Foundation

struct WeatherModel {
    let city: String
    let weather: String
    let description: String
    let iconURL: URL?
    let currentTemperature: String
    let minTemperature: String
    let maxTemperature: String
    let humidity: String

    static let empty: WeatherModel = .init(city: "No city",
                                           weather: "No Weather",
                                           description: "No description",
                                           iconURL: nil,
                                           currentTemperature: "0º",
                                           minTemperature: "0º Min.",
                                           maxTemperature: "0º Máx.",
                                           humidity: "0%")
}

struct WeatherModelMapper {
    func mapDataModelToModel(dataModel: WeatherResponseDataModel) -> WeatherModel {
        guard let weather = dataModel.weather.first else {
            return .empty
        }

        let temperature = dataModel.temperature

        return WeatherModel(city: dataModel.city,
                            weather: weather.main,
                            description: "(\(weather.description))",
                            iconURL: URL(string: "http://openweathermap.org/img/wn/\(weather.iconURLString)@2x.png"),
                            currentTemperature: "\(Int(temperature.currentTemperature))º",
                            minTemperature: "\(Int(temperature.minTemperature))º",
                            maxTemperature: "\(Int(temperature.maxTemperature))º",
                            humidity: "\(temperature.humidity)%")
    }
}

struct WeatherResponseDataModel: Decodable {
    let city: String
    let weather: [WeatherDataModel]
    let temperature: TemperatureDataModel

    enum CodingKeys: String, CodingKey {
        case city = "name"
        case weather
        case temperature = "main"
    }
}

struct WeatherDataModel: Decodable {
    let main: String
    let description: String
    let iconURLString: String

    enum CodingKeys: String, CodingKey {
        case main
        case description
        case iconURLString = "icon"
    }
}

struct TemperatureDataModel: Decodable {
    let currentTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case humidity
    }
}
