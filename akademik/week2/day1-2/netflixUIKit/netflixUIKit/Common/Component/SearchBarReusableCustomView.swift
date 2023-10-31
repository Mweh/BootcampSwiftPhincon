//
//  SearchBarReusableCustomView.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 31/10/23.
//

import UIKit

class SearchBarReusableCustomView: UIView {
    
    let nibName = "SearchBarReusableCustomView"
    
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
//class ReusableFooter: UIView {
//    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var footerText: UILabel!
//}
