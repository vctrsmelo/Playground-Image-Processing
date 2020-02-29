//
//  StartPickerView.swift
//  iOS Image Filtering
//
//  Created by Victor S Melo on 16/03/19.
//  Copyright © 2019 Victor Melo. All rights reserved.
//

import Foundation
import UIKit

public protocol StartPickerViewDelegate: AnyObject {
    func didSelectSourceType(_ startPickerView: StartPickerView, sourceType: UIImagePickerController.SourceType)
}

public class StartPickerView: UIView {
    
    
    var messageTextView: UITextView!
    var cameraIconImageView: UIImageView!
    var photoIconImageView: UIImageView!
    
    fileprivate var imagePickerVC: UIImagePickerController?
    
    var delegate: StartPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let iconHeight: CGFloat = 150
        
        cameraIconImageView = UIImageView.init(image: UIImage(named: "cameraIcon"))
        photoIconImageView = UIImageView.init(image: UIImage(named: "photoIcon"))
        messageTextView = UITextView()
        
        self.addSubview(cameraIconImageView)
        cameraIconImageView.translatesAutoresizingMaskIntoConstraints = false
        cameraIconImageView.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true
        cameraIconImageView.widthAnchor.constraint(equalTo: cameraIconImageView.heightAnchor).isActive = true
        cameraIconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cameraIconImageView.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -20).isActive = true
        
        self.addSubview(photoIconImageView)
        photoIconImageView.translatesAutoresizingMaskIntoConstraints = false
        photoIconImageView.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true
        photoIconImageView.widthAnchor.constraint(equalTo: photoIconImageView.heightAnchor).isActive = true
        photoIconImageView.centerYAnchor.constraint(equalTo: cameraIconImageView.centerYAnchor).isActive = true
        photoIconImageView.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 20).isActive = true
        
        self.addSubview(messageTextView)
        
        messageTextView.text = "Select an image to apply filters :)"
        messageTextView.font = UIFont(name: "Chalkboard SE", size: 20)
        messageTextView.textColor = UIColor.white
        messageTextView.backgroundColor = UIColor.clear
        messageTextView.textAlignment = .center
        messageTextView.isEditable = false
        messageTextView.isSelectable = false
        
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        
        messageTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        messageTextView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        messageTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: cameraIconImageView.topAnchor, constant: -30).isActive = true
        
        // Gestures
        
        self.becomeFirstResponder()
        
        self.isUserInteractionEnabled = true
        
        cameraIconImageView.isUserInteractionEnabled = true
        cameraIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraIconTapped(_ :))))
        
        photoIconImageView.isUserInteractionEnabled = true
        photoIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoIconTapped(_ :))))
        
    }
    
    @objc
    func photoIconTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.didSelectSourceType(self, sourceType: .photoLibrary)
    }
    
    @objc
    func cameraIconTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.didSelectSourceType(self, sourceType: .camera)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
}
