//
//  ClassTableViewCell.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/18/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {
    
    /**
     *  UIElements
     */
    var classNameLabel: UILabel!
    var classOverallGradeLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupClassNameLabel()
        setupClassOverallGradeLabel()
        
        self.addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1(110)]-10-|", views: classNameLabel, classOverallGradeLabel)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: classNameLabel)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: classOverallGradeLabel)
    }
    
    private func setupClassNameLabel() {
        classNameLabel = UILabel()
        classNameLabel.textColor = .black
        classNameLabel.textAlignment = .left
        classNameLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        classNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(classNameLabel)
    }
    
    private func setupClassOverallGradeLabel() {
        classOverallGradeLabel = UILabel()
        classOverallGradeLabel.textColor = .black
        classOverallGradeLabel.textAlignment = .right
        classOverallGradeLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        classOverallGradeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(classOverallGradeLabel)
    }

}
