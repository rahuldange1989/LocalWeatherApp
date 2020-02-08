//
//  HourlyTableViewCell.swift
//  LocalWeatherApp
//
//  Created by Rahul Dange on 08/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var weatherImageView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
	
	// MARK: - Internal methods -
	func configureCell(currentHourData: Currently) {
		if let imageName = currentHourData.icon {
			do {
				let data = try Data.init(contentsOf: URL.init(string: IMAGE_URL_PATH + imageName + ".png")!)
				self.weatherImageView.image = UIImage.init(data: data)
				
			} catch {
				print(error.localizedDescription)
			}
		}
		
		self.tempLabel.text = "\(Int(currentHourData.temperature?.rounded() ?? 0))° " + (currentHourData.summary ?? "")
		
		if let timestamp = currentHourData.time {
			self.timeLabel.text = Utility.getHourFrom(timeStamp: timestamp)
		} else {
			self.timeLabel.text = "-"
		}
	}
}
