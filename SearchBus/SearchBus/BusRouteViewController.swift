//
//  ViewController.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/9/18.
//

import UIKit

class BusRouteViewController: UIViewController {
    
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
    
    lazy var loadingVC: UIViewController = {
        let loadingVC = LoadingViewController()
        loadingVC.view.tag = 100
        
        return loadingVC
    }()
    
    let getBusInfo: GetBusInfo = GetBusInfo()
    var busRouteList: [String] = []
    var filteredBusRouteList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "search"
        navigationItem.searchController = searchController
        
        print(busRouteList.isEmpty)
        
        if busRouteList.isEmpty {
            setupLoadingView()
        } else {
            setupElements()
        }
        
        getBusInfo.delegate = self
        getBusInfo.getToken()
        
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

extension BusRouteViewController: BusInfoDelegate {
    func didGetBusRoute(data: [String]) {
        self.busRouteList = data
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.layer.zPosition = 0
            self.removeLoadingView()
            self.setupElements()
            self.tableView.reloadData()
        }
    }
    
    func didGetBusDepNDes(data: [String : String]) {
    }
    
    func didGetBusStops(data: [String : [BusStops]]) {
    }
}

extension BusRouteViewController: UITableViewDelegate, UITableViewDataSource {
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
        let busRouteInfoViewController = BusRouteInfoViewController()
        
        if isFiltering() {
            busRouteInfoViewController.busRoute = filteredBusRouteList[indexPath.row]
        } else {
            busRouteInfoViewController.busRoute = busRouteList[indexPath.row]
        }
        
        self.navigationController?.pushViewController(busRouteInfoViewController, animated: true)
    }
}

extension BusRouteViewController {
    
    func setupElements() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    func setupLoadingView() {
        
        self.navigationController?.navigationBar.layer.zPosition = -1
        
        self.addChild(loadingVC)
        view.addSubview(loadingVC.view)
        loadingVC.didMove(toParent: self.navigationController)
    }
    
    func removeLoadingView(){
        guard let viewWithTag = self.loadingVC.view.viewWithTag(100) else {
            return
        }
        
        viewWithTag.removeFromSuperview()
    }
}

extension BusRouteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterBusRouteForSearchText(searchText: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        tableView.reloadData()
    }
}
