//
//  ViewController.swift
//  Meme Me
//
//  Created by Adam Duren on 9/7/15.
//  Copyright (c) 2015 Adam Duren. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var memeVIew: UIView!
    
    var orientation: UIInterfaceOrientation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureCameraButton()
        configureTextField(topTextField)
        configureTextField(bottomTextField)
        resetViewState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        orientation = UIApplication.sharedApplication().statusBarOrientation;
        updateConstraints()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.editing {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configureCameraButton() {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func configureTextField(textField: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.delegate = self
    }
    
    func pickImage(sourceType:UIImagePickerControllerSourceType?)  {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if sourceType != nil {
            pickerController.sourceType = sourceType!
        }
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func updateConstraints() {
        let parentFrame = self.imageView.superview!.frame
        
        if let image = self.imageView.image {
            if (image.size.width > image.size.height && orientation.isPortrait) {
                imageViewHeightConstraint.constant = parentFrame.width * image.size.height / image.size.width
                imageViewWidthConstraint.constant = parentFrame.width;
            } else {
                imageViewHeightConstraint.constant = parentFrame.height
                imageViewWidthConstraint.constant = parentFrame.height * image.size.width / image.size.height
            }
        } else {
            imageViewHeightConstraint.constant = parentFrame.height
            imageViewWidthConstraint.constant = parentFrame.width
        }
        self.imageView.superview!.layoutIfNeeded()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            updateConstraints()
            shareButton.enabled = true
        }
    
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        
        UIGraphicsBeginImageContext(memeVIew.frame.size)
        memeVIew.drawViewHierarchyInRect(memeVIew.bounds,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        pickImage(nil)
    }
    
    @IBAction func pickFromCamera(sender: UIBarButtonItem) {
        pickImage(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func cancelEditing(sender: UIBarButtonItem) {
        resetViewState()
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> Void in
            if (completed) {
                self.saveMeme(memedImage)
            }
        }
        
        self.presentViewController(shareController, animated: true, completion: nil)
    }
    
    func saveMeme(memedImage: UIImage) {
        let meme = Meme(
            topText: self.topTextField.text!,
            bottomText: self.bottomTextField.text!,
            originalImage: self.imageView.image!,
            memedImage: memedImage
        )
        
        var memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes;
        
        memes.append(meme)
    }
    
    func resetViewState() {
        topTextField.text = "Top Text"
        bottomTextField.text = "Bottom Text"
        imageView.image = nil
        shareButton.enabled = false
        orientation = UIApplication.sharedApplication().statusBarOrientation
    }
    
}

