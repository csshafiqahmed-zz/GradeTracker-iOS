//
//  ClassNameTableViewCell.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 8/13/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import UIKit

class ClassNameTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classOverallGradeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
