//
//  MemeDetailViewController.swift
//  Meme Me 2.0
//
//  Created by Hoff Henry Pereira da Silva on 30/09/15.
//  Copyright © 2015 Hoff Henry Pereira da Silva. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memedImage: UIImageView!
    
    var memed : Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memedImage.image = memed.memedImagem
    }

}
