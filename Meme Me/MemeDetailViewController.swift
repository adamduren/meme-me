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
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "navigateToAddMeme:")
        navigationItem.rightBarButtonItem = editButton
    }
    
    func navigateToAddMeme(sender: AnyObject?) {
        performSegueWithIdentifier("DetailToEditSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailToEditSegue") {
            let addController = segue.destinationViewController as! AddMemeViewController
            
            addController.meme = meme
        }
    }

}
