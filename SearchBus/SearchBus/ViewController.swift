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
//        textView.backgroundColor = .red
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    var token = ""
    let appId = "lirune1122-e88be020-0cb5-43c5"
    let appKey = "ba3f23c3-4a63-4057-9eab-2e54371a22a6"
    let tokenURL = URL(string: "https://tdx.transportdata.tw/auth/realms/TDXConnect/protocol/openid-connect/token")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setBusRouteButtonConstraints()
        setBusInfoTextFieldConstraints()
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
        getToken()
    }
    
    func setBusInfoTextFieldConstraints() {
        view.addSubview(busInfoTextView)
        busInfoTextView.translatesAutoresizingMaskIntoConstraints = false
        busInfoTextView.topAnchor.constraint(equalTo: self.getBusRouteButton.bottomAnchor, constant: 20).isActive = true
        busInfoTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        busInfoTextView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        busInfoTextView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    func getToken() {
        var request = URLRequest(url: tokenURL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let data : Data = "grant_type=client_credentials&client_id=\(appId)&client_secret=\(appKey)".data(using: .utf8)!
        request.httpMethod = "POST"
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
                let createUserResponse = try decoder.decode(TDXToken.self, from: data)
                self.token = createUserResponse.access_token!
                self.getBusRoute(token: self.token)
            } catch  {
                print(error)
            }
        }.resume()
    }
    
    func getBusRoute(token: String) {
        let tokenURL = URL(string: "https://tdx.transportdata.tw/api/basic/v2/Bus/Route/City/Taipei?format=JSON")!
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            print(response.statusCode)
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([BusRoute].self, from: data)
                                
                var busRouteName : String = ""
                for response in response{
                    guard let routeName = response.RouteName?.Zh_tw else {return}
                    busRouteName = busRouteName + routeName + "\n"
                }
                DispatchQueue.main.async {
                    self.busInfoTextView.text = busRouteName
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

