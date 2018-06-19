//
//  CategoryTableViewCell.swift
//  Grade Calculator
//
//  Created by Satish Boggarapu on 8/14/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryWeight: UILabel!
    @IBOutlet weak var categoryAverage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
