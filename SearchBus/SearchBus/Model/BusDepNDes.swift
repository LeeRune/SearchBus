//
//  BusDepNDes.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/9/22.
//

import Foundation

struct BusDepNDes: Codable {
    var RouteID: String?
    var RouteName: BusRouteName?
    var DepartureStopNameEn: String?
    var DepartureStopNameZh: String?
    var DestinationStopNameEn: String?
    var DestinationStopNameZh: String?
}
