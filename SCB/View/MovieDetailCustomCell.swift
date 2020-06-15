//
//  MovieDetailCustomCell.swift
//  SCB
//
//  Created by MAPRO08 on 15/06/20.
//  Copyright © 2020 MAPRO08. All rights reserved.
//

import UIKit

class MovieDetailCustomCell: UITableViewCell {
    @IBOutlet var imageForPoster: UIImageView!
    @IBOutlet var labelForTitle: UILabel!
    @IBOutlet var labelForCategory: UILabel!
    @IBOutlet var labelForDuration: UILabel!
    @IBOutlet var labelForRating: UILabel!
    @IBOutlet var labelForSynopsis: UILabel!
    @IBOutlet var labelForScore: UILabel!
    @IBOutlet var labelForReview:UILabel!
    @IBOutlet var labelForPopularity:UILabel!
    @IBOutlet var labelForDirector: UILabel!
    @IBOutlet var labelForWriter: UILabel!
    @IBOutlet var labelForActor: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
