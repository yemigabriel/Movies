//
//  NetworkManager.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/14/22.
//

import Foundation
import Reachability

class NetworkManager: NSObject {
    var reachability: Reachability!
    static let shared = NetworkManager()
    
    override init() {
        super.init()
        try? reachability = Reachability()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStatusChanged(_:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    static func stopNotifier() -> Void {
        do {
            try (NetworkManager.shared.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection != .unavailable {
            completed(NetworkManager.shared)
        }
    }
    
    func isNotReachable() -> Bool {
        if (NetworkManager.shared.reachability).connection == .unavailable {
            return true
        }
        return false
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
    }
    
}
