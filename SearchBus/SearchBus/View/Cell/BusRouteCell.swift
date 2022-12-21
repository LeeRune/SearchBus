//
//  BusRouteCell.swift
//  SearchBus
//
//  Created by 李易潤 on 2022/9/24.
//

import UIKit

class BusRouteCell: UITableViewCell {
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLbl)
        
        titleLbl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        titleLbl.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        titleLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
