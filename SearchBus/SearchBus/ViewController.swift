//
//  ViewController.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/9/18.
//

import UIKit

class ViewController: UIViewController {
    
    let getBusRouteButton : UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("getBusRoute", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(getBusRouteButtonClick), for: .touchUpInside)
        return button
    }()
    
    let busInfoTextView : UITextView = {
        let textView = UITextView()
        textView.text = "some string"
        textView.textAlignment = .left
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    let getBusInfo: GetBusInfo = GetBusInfo()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setBusRouteButtonConstraints()
        setBusInfoTextFieldConstraints()
        
        getBusInfo.delegate = self
        getBusInfo.getToken()
    }
    
    func setBusRouteButtonConstraints() {
        view.addSubview(getBusRouteButton)
        getBusRouteButton.translatesAutoresizingMaskIntoConstraints = false
        getBusRouteButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        getBusRouteButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        getBusRouteButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        //        getBusRouteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        getBusRouteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func getBusRouteButtonClick(sender: UIButton!) {
        getBusInfo.getBusRoute()
//        getBusInfo.getBusDepNDes(route: "617")
//        getBusInfo.getBusStops(route: "617", direction: 0)
    }
    
    func setBusInfoTextFieldConstraints() {
        view.addSubview(busInfoTextView)
        busInfoTextView.translatesAutoresizingMaskIntoConstraints = false
        busInfoTextView.topAnchor.constraint(equalTo: self.getBusRouteButton.bottomAnchor, constant: 20).isActive = true
        busInfoTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        busInfoTextView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        busInfoTextView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
}

extension ViewController: BusInfoDelegate {
    func didGetBusRoute(data: String) {
        DispatchQueue.main.async {
            self.busInfoTextView.text = data
        }
    }
    
    func didGetBusDepNDes(data: String) {
        DispatchQueue.main.async {
            self.busInfoTextView.text = data
        }
    }
    
    func didGetBusStops(data: String) {
        DispatchQueue.main.async {
            self.busInfoTextView.text = data
        }
    }
}
