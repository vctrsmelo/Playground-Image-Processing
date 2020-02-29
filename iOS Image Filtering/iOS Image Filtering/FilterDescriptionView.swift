//
//  FilterDescriptionView.swift
//  iOS Image Filtering
//
//  Created by Victor Melo on 20/03/19.
//  Copyright © 2019 Victor Melo. All rights reserved.
//

import UIKit

struct FilterDescriptionData {
    let title: String
    let image: UIImage?
    let description: String
    let joke: String
}

class FilterDescriptionView: UIView {
    
    // imageView
    // descriptionTextView
    
    private(set) var titleLabel: UILabel!
    private(set) var closeButton: UIButton!
    private(set) var imageView: UIImageView!
    private(set) var descriptionTextView: UITextView!
    private(set) var jokeLabel: UILabel!
    
    var widthAnchorConstraint: NSLayoutConstraint?
    var heightAnchorConstraint: NSLayoutConstraint?
    
    private var visibleImageViewHeightConstraint: NSLayoutConstraint?
    private var hiddenImageViewHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.clipsToBounds = true
        self.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleLabel.textAlignment = .center
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        hiddenImageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
        hiddenImageViewHeightConstraint?.isActive = true
        visibleImageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 150)
        imageView.contentMode = .scaleAspectFit

        descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionTextView)
        
        descriptionTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        descriptionTextView.textAlignment = .center
    
        jokeLabel = UILabel()
        jokeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(jokeLabel)
        
        jokeLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8).isActive = true
        jokeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        jokeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        jokeLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8).isActive = true
        jokeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        jokeLabel.textAlignment = .center
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        closeButton.setImage(UIImage(named: "closeIcon"), for: .normal)

        closeButton.addTarget(self, action: #selector(didTouchCloseView), for: UIControl.Event.touchDown)
        
        
        // font design
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        jokeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    @objc func didTouchCloseView() {
        hideView()
    }
    
    func hideView(time: TimeInterval = 1) {
        var frame = self.frame
        
        UIView.animate(withDuration: time, animations: {
            frame.origin.y = self.frame.maxY
            frame.size.width = 0
            frame.size.height = 0
            self.frame = frame
        }) { _ in
            self.isHidden = true
            self.widthAnchorConstraint?.isActive = false
            self.heightAnchorConstraint?.isActive = false
        }
    }
    
    func showView(toFrame: CGRect) {
        self.isHidden = false
        
        var frame = self.frame
        frame.origin.y = toFrame.origin.y + toFrame.size.height
        self.frame = frame
        
        UIView.animate(withDuration: 1, animations: {
            self.widthAnchorConstraint?.isActive = true
            self.heightAnchorConstraint?.isActive = true
            frame.origin.y =  toFrame.origin.y
            frame.size.width = toFrame.size.width
            frame.size.height = toFrame.height
            self.frame = frame
        }) { _ in
        }
    }
    
    func setData(_ data: FilterDescriptionData) {
        self.titleLabel.text = data.title
        self.imageView.image = data.image
        self.jokeLabel.text = "\""+data.joke+"\""
        
        if data.image == nil {
            visibleImageViewHeightConstraint?.isActive = false
            hiddenImageViewHeightConstraint?.isActive = true
        } else {
            hiddenImageViewHeightConstraint?.isActive = false
            visibleImageViewHeightConstraint?.isActive = true
        }
        
        
        self.descriptionTextView.text = data.description
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
