//
//  CountriesMapCell.swift
//  OsmAndTest
//
//  Created by Hasan Hasanov on 27.09.22.
//

import UIKit

class CountriesMapCell: UITableViewCell {

    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!{
        didSet{
            progressBar.isHidden = false
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setupCountriesCell(country: Region, progress: Float?){
        countryName.text = country.name.capitalizingFirstLetter()
        selectionStyle = .none
        if country.region == nil{
            
            rightIcon.isHighlighted = true
        }else{
            
            rightIcon.isHighlighted = false
        }
        if progress == nil{
            progressBar.isHidden = true
        }else{
            progressBar.isHidden = false
            progressBar.progress = progress!
        }
        
    }
    func setupRegionsCell(region: PurpleRegion?, progress: Float? = nil){
        if region?.translate?.substringsBetween("=", ";").first! == ""{
            countryName.text = String(describing: region?.translate?.split(separator: ";").first! ?? "").capitalizingFirstLetter()
        }else{
            if region?.translate == nil{
                countryName.text = region?.name.capitalizingFirstLetter()
            }else{
                countryName.text = region?.translate?.substringsBetween("=", ";").first!.capitalizingFirstLetter()
            }
            
        }
        
        selectionStyle = .none
        if region?.region == nil{
            rightIcon.isHighlighted = true
        }else{
            rightIcon.isHighlighted = false
        }
        if progress == nil{
            progressBar.isHidden = true
        }else{
            progressBar.isHidden = false
            progressBar.progress = progress!
        }
    }
}
