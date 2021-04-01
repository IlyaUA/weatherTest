//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    static var identifier = "hourlyCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
