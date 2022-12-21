//
//  BusStopRouteViewController.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/10/10.
//

import UIKit

class BusStopRouteViewController: UIViewController {
    
    var directionDepStops: [BusStops] = []
    var directionDesStops: [BusStops] = []
    var depOrDesIndex: Int = 0
    
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(BusRouteCell.self, forCellReuseIdentifier: "cell")
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
    }
}

extension BusStopRouteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if depOrDesIndex == 0 {
            return directionDepStops.count
        } else {
            return directionDesStops.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BusRouteCell else {
            return UITableViewCell()
        }
        
        guard let directionDepStop = directionDepStops[indexPath.row].StopName?.Zh_tw else {
            return UITableViewCell()
        }
        
        guard let directionDesStop = directionDesStops[indexPath.row].StopName?.Zh_tw else {
            return UITableViewCell()
        }
        
        let currentBusRouteStop: String
        
        if depOrDesIndex == 0 {
            currentBusRouteStop = directionDepStop
        } else {
            currentBusRouteStop = directionDesStop
        }
        
        cell.titleLbl.text = currentBusRouteStop
        
        return cell
    }
}

extension BusStopRouteViewController {
    
    func setupElements() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
