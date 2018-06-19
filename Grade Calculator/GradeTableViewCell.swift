//
//  GradeTableViewCell.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 8/19/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import UIKit

class GradeTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var gradeName: UILabel!
    @IBOutlet weak var gradeScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
