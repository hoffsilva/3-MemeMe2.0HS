//
//  Meme.swift
//  MemeMe v1.0
//
//  Created by Hoff Henry Pereira da Silva on 24/08/15.
//  Copyright (c) 2015 Hoff Silva. All rights reserved.
//

import Foundation
import UIKit

struct Meme{
    
    
    var top: String
    var bottom: String
    var memedImagem: UIImage
    var originalImagem: UIImage
    
    init( topText: String, bottomText: String, memedImage: UIImage, originalImage: UIImage){
        memedImagem = memedImage
        originalImagem = originalImage
        top = topText
        bottom = bottomText
    }
    
}