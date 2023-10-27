//
//  ReusableFooter.swift
//  Test
//
//  Created by Muhammad Fahmi on 27/10/23.
//

import UIKit

class ReusableFooter: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var footerText: UILabel!
    
    let nibName = "ReusableFooter"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
