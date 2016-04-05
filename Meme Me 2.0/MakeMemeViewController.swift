//
//  MakeMemeViewController.swift
//  MemeMe2.0
//
//  Created by Hoff Henry Pereira da Silva on 21/09/15.
//  Copyright (c) 2015 Hoff Silva. All rights reserved.
//

import UIKit
import Social


class MakeMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    var sentMemes = [Meme]()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.redColor(),
        NSForegroundColorAttributeName: UIColor.yellowColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1.9
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        top.hidden = false
        shareButton.enabled = false
        top.delegate = self
        bottom.delegate = self
        bottom.isFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotificationsWillShow()
        subscribeToKeyboardNotificationsWillHide()
        checkCamera()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotificationsWillShow()
        unsubscribeToKeyboardNotificationsWillHide()
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePickerView.image = image
        dismissViewControllerAnimated(true, completion: nil)
        showTextfield(false)
        shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showTextfield(ativar: Bool){
        top.defaultTextAttributes = memeTextAttributes
        top.hidden = ativar
        top.text = "TOP"
        top.textAlignment = NSTextAlignment.Center
        bottom.hidden = ativar
        bottom.text = "BOTTOM"
        bottom.defaultTextAttributes = memeTextAttributes
        bottom.textAlignment = NSTextAlignment.Center
    }
    
    func checkCamera(){
        return cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottom.isFirstResponder(){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottom.isFirstResponder(){
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotificationsWillShow() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotificationsWillShow() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotificationsWillHide() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func subscribeToKeyboardNotificationsWillHide() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }

    
    
    func generateMemedImage() -> UIImage {
        
        navigationBar.hidden = true
        toolBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        //Create the meme
        let meme = Meme(topText: top.text!, bottomText: bottom.text!, memedImage: generateMemedImage(), originalImage: imagePickerView.image!)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        
    }
    
    @IBAction func shareImage(sender: AnyObject) {
        
        let memedImageWillShare = [generateMemedImage()]
        
        let activityView = UIActivityViewController(activityItems: memedImageWillShare, applicationActivities: nil)
        
        
            activityView.completionWithItemsHandler = {
                (type, completed, returnedItems, error) -> Void in
                self.save()
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        
        presentViewController(activityView, animated: true, completion: nil)
    }
    
}

