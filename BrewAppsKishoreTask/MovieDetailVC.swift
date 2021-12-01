//
//  MovieDetailVC.swift
//  BrewAppsKishoreTask
//
//  Created by Kishore Babu on 01/12/21.
//

import UIKit

class MovieDetailVC: UIViewController {

    @IBOutlet weak var movieDetailImg: UIImageView!
    var imgURLString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: imgURLString)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
        movieDetailImg.image = UIImage(data: imageData)
            movieDetailImg.contentMode = .scaleToFill
        }
        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
