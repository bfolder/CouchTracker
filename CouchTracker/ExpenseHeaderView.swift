//
//  ExpenseHeaderView.swift
//  CouchTracker
//
//  Created by Heiko Dreyer on 03/12/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

import UIKit

class ExpenseHeaderView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "Avenir", size: 15)
        label.textColor = UIColor(red: 0.514, green: 0.525, blue: 0.541, alpha: 1)
        label.text = "Your expenses:"
        label.textAlignment = .Center
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "Avenir", size: 15)
        label.textColor = UIColor(red: 0.514, green: 0.525, blue: 0.541, alpha: 1)
        label.text = "32123 $"
        label.textAlignment = .Left
        return label
        }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.backgroundColor = UIColor(red: 0.906, green: 0.914, blue: 0.918, alpha: 1)
        return view
    }()
    
    func setColor(color: UIColor) {
        amountLabel.textColor = color;
    }
    
    // MARK: - Initialiers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 1, alpha: 0.95)
        addSubview(titleLabel)
        addSubview(amountLabel)
        addSubview(lineView)
        
        let views = ["titleLabel": titleLabel, "lineView": lineView, "amountLabel": amountLabel]
        let metrics = ["vMargin": 5, "hMargin": 8]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(hMargin)-[titleLabel(105)]-[amountLabel]-(hMargin)-|", options: nil, metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(vMargin)-[titleLabel]-(vMargin)-[lineView(1)]|", options: nil, metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[lineView]|", options: nil, metrics: metrics, views: views))
        addConstraint(NSLayoutConstraint(item: amountLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
