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
        let logButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "navigateToAddMeme:")
        self.navigationItem.rightBarButtonItem = logButton
    }
    @IBAction func dismissDetail(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailToEditSegue") {
            let addController = segue.destinationViewController as! AddMemeViewController
            
            addController.meme = meme
        }
    }

}
