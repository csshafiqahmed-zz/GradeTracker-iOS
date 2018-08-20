//
//  CategoryTableViewCell.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 6/19/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    /**
     *  UIElements
     */
    var categoryNameLabel: UILabel!
    var categoryWeightLabel: UILabel!
    var categoryAverageLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupCategoryNameLabel()
        setupCategoryWeightLabel()
        setupCategoryAvergaeLabel()
        
        self.addConstraintsWithFormat(format: "H:|-10-[v0]-30-[v1(70)]-30-[v2(70)]-10-|", views: categoryNameLabel, categoryWeightLabel, categoryAverageLabel)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: categoryNameLabel)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: categoryWeightLabel)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: categoryAverageLabel)
    }
    
    private func setupCategoryNameLabel() {
        categoryNameLabel = UILabel()
        categoryNameLabel.textColor = .black
        categoryNameLabel.textAlignment = .left
        categoryNameLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(categoryNameLabel)
    }
    
    private func setupCategoryWeightLabel() {
        categoryWeightLabel = UILabel()
        categoryWeightLabel.textColor = .black
        categoryWeightLabel.textAlignment = .left
        categoryWeightLabel.font = UIFont(name: "HelveticaNeue", size: 17.0)
        categoryWeightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(categoryWeightLabel)
    }
    
    private func setupCategoryAvergaeLabel() {
        categoryAverageLabel = UILabel()
        categoryAverageLabel.textColor = .black
        categoryAverageLabel.textAlignment = .right
        categoryAverageLabel.font = UIFont(name: "HelveticaNeue", size: 17.0)
        categoryAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(categoryAverageLabel)
    }
}
