//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Adam Duren on 11/4/15.
//  Copyright © 2015 Adam Duren. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme!
    
    @IBOutlet var memeImage: UIImageView!
    
    override func viewDidLoad() {
        memeImage.image = meme.memedImage;
    }

}
