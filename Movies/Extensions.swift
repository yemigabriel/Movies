//
//  Extensions.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/6/22.
//

import UIKit

extension UIView {
    static func screenSize() -> CGRect {
        UIScreen.main.bounds
    }
    
    static let smallFont = UIFont(name: "Avenir", size: 14)
    static let font = UIFont(name: "Avenir", size: 17)
    static let boldFont = UIFont(name: "Avenir-Medium", size: 17)
    static let titleFont = UIFont(name: "Avenir-Heavy", size: 20)
    
    
}

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.date(from: self) ?? Date()
    }
}

