//import UIKit
//import Lottie
//
//extension UIViewController {
//    func configureLottieRefreshControl() {
//        let refreshControl = UIRefreshControl()
//
//        // Create a custom view that will contain the Lottie animation and text label
//        let customRefreshView = UIView()
//
//        let animationView = LottieAnimationView(name: "refreshDownArrow")
//        animationView.loopMode = .loop
//        animationView.contentMode = .scaleAspectFit
//
//        // Calculate an appropriate size for the animation view based on the device frame
//        let screenSize = UIScreen.main.bounds.size
//        let animationSize = min(screenSize.width, screenSize.height) * 0.2 // Adjust the multiplier as needed
//
//        animationView.frame = CGRect(x: 0, y: 0, width: animationSize, height: animationSize)
//
//        let textLabel = UILabel()
//        textLabel.text = "Pull to refresh"
//        textLabel.textAlignment = .center
//        textLabel.textColor = .systemRed
//        textLabel.font = UIFont.systemFont(ofSize: 14.0)
//
//        // Add animation and text label to the custom view
//        customRefreshView.addSubview(animationView)
//        customRefreshView.addSubview(textLabel)
//
//        // Set up constraints for the animation view
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            animationView.centerXAnchor.constraint(equalTo: customRefreshView.centerXAnchor),
//            animationView.centerYAnchor.constraint(equalTo: customRefreshView.centerYAnchor),
//            animationView.widthAnchor.constraint(equalToConstant: animationSize),
//            animationView.heightAnchor.constraint(equalToConstant: animationSize)
//        ])
//
//        // Set up constraints for the text label
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            textLabel.centerXAnchor.constraint(equalTo: customRefreshView.centerXAnchor),
//            textLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 5) // Adjust the spacing as needed
//        ])
//
//        // Set the custom view for the refresh control
//        refreshControl.tintColor = .clear
//        refreshControl.addSubview(customRefreshView)
//        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
//
//        if let tableView = self.view as? UITableView {
//            tableView.refreshControl = refreshControl
//        }
//    }
//
//    @objc private func handleRefresh(_ sender: UIRefreshControl) {
//        // Handle the refresh action here
//        // You can call your data loading function or any other actions
//    }
//}
