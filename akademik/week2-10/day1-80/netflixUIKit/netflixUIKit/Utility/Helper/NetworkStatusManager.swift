//
//  NetworkStatusManager.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 28/12/23.
//

import UIKit
import Reachability

protocol NetworkStatusDelegate: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

class NetworkStatusManager {
    static let shared = NetworkStatusManager()

    private var delegates = NSHashTable<AnyObject>.weakObjects()

    private let reachability = try! Reachability()

    private init() {
        startMonitoring()
    }

    private func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)

        do {
            try reachability.startNotifier()
        } catch {
            print("Failed to start reachability notifier")
        }
    }

    @objc private func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability

        if reachability.connection != .unavailable {
            // Internet connection is available
            hideLoadingIndicator()
        } else {
            // No internet connection
            showLoadingIndicator()
        }
    }

    func addDelegate(_ delegate: NetworkStatusDelegate) {
        delegates.add(delegate)
    }

    func removeDelegate(_ delegate: NetworkStatusDelegate) {
        delegates.remove(delegate)
    }

    private func showLoadingIndicator() {
        for delegate in delegates.allObjects {
            (delegate as? NetworkStatusDelegate)?.showLoadingIndicator()
        }
    }

    private func hideLoadingIndicator() {
        for delegate in delegates.allObjects {
            (delegate as? NetworkStatusDelegate)?.hideLoadingIndicator()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}

class ExampleViewController: UIViewController, NetworkStatusDelegate {
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let waitingLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for network"
        label.textColor = .gray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNetworkStatusManager()
    }

    private func setupUI() {
        // Add loading indicator and waiting label to navigation title view
        let titleView = UIStackView(arrangedSubviews: [loadingIndicator, waitingLabel])
        titleView.axis = .horizontal
        titleView.spacing = 8
        navigationItem.titleView = titleView
    }

    private func setupNetworkStatusManager() {
        // Use the shared instance of NetworkStatusManager
        let networkStatusManager = NetworkStatusManager.shared
        networkStatusManager.addDelegate(self)
    }

    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }

    deinit {
        NetworkStatusManager.shared.removeDelegate(self)
    }
}
