//
//  AddMemeViewController.swift
//  Meme Me
//
//  Created by Adam Duren on 9/7/15.
//  Copyright (c) 2015 Adam Duren. All rights reserved.
//

import UIKit

class AddMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
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
    
    var meme: Meme!
    var orientation: UIInterfaceOrientation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureCameraButton()
        configureTextField(topTextField)
        configureTextField(bottomTextField)
        resetViewState()
        
        if (meme != nil) {
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            imageView.image = meme.originalImage
            imageView.updateConstraints()
            updateConstraints()
            shareButton.enabled = true
        }
        updateConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        orientation = UIApplication.sharedApplication().statusBarOrientation;
        updateConstraints()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.editing {
            view.frame.origin.y = 0
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
        
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func updateConstraints() {
        let parentFrame = imageView.superview!.frame
        
        if let image = imageView.image {
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
        imageView.superview!.layoutIfNeeded()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> Void in
            if (completed) {
                self.saveMeme(memedImage)
            }
        }
        
        presentViewController(shareController, animated: true, completion: nil)
    }
    
    func saveMeme(memedImage: UIImage) {
        let meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            originalImage: imageView.image!,
            memedImage: memedImage
        )
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetViewState() {
        topTextField.text = "TOP TEXT"
        bottomTextField.text = "BOTTOM TEXT"
        imageView.image = nil
        shareButton.enabled = false
        orientation = UIApplication.sharedApplication().statusBarOrientation
    }
    
}

