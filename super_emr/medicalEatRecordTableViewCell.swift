//
//  medicalEatRecordTableViewCell.swift
//  super_emr
//
//  Created by 王佳华 on 8/21/16.
//  Copyright (c) 2016 王佳华. All rights reserved.
//

import UIKit

class medicalEatRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var medicine:UILabel!
    @IBOutlet weak var method:UILabel!
    @IBOutlet weak var how_use:UILabel!
    @IBOutlet weak var eatTime:UILabel!
    @IBOutlet weak var resultDescription:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
