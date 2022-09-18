//
//  BusRoute.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/9/18.
//

import Foundation

struct BusRoute: Codable {
    var RouteName: BusRouteName?
}

struct BusRouteName: Codable {
    var En: String?
    var Zh_tw: String?
}

//struct BusRoute: Codable {
//    var AuthorityID: String?
//    var BusRouteType: Int = 0
//    var City: String?
//    var CityCode: String?
//    var DepartureStopNameEn: String?
//    var DepartureStopNameZh: String?
//    var DestinationStopNameEn: String?
//    var DestinationStopNameZh: String?
//    var FareBufferZoneDescriptionEn: String?
//    var FareBufferZoneDescriptionZh: String?
//    var HasSubRoutes: Bool = false
//    var Operators = [BusRouteOperators]()
//    var ProviderID: String?
//    var RouteID: String?
//    var RouteMapImageUrl: String?
//    var RouteName: BusRouteName?
//    var RouteUID: String?
//    var SubRoutes = [BusSubRoutes]()
//    var TicketPriceDescriptionEn: String?
//    var TicketPriceDescriptionZh: String?
//    var UpdateTime: String?
//    var VersionID: Int = 0
//}
//
//struct BusRouteOperators: Codable {
//    var OperatorCode: String?
//    var OperatorID: String?
//    var OperatorName: BusRouteOperatorsOperatorName?
//    var OperatorNo: String?
//}
//
//struct BusRouteOperatorsOperatorName: Codable {
//    var En: String?
//    var Zh_tw: String?
//}
//
//struct BusRouteName: Codable {
//    var En: String?
//    var Zh_tw: String?
//}
//
//struct BusSubRoutes: Codable {
//    var Direction: Int = 0
//    var FirstBusTime: String?
//    var HolidayFirstBusTime: String?
//    var HolidayLastBusTime: String?
//    var LastBusTime: String?
//    var OperatorIDs = [String]()
//    var SubRouteID: String?
//    var SubRouteName: BusSubRoutesSubRouteName?
//    var SubRouteUID: String?
//}
//
//struct BusSubRoutesSubRouteName: Codable {
//    var En: String?
//    var Zh_tw: String?
//}
