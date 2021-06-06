//
//  NetworkManager.swift
//  WeatherSearching
//
//  Created by Andres Chan on 5/6/2021.
//

import Foundation
import Combine
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    //Paths
    let kGetWeather = "https://api.openweathermap.org/data/2.5/weather"
    
    //API Calls
    func getWeatherByCityName(name: String) -> AnyPublisher<Result<WeatherModel, AFError>, Never> {
        print("getWeatherByCityName: \(name)")
        return get(urlPath: kGetWeather)
            .addParam(key: "q", value: name)
            .addParam(key: "units", value: "metric")
            .callPublisher()
            .result()
    }
    
    func getWeatherByZipcode(code: String, country: String) -> AnyPublisher<Result<WeatherModel, AFError>, Never> {
        return get(urlPath: kGetWeather)
            .addParam(key: "zip", value: "\(code),\(country)")
            .addParam(key: "units", value: "metric")
            .callPublisher()
            .result()
    }
    
    func getWeatherByGPS(lon: String, lat: String) -> AnyPublisher<Result<WeatherModel, AFError>, Never> {
        return get(urlPath: kGetWeather)
            .addParams(["lon": lon, "lat": lat, "units": "metric"])
            .callPublisher()
            .result()
    }

    //Restful api method goes here
    private func get(urlPath: String) -> RequestBuilder {
        return RequestBuilder(urlPath: urlPath, method: .get)
    }
    
//    private func post(urlPath: String) -> RequestBuilder {
//        return RequestBuilder(urlPath: urlPath, method: .post, encoding: JSONEncoding.default)
//    }
    
}

struct RequestBuilder {
    let urlPath: String
    let method: HTTPMethod
    var headers: [String: String] = [:]
    var params: Parameters = ["appId": "95d190a434083879a6398aafd54d9e73"]
    let encoding: ParameterEncoding
    
    let adapter = Adapter { request,_, completion in
        print("API call: \(request)")
        completion(.success(request))
    }
    
    init(urlPath: String, method: HTTPMethod, encoding: ParameterEncoding = URLEncoding.default) {
        self.urlPath = urlPath
        self.method = method
        self.encoding = encoding
    }
    
    func callPublisher<T: Decodable>() -> DataResponsePublisher<T> {
        return AF.request(urlPath, method: method, parameters: params, encoding: encoding, interceptor: adapter)
            .validate({ request, response, data in
                print("statusCode: " + "\(response.statusCode)")
                print("full response: " + "\n" + response.description)
                print("full data: " + "\n" + (data?.description ?? "Nil"))
                return .success(())
            }).publishDecodable()
    }
    
    func addParam(key: String, value: Any) -> Self {
        var rb = self
        rb.params[key] = value
        return rb
    }
    
    func addParams(_ params: [String: Any]) -> Self {
        var rb = self
        rb.params.merge(filterNestedNilValues(params)) { $1 }
        return rb
    }
    
    private func filterNestedNilValues(_ dict: [String: Any?]) -> [String: Any] {
        var newDict: [String: Any] = dict.compactMapValues { $0 }

        // check next level
        for (k, v) in newDict {
            if let childDict = v as? [String: Any?] {
                newDict[k] = filterNestedNilValues(childDict)
            }
        }
        return newDict
    }
}
