//
//  BusRouteInfoViewController.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/10/10.
//

import UIKit

class BusRouteInfoViewController: UIViewController, UIPageViewControllerDelegate {
    
    lazy var segmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.tintColor = UIColor.black

        segmentedControl.backgroundColor = UIColor.lightGray

        segmentedControl.addTarget(self, action: #selector(onChange), for: .valueChanged)
        
        return segmentedControl
    }()
    
    lazy var pageViewControl: UIPageViewController = {
        var pageViewControl = UIPageViewController()
        pageViewControl.view.translatesAutoresizingMaskIntoConstraints = false

        pageViewControl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageViewControl.delegate = self
        pageViewControl.isEditing = true
        
        return pageViewControl
    }()
    
    let busStopRouteViewController = BusStopRouteViewController()
    
    var busRoute: String = ""
    
    let getBusInfo: GetBusInfo = GetBusInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBusInfo.delegate = self
        getBusInfo.getBusDepNDes(route: busRoute)
        getBusInfo.getBusStops(route: busRoute, direction: 0)
        
        self.setupElements()
    }
    
    @objc func onChange(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        busStopRouteViewController.depOrDesIndex = sender.selectedSegmentIndex
        busStopRouteViewController.reloadTableView()
    }
}

extension BusRouteInfoViewController {
    
    func setupElements() {
        self.navigationItem.title = busRoute
        
        self.addChild(pageViewControl)
        self.view.addSubview(pageViewControl.view)
        
        self.view.addSubview(segmentedControl)
        
        segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        pageViewControl.view.frame = CGRect.init(x: 0, y: 140, width: self.view.frame.width, height: self.view.frame.height - 140)
    
        pageViewControl.setViewControllers([busStopRouteViewController], direction: .forward, animated: false)
    }
}

extension BusRouteInfoViewController: BusInfoDelegate {
    func didGetBusRoute(data: [String]) {
    }
    
    func didGetBusDepNDes(data: [String : String]) {
        guard let routeDep = data["routeDep"] else {return}
        guard let routeDes = data["routeDes"] else {return}
        print(routeDep+","+routeDes)
        
        DispatchQueue.main.async {
            self.segmentedControl.insertSegment(withTitle: "往\(routeDes)", at: 0, animated: true)
            self.segmentedControl.insertSegment(withTitle: "往\(routeDep)", at: 1, animated: true)
            self.segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    func didGetBusStops(data: [String : [BusStops]]) {
        guard let directionDep = data["directionDep"] else {return}
        guard let directionDes = data["directionDes"] else {return}
        
        DispatchQueue.main.async {
            self.busStopRouteViewController.directionDepStops = directionDep
            self.busStopRouteViewController.directionDesStops = directionDes
            self.busStopRouteViewController.reloadTableView()
        }
    }
}
