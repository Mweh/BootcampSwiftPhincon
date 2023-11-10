//
//  SearchBarReusableCustomView.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 31/10/23.
//

import RxCocoa
import RxSwift
import UIKit

@IBDesignable
class SearchBarReusableCustomView: UIView {
    
    let searchQuerySubject = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var textField: UITextField!
    let nibName = "SearchBarReusableCustomView"
    
    private func observeTextChanges() {
        textField.rx.text
            .orEmpty // Ensure we have a non-nil, non-empty string
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance) // Add a debounce to avoid sending too many requests
            .distinctUntilChanged() // Only emit unique values
            .bind(to: searchQuerySubject)
            .disposed(by: disposeBag)
    }
    
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
