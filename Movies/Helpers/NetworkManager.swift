//
//  NetworkManager.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/14/22.
//

import Foundation
import Reachability

class NetworkManager {
    
    init() {}
    static let shared = NetworkManager()
    
    var isConnectedToInternet: Bool { reachable(host: "apple.com") }
    
    func reachable(host: String) -> Bool {
        var res: UnsafeMutablePointer<addrinfo>?
        let n = getaddrinfo(host, nil, nil, &res)
        freeaddrinfo(res)
        return n == 0
    }
    
}
