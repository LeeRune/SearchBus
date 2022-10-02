//
//  BusRouteInfo.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/10/2.
//

import UIKit

class BusRouteInfo: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        selectedIndex = viewController.view.tag
        segmentedControl.selectedSegmentIndex = selectedIndex
        let pageIndex = viewController.view.tag - 1
        if pageIndex < 0 {
            return nil
        }
        return viewControllerArr[pageIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        selectedIndex = viewController.view.tag
        segmentedControl.selectedSegmentIndex = selectedIndex
        let pageIndex = viewController.view.tag + 1
        if pageIndex > 1 {
            return nil
        }
        return viewControllerArr[pageIndex]
    }
    
    
    lazy var segmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.tintColor = UIColor.black

        segmentedControl.backgroundColor = UIColor.lightGray

        segmentedControl.addTarget(self, action: #selector(onChange), for: .valueChanged)
        
        return segmentedControl
    }()
    
    var busRoute: String = ""
    
    let getBusInfo: GetBusInfo = GetBusInfo()
    let fullScreenSize = UIScreen.main.bounds.size
    
    var pageViewControl = UIPageViewController()
    var viewControllerArr = Array<UIViewController>()
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBusInfo.delegate = self
        getBusInfo.getBusDepNDes(route: busRoute)
        getBusInfo.getBusStops(route: busRoute, direction: 0)
        
        self.setupElements()
        
        pageViewControl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewControl.view.frame = CGRect.init(x: 0, y: 144, width: self.view.frame.width, height: self.view.frame.height - 144)
        pageViewControl.delegate = self
        pageViewControl.dataSource = self
        pageViewControl.isEditing = true
        self.addChild(pageViewControl)
        self.view.addSubview(pageViewControl.view)
        
        let viewController1 = UIViewController()
        viewController1.view.backgroundColor = UIColor.init(red: 1, green: 0.2, blue: 0.4, alpha: 0.3)
        viewController1.view.tag = 0

        let viewController2 = UIViewController()
        viewController2.view.backgroundColor = UIColor.init(red: 0.4, green: 0.3, blue: 1, alpha: 0.3)
        viewController2.view.tag = 1

        viewControllerArr.append(viewController1)
        viewControllerArr.append(viewController2)

        pageViewControl.setViewControllers([viewControllerArr[0]], direction: .forward, animated: false)
    }
    
    @objc func onChange(sender: UISegmentedControl) {
        pageViewControl.setViewControllers([viewControllerArr[sender.selectedSegmentIndex]], direction: .forward, animated: false)
    }
}

extension BusRouteInfo {
    
    func setupElements() {
        self.navigationItem.title = busRoute
        self.view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
    }
}

extension BusRouteInfo: BusInfoDelegate {
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
    
    func didGetBusStops(data: String) {
    }
}
