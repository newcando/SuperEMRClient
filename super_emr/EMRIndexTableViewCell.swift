//
//  EMRIndexTableViewCell.swift
//  super_emr
//
//  Created by 王佳华 on 11/30/15.
//  Copyright (c) 2015 王佳华. All rights reserved.
//

import UIKit


class EMRIndexTableViewCell: UITableViewCell {

    @IBOutlet weak var symptomDescription:UILabel!
    @IBOutlet weak var upload_datetime:UILabel!
    @IBOutlet weak var RecordOccurTime:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
