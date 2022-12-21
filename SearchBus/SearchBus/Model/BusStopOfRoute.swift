//
//  BusStopOfRoute.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/9/22.
//

import Foundation

struct BusStopOfRoute: Codable {
    var Direction: Int = 0
    var RouteID: String?
    var RouteName: BusRouteName?
    var RouteUID: String?
    var Stops = [BusStops]()
}

struct BusStops: Codable {
    var StopID: String?
    var StopName: BusStopName?
    var StopPosition: BusStopPosition?
    var StopSequence: Int = 0
    var StopUID: String?
}

struct BusStopName: Codable {
    var En: String?
    var Zh_tw: String?
}

struct BusStopPosition: Codable {
    var GeoHash: String?
    var PositionLat: Float = 0.0
    var PositionLon: Float = 0.0
}
