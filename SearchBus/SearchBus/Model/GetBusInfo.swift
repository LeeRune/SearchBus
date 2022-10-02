//
//  GetBusInfo.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/9/24.
//

import Foundation

class GetBusInfo {
    
    var delegate: BusInfoDelegate!
    let defaults = UserDefaults.standard
    let appId = "lirune1122-e88be020-0cb5-43c5"
    let appKey = "ba3f23c3-4a63-4057-9eab-2e54371a22a6"
    let tokenURL = URL(string: "https://tdx.transportdata.tw/auth/realms/TDXConnect/protocol/openid-connect/token")!
    
    func getToken() {
        var request = URLRequest(url: tokenURL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let data : Data = "grant_type=client_credentials&client_id=\(appId)&client_secret=\(appKey)".data(using: .utf8)!
        request.httpMethod = "POST"
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                        // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
                let createUserResponse = try decoder.decode(TDXToken.self, from: data)
                guard let token = createUserResponse.access_token else {return}
                self.defaults.set(token, forKey: "token")
                self.getBusRoute()
            } catch  {
                print(error)
            }
        }.resume()
    }
    
    // 取得台北市公車路線
    func getBusRoute() {
        guard let token = defaults.value(forKey: "token") else {return}
        let tokenURL = URL(string: "https://tdx.transportdata.tw/api/basic/v2/Bus/Route/City/Taipei?format=JSON")!
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                    // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            print(response.statusCode)
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([BusRoute].self, from: data)
               
                var busRouteList: [String] = []
                
                for response in response{
                    guard let routeName = response.RouteName?.Zh_tw else {return}
                    busRouteList.append(routeName)
                }
                self.delegate.didGetBusRoute(data: busRouteList)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getBusDepNDes(route: String) {
        guard let token = defaults.value(forKey: "token") else {return}
        let tokenURL = URL(string: "https://tdx.transportdata.tw/api/basic/v2//Bus/Route/City/Taipei/\(route)?$format=JSON")!
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                    // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            print(response.statusCode)
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([BusDepNDes].self, from: data)
                
                var busDepNDes = [String: String]()
                
                for response in response{
                    guard let routeDep = response.DepartureStopNameZh else {return}
                    
                    guard let routeDes = response.DestinationStopNameZh else {return}
                    
                    busDepNDes.updateValue(routeDep, forKey: "routeDep")
                    busDepNDes.updateValue(routeDes, forKey: "routeDes")
                    
                }
                self.delegate.didGetBusDepNDes(data: busDepNDes)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getBusStops(route: String, direction: Int) {
        guard let token = defaults.value(forKey: "token") else {return}
        let requestURL = URL(string: "https://tdx.transportdata.tw/api/basic/v2/Bus/StopOfRoute/City/Taipei/\(route)?%24format=JSON)")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                    // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            print(response.statusCode)
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([BusStopOfRoute].self, from: data)
                
                var busStops : String = ""
                
                for response in response{
                    guard let routeName = response.RouteName?.Zh_tw else {return}
                    
                    let direction = response.Direction
                    
                    let stops = response.Stops
                    
                    if routeName == "617" && direction == direction {
                        for stops in stops {
                            
                            guard let stopName = stops.StopName?.Zh_tw else {return}
                            busStops = busStops + stopName + "\n"
                        }
                        break
                    }
                }
                
                self.delegate.didGetBusStops(data: busStops)
                
            } catch {
                print(error)
            }
        }.resume()
    }
}
