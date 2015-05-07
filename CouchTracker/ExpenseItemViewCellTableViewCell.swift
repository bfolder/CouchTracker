//
//  ExpenseItemViewCellTableViewCell.swift
//  CouchTracker
//
//  Created by Heiko Dreyer on 03/12/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

import UIKit

class ExpenseItemViewCellTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.132, green: 0.122, blue: 0.132, alpha: 1.0)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "Avenir", size: 15)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "Avenir-Light", size: 11)
        label.textColor = UIColor(red: 0.631, green: 0.651, blue: 0.678, alpha: 1)
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "Avenir-Heavy", size: 13)
        label.textColor = AppDelegate.Colors.Green
        label.textAlignment = .Left
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.backgroundColor = UIColor(red: 0.932, green: 0.921, blue: 0.932, alpha: 1)
        view.alpha = 0.25
        return view
    }()
    
    // MARK: - Initialiers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(lineView)
        
        let metrics = ["topMargin": 20, "bottomMargin": 10,"leftMargin": 14, "lineMargin": 12]
        let views = ["titleLabel": titleLabel, "amountLabel": amountLabel, "lineView": lineView, "dateLabel": dateLabel];
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(leftMargin)-[amountLabel(70)]-(lineMargin)-[lineView(15)]-(lineMargin)-[dateLabel]-|", options: nil, metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(leftMargin)-[amountLabel(70)]-(lineMargin)-[lineView(15)]-(lineMargin)-[titleLabel]-|", options: nil, metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(topMargin)-[titleLabel]-[dateLabel(10)]-(bottomMargin)-|", options: nil, metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[lineView]|", options: nil, metrics: metrics, views: views))
        
        contentView.addConstraint(NSLayoutConstraint(item: amountLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        
        selectionStyle = .None;
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    
    // MARK: - Other accessors
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setColor(color: UIColor) {
        lineView.backgroundColor = color;
        amountLabel.textColor = color
    }
}
