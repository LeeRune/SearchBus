//
//  ViewController.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/9/18.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(BusRouteCell.self, forCellReuseIdentifier: "cell")
        
        return tv
    }()
    
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.placeholder = "搜尋公車路線"
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        
        s.searchBar.delegate = self
        
        return s
    }()
    
    let getBusInfo: GetBusInfo = GetBusInfo()
    var busRouteList: [String] = []
    var filteredBusRouteList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "search"
        navigationItem.searchController = searchController
        
        getBusInfo.delegate = self
        getBusInfo.getToken()
        setupElements()
    }
    
    func filterBusRouteForSearchText(searchText: String) {
        filteredBusRouteList = busRouteList.filter({ (busRoute) -> Bool in
            return busRoute.uppercased().contains(searchText.uppercased())
        })
        tableView.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive
    }
}

extension ViewController: BusInfoDelegate {
    func didGetBusRoute(data: [String]) {
        self.busRouteList = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didGetBusDepNDes(data: [String : String]) {
    }
    
    func didGetBusStops(data: String) {
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredBusRouteList.count
        } else {
            return busRouteList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BusRouteCell else {
            return UITableViewCell()
        }
        
        let currentBusRoute: String
        
        if isFiltering() {
            currentBusRoute = filteredBusRouteList[indexPath.row]
        } else {
            currentBusRoute = busRouteList[indexPath.row]
        }
        
        cell.titleLbl.text = currentBusRoute
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let busRouteInfoViewController = BusRouteInfo()
        
        if isFiltering() {
            busRouteInfoViewController.busRoute = filteredBusRouteList[indexPath.row]
        } else {
            busRouteInfoViewController.busRoute = busRouteList[indexPath.row]
        }
        
        self.navigationController?.pushViewController(busRouteInfoViewController, animated: true)
    }
}

extension ViewController {
    
    func setupElements() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterBusRouteForSearchText(searchText: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        tableView.reloadData()
    }
}
