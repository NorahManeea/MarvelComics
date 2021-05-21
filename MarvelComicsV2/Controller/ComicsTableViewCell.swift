//
//  ComicsTableViewCell.swift
//  MarvelComicsV2
//
//  Created by Norah Almaneea on 18/05/2021.
//

import UIKit
import Kingfisher

class ComicsTableViewCell: UITableViewCell {

    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
   
    

    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func prepareHero(with hero: Hero) {
        let delay = 3 // seconds
        self.activityInd.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            self.activityInd.stopAnimating()
            self.activityInd.isHidden = true
            self.lbName.text = hero.name
            self.lbDescription.text = hero.description
            if let url = URL(string: hero.thumbnail.url) {
                self.ivThumb.kf.setImage(with: url)
            } else {
                self.ivThumb.image = nil
            }
        }
        ivThumb.layer.cornerRadius = 10
        ivThumb.layer.borderColor = UIColor.darkGray.cgColor
        ivThumb.layer.borderWidth = 1

    }
}
