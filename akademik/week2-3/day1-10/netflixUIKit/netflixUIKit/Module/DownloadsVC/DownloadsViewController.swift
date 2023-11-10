//
//  DownloadsViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 30/10/23.
//

import StepSlider
import UIKit

class DownloadsViewController: UIViewController {
    @IBOutlet weak var stepSlider: StepSlider!
    
    let opsi = ["1", "2", "3"]
    
    @IBOutlet weak var stepSliderValue: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        setup()
//        stepSlider.addTarget(self, action: #selector(stepSliderValueChanged), for: .valueChanged)
    }
    
    func setup(){
        stepSlider.trackHeight = 4.0
        stepSlider.trackCircleRadius = 8.0
        stepSlider.sliderCircleRadius = 12.0
        stepSlider.labels = opsi
        stepSlider.labelColor = UIColor.black
        stepSlider.index = 2 // Set the initial index
        stepSlider.sliderCircleColor = UIColor.black
    }
    
    @objc func stepSliderValueChanged(){
        let selectedValue = stepSlider.index
        stepSliderValue.text = opsi[Int(selectedValue)]
    }
    
}



