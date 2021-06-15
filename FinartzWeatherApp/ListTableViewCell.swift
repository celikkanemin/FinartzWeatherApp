//
//  ListTableViewCell.swift
//  FinartzWeatherApp
//
//  Created by Emin Çelikkan on 11.06.2021.
//

import UIKit

class ListTableViewCell: UITableViewCell {

  
    @IBOutlet weak var tempLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
