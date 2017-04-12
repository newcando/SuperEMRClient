//
//  mydoctorTableViewCell.swift
//  super_emr
//
//  Created by 王佳华 on 10/2/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class mydoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    var link = ""
    
    func refreshUserImage(){
        Alamofire.request(.GET, self.link, parameters: nil)
            .validate()
            .response { request, response, data, error in
                let image = UIImage(data: data! as NSData)
                self.UserImage.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
