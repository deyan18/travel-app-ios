//
//  WeatherViewModel.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 9/4/23.
//

import Foundation
import MapKit

private let apiKey = "bc9f177c9df56713f4e25c4da4c68648"

func getWeather(location: CLLocationCoordinate2D) async -> WeatherModel? {
    let url = URL(string:
        "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiKey)&units=metric"
    )!

    do {
        async let (data, _) = try await URLSession.shared.data(from: url)

        let dataModel = try await JSONDecoder().decode(WeatherResponseDataModel.self, from: data)

        let weatherModelMapper = WeatherModelMapper()
        let weatherModel = weatherModelMapper.mapDataModelToModel(dataModel: dataModel)

        // print("Data:", await data)
        print("DataModel:", dataModel)
        print("weatherModel:", weatherModel)
        return weatherModel

    } catch {
        print("Weather api error:", error.localizedDescription)
    }

    return nil
}
