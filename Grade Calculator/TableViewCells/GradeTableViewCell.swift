//
//  GradeTableViewCell.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/19/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit

class GradeTableViewCell: UITableViewCell {
    
    /**
     *  UIElements
     */
    var gradeNameLabel: UILabel!
    var gradeScoreLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupGradeNameLabel()
        setupGradeScoreLabel()
        
        self.addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1(110)]-10-|", views: gradeNameLabel, gradeScoreLabel)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: gradeNameLabel)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: gradeScoreLabel)
    }
    
    private func setupGradeNameLabel() {
        gradeNameLabel = UILabel()
        gradeNameLabel.textColor = .black
        gradeNameLabel.textAlignment = .left
        gradeNameLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        gradeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(gradeNameLabel)
    }
    
    private func setupGradeScoreLabel() {
        gradeScoreLabel = UILabel()
        gradeScoreLabel.textColor = .black
        gradeScoreLabel.textAlignment = .right
        gradeScoreLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        gradeScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(gradeScoreLabel)
    }
    
}
