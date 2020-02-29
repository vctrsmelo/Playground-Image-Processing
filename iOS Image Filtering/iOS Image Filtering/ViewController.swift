//
//  ViewController.swift
//  iOS Image Filtering
//
//  Created by Victor S Melo on 16/03/19.
//  Copyright © 2019 Victor Melo. All rights reserved.
//

import UIKit

public class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let syncQueue = DispatchQueue(label: "asyncQueue")
    
    let cellId = "cellId"
    private var tableViewContainer: UIView!
    private(set) var tableView: UITableView!
    
    private(set) var activityIndicatorView: UIActivityIndicatorView!
    private(set) var activityViewLayer: UIView!
    
    private(set) var questionButton: UIButton!
    private(set) var descriptionView: FilterDescriptionView!
    
    private(set) var imageStack: [(image: Image, filter: Filter?)] = [] {
        didSet {
            guard imageStack.count > 0 else { return }
            
            if imageStack.count == 1 {
                originalImageView.image = imageStack.first?.image.asUIImage()
                
            }
        }
    }
    
    private(set) var currentImageIndex: Int = 0 {
        didSet{
            guard isViewLoaded else { return }
            
            if currentImageIndex == 0 {
                undoButton.isEnabled = false
                questionButton.isEnabled = false
            } else {
                undoButton.isEnabled = true
            }
            
            if currentImageIndex >= imageStack.count-1 {
                redoButton.isEnabled = false
            } else {
                redoButton.isEnabled = true
            }
            
            self.currentImageView.image = imageStack[currentImageIndex].image.asUIImage()
            
            if let filter = imageStack[currentImageIndex].filter {
                let lastAppliedFilter = type(of: filter)
                let lastAppliedFilterData = FilterDescriptionFactory.getDescriptionData(for: lastAppliedFilter)
                self.descriptionView.setData(lastAppliedFilterData)
            } else {
                let noFilterData = FilterDescriptionFactory.getDescriptionData(for: nil)
                self.descriptionView.setData(noFilterData)
            }
            
            self.animateButton(questionButton)
            self.questionButton.isEnabled = true
        }
    }
    private(set) var undoButton: UIButton!
    private(set) var redoButton: UIButton!
    
    private var pixelFilters: [PixelBasedFilter] = []
    private var spaceFilters: [SpaceFilter] = []
    
    private var isApplyingFilter: Bool = false {
        didSet {
            activityViewLayer.isHidden = !isApplyingFilter
        }
    }
    private var filterApplied: (() -> Image)?
    
    public var image: UIImage!
    
    private(set) var currentImageView: UIImageView!
    private(set) var originalImageView: UIImageView!
    
    private var imagePickedHandler: ((_ image: UIImage) -> Void)?
    
    public init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.view = view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickedHandler = { [weak self] image in
            guard let self = self else {
                return
            }
            
            self.gesturesSetup()
            
            self.view.becomeFirstResponder()
            
            let currentImage = image.resize(to: self.currentImageView.frame.size)
            
            self.imageStack = []
            self.imageStack.append((image: Image(image:currentImage), filter: nil))
            self.currentImageIndex = 0
            //            self.currentImageView.image = currentImage
        }
        
        layoutSetup()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imagePickedHandler?(image)
    }
    
    private func layoutSetup() {
        
        currentImageView = UIImageView()
        currentImageView.contentMode = .scaleAspectFit
        
        originalImageView = UIImageView()
        originalImageView.contentMode = .scaleAspectFit
        
        view.addSubview(originalImageView)
        originalImageView.translatesAutoresizingMaskIntoConstraints = false
        originalImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        originalImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        originalImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        
        view.addSubview(currentImageView)
        currentImageView.translatesAutoresizingMaskIntoConstraints = false
        currentImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        currentImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        currentImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        currentImageView.rightAnchor.constraint(equalTo: originalImageView.rightAnchor).isActive = true
        
        tableViewContainer = UIView()
        
        view.addSubview(tableViewContainer)
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        tableViewContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableViewContainer.widthAnchor.constraint(equalToConstant: 180).isActive = true
        tableViewContainer.leftAnchor.constraint(equalTo: currentImageView.rightAnchor).isActive = true
        
        
        
        tableView = UITableView(frame: self.view.frame, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableViewContainer.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: tableViewContainer.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: tableViewContainer.rightAnchor).isActive = true
        
        let buttonWidthHeight: CGFloat = 50
        
        undoButton = UIButton()
        undoButton.setImage(UIImage(named: "do_undo"), for: .normal)
        undoButton.setImage(UIImage(named: "do_undo_disabled"), for: .disabled)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(undoButton)
        
        undoButton.widthAnchor.constraint(equalToConstant: buttonWidthHeight).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: buttonWidthHeight).isActive = true
        undoButton.rightAnchor.constraint(equalTo: currentImageView.rightAnchor, constant: -16).isActive = true
        undoButton.topAnchor.constraint(equalTo: currentImageView.topAnchor, constant: 75).isActive = true
        
        undoButton.addTarget(self, action: #selector(didTouchUndo), for: UIControl.Event.touchDown)
        
        redoButton = UIButton()
        redoButton.setImage(UIImage(named: "do_redo"), for: .normal)
        redoButton.setImage(UIImage(named: "do_redo_disabled"), for: .disabled)
        redoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(redoButton)
        
        redoButton.widthAnchor.constraint(equalToConstant: buttonWidthHeight).isActive = true
        redoButton.heightAnchor.constraint(equalToConstant: buttonWidthHeight).isActive = true
        redoButton.rightAnchor.constraint(equalTo: undoButton.rightAnchor).isActive = true
        redoButton.topAnchor.constraint(equalTo: undoButton.bottomAnchor, constant: 16).isActive = true
        
        redoButton.addTarget(self, action: #selector(didTouchRedo), for: UIControl.Event.touchDown)
        
        activityViewLayer = UIView()
        view.addSubview(activityViewLayer)
        activityViewLayer.translatesAutoresizingMaskIntoConstraints = false
        
        activityViewLayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activityViewLayer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        activityViewLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        activityViewLayer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        activityViewLayer.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        activityIndicatorView = UIActivityIndicatorView()
        activityViewLayer.addSubview(activityIndicatorView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: currentImageView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: currentImageView.centerYAnchor).isActive = true
        
        activityIndicatorView.startAnimating()
        activityViewLayer.isHidden = true
        
        questionButton = UIButton()
        view.addSubview(questionButton)
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        
        questionButton = UIButton()
        questionButton.setImage(UIImage(named: "questionIcon"), for: .normal)
        questionButton.setImage(UIImage(named: "questionIconDisabled"), for: .disabled)
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionButton)
        
        questionButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        questionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        questionButton.rightAnchor.constraint(equalTo: currentImageView.rightAnchor, constant: -16).isActive = true
        questionButton.topAnchor.constraint(equalTo: redoButton.bottomAnchor, constant: 16).isActive = true
        questionButton.isEnabled = false
        questionButton.addTarget(self, action: #selector(didTouchQuestionButton), for: UIControl.Event.touchDown)
        
        descriptionView = FilterDescriptionView()
        view.addSubview(descriptionView)
        descriptionView.layer.cornerRadius = 25
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        descriptionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -86).isActive = true
        descriptionView.widthAnchorConstraint = descriptionView.widthAnchor.constraint(equalTo: self.currentImageView.widthAnchor, constant: -32)
        descriptionView.heightAnchorConstraint = descriptionView.heightAnchor.constraint(equalToConstant: 350)
        descriptionView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor).isActive = true
        
        descriptionView.isHidden = true
        descriptionView.backgroundColor = .white
        descriptionView.clipsToBounds = true
        
    }
    
    private func gesturesSetup() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        longPress.minimumPressDuration = 0.4
        self.view.addGestureRecognizer(longPress)
    }
    
    // Mark: - Gestures
    
    @objc func didTouchUndo() {
        animateTouchedButton(undoButton)
        guard currentImageIndex > 0 else { return }
        currentImageIndex -= 1
    }
    
    @objc func didTouchRedo() {
        animateTouchedButton(redoButton)
        guard currentImageIndex < imageStack.count-1 else { return }
        currentImageIndex += 1
    }
    
    @objc func didTouchQuestionButton() {
        animateTouchedButton(questionButton)
        
        var startFrame = descriptionView.frame
        startFrame.size.width = 0
        startFrame.size.height = 0
        descriptionView.frame = startFrame
        
        var toFrame = self.currentImageView.frame
        toFrame.origin.y = toFrame.origin.y + toFrame.size.height - 316
        toFrame.size.height = 300
        toFrame.origin.x = toFrame.origin.x+16
        toFrame.size.width = toFrame.size.width - 32
        descriptionView.showView(toFrame: toFrame)
    }
    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            currentImageView.isHidden = true
        case .cancelled, .ended:
            currentImageView.isHidden = false
        default:
            break
        }
    }
    
    public func setFilters(_ filters: [Filter]) {
        for filter in filters {
            if let spaceFilter = filter as? SpaceFilter {
                self.spaceFilters.append(spaceFilter)
            } else if let pixelFilter = filter as? PixelBasedFilter{
                self.pixelFilters.append(pixelFilter)
            }
        }
    }
    
    func applyFilter(_ filter: Filter, completion: @escaping ((Image?) -> Void)) {
        
        guard let currentImage = currentImageView.image else {
            completion(nil)
            return
        }
        
        syncQueue.async {
            completion(Image(image: currentImage).apply(filter))
        }
        
    }
    
    func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                button.transform = CGAffineTransform.identity
            })
        }
    }
    
    func animateTouchedButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = CGAffineTransform.identity
            })
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pixel-based Filters"
        } else {
            return "Space Filters"
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FilterTableViewCell
        
        let name = (indexPath.section == 0) ? type(of: pixelFilters[indexPath.row]).name : type(of: spaceFilters[indexPath.row]).name
        cell.nameButton.setTitle(name, for: .normal)
        
        cell.row = indexPath.row
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pixelFilters.count
        } else {
            return spaceFilters.count
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isApplyingFilter == false {
            
            isApplyingFilter = true
            
            let filter: Filter = (indexPath.section == 0) ? pixelFilters[indexPath.row] : spaceFilters[indexPath.row]
            
            applyFilter(filter) { [weak self] maybeImage in
                if let image = maybeImage {
                    DispatchQueue.main.sync {
                        guard let self = self else { return }
                        
                        let lastDrop = (self.imageStack.count-1) - self.currentImageIndex
                        self.imageStack = [(image: Image, filter: Filter?)].init(self.imageStack.dropLast(lastDrop))
                        self.imageStack.append((image: image, filter: filter))
                        self.isApplyingFilter = false
                        self.currentImageIndex = self.imageStack.count-1
                    }
                }
            }
        }
    }
    
}
