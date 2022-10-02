//
//  BusInfoDelegate.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/9/24.
//

import Foundation

protocol BusInfoDelegate: AnyObject {
    func didGetBusRoute(data: [String])
    func didGetBusDepNDes(data: [String : String])
    func didGetBusStops(data: String)
}
