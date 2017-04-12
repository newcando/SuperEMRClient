//
//  EMRPhotoTableViewCell.swift
//  super_emr
//
//  Created by 王佳华 on 8/20/16.
//  Copyright (c) 2016 王佳华. All rights reserved.
//

import UIKit

class EMRPhotoTableViewCell: UITableViewCell {

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
