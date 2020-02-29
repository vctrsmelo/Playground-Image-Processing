//
//  FilterDescriptionView.swift
//  iOS Image Filtering
//
//  Created by Victor Melo on 20/03/19.
//  Copyright © 2019 Victor Melo. All rights reserved.
//

import UIKit

public struct FilterDescriptionData {
    let title: String
    let image: UIImage?
    let description: String
    let joke: String
}

public class FilterDescriptionView: UIView {
    
    // imageView
    // descriptionLabel
    
    private(set) var titleLabel: UILabel!
    private(set) var closeButton: UIButton!
    private(set) var imageView: UIImageView!
    private(set) var descriptionLabel: UILabel!
    private(set) var jokeLabel: UILabel!
    
    private(set) var isHiddingView: Bool = false
    
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
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.numberOfLines = 3
        
        jokeLabel = UILabel()
        jokeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(jokeLabel)
        
        jokeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        jokeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        jokeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        jokeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        jokeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        jokeLabel.textAlignment = .center
        jokeLabel.adjustsFontSizeToFitWidth = true
        jokeLabel.numberOfLines = 2
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        closeButton.setImage(UIImage(named: "closeIcon"), for: .normal)
        
        closeButton.addTarget(self, action: #selector(didTouchCloseView), for: UIControl.Event.touchDown)
        
        
        // font design
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        jokeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    @objc func didTouchCloseView() {
        closeButton.animateTouchedButton()
        hideView()
    }
    
    func hideView(time: TimeInterval = 1, completion: (() -> Void)? = nil) {
        var frame = self.frame
        
        isHiddingView = true
        
        UIView.animate(withDuration: time, animations: { [weak self] in
            guard let self = self else { return }
            
            frame.origin.y = self.frame.maxY
            frame.size.width = 0
            frame.size.height = 0
            self.frame = frame
        }) { [weak self] _ in
            self?.isHidden = true
            self?.widthAnchorConstraint?.isActive = false
            self?.heightAnchorConstraint?.isActive = false
            self?.isHiddingView = false
        }
    }
    
    func showView(toFrame: CGRect, completion: (() -> Void)? = nil) {
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
            completion?()
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
        
        
        self.descriptionLabel.text = data.description
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
