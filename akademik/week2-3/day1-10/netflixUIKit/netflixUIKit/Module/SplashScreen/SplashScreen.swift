//
//  SplashScreen.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 31/10/23.
//

import Lottie
import UIKit

class SplashScreen: UIViewController {
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delay()
        lottieConfig()
    }
    
    func delay(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if let navigation = self.navigationController {
                let vc = LoginViewController()
                navigation.pushViewController(vc, animated: true)
            }
        }
    }
    
    func lottieConfig(){

        animationView = .init(name: "netflixLottie")
        
        animationView!.frame = view.bounds
        
        // 3. Set animation content mode
        
        animationView!.contentMode = .scaleAspectFit
        
        // 4. Set animation loop mode
        
        animationView!.loopMode = .loop
        
        // 5. Adjust animation speed
        
        animationView!.animationSpeed = 0.5
        
        view.addSubview(animationView!)
        
        // 6. Play animation
        
        animationView!.play()

    }
    
}
