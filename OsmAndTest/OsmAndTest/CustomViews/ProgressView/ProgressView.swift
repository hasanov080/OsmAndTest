//
//  ProgressView.swift
//  OsmAndTest
//
//  Created by Hasan Hasanov on 27.09.22.
//

import UIKit
@IBDesignable
class ProgressView: UIView {
    
    
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressLine: UIView!{
        didSet{
            progressLine.layer.cornerRadius = self.frame.height/2
        }
    }
    
    
    
    @IBInspectable
    var background: UIColor{
        get{
            self.backgroundColor ?? .black
        }set{
            self.backgroundColor = newValue
        }
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    private func setupView(){
        let view = Bundle.main.loadNibNamed("ProgressView", owner: self)?.first as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    func updateProgress(frac: Double){
        progressConstraint.isActive = false
        
        progressConstraint = progressLine.widthAnchor.constraint(equalToConstant: frac * self.frame.width)
        progressConstraint.isActive = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
