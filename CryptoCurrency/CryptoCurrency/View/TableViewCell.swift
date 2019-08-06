//
//  TableViewCell.swift
//  CryptoCurrency
//
//  Created by Bartu akman on 25.10.2018.
//  Copyright © 2018 Bartu akman. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var changeImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var coin: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func  updateUI (p: Crypto) {
        
 
        coin.text =  p.name
        price .text =  p.priceUsd + "$"
          changeImage.image =  UIImage(named: "arrowDownHardEdge")
         changeImage.backgroundColor = UIColor.bitcoinRed
 
  
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
