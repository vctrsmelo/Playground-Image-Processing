//
//  FilterDescriptionFactory.swift
//  iOS Image Filtering
//
//  Created by Victor S Melo on 22/03/19.
//  Copyright © 2019 Victor Melo. All rights reserved.
//

import UIKit

class FilterDescriptionFactory {
    
    static func getDescriptionData(for filter: Filter.Type?) -> FilterDescriptionData {
        
        guard let filter = filter else {
            
            let noFilterTitle = "No filter"
            let noFilterDescription = "As there is no filter in this image, take a look above in this cool draw I made."
            let noFilterJoke = "#NoFilter"
            let noFilterImage = UIImage(named: "NoFilter")
            
            return FilterDescriptionData(title: noFilterTitle, image: noFilterImage, description: noFilterDescription, joke: noFilterJoke)
            
            
        }
        
        let title = filter.name
        
        var image: UIImage?
        let description: String
        let joke: String
        switch filter {
        case is MixFilter.Type:
            description = "Switches all green, red and blue from image. May be applied twice."
            joke = "Is the sky green now? 🤯"
            image = UIImage(named: "FilterMix")
        case is GreyScaleFilter.Type:
            description = "Converts the image to black and white applying an equation to every pixel color."
            joke = "Vintage image 😂"
            image = UIImage(named: "FilterGreyscale")
        case is InvertFilter.Type:
            description = "Obtains the image negative. If applied twice, returns to the original one."
            joke = "We should all be more positive 👍"
            image = UIImage(named: "FilterInvert")
        case is HorizontalFlipFilter.Type:
            description = "Flips every pixel of the image horizontally."
            joke = "Is this my left or your left? 👈"
            image = UIImage(named: "FilterHorizontalFlip")
        case is VerticalFlipFilter.Type:
            description = "Flips every pixel of the image vertically."
            joke = "Is this the upsidedown world? 🤔"
            image = UIImage(named: "FilterVerticalFlip")
        case is ColorsLimited8Filter.Type:
            description = "Using a predefined color palette, maps image colors to the colors of this palette."
            joke = "Practically an artist 👨‍🎨"
            image = UIImage(named: "FilterColorsLimited8Palette")
        case is GreyQuantizationFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Limit the number of shades of grey."
            joke = "Relax, it is safe for work if you select 50 shades 😂"
            image = UIImage(named: "FilterGreyQuantization")
        case is BrightnessFilter.Type:
            description = "It increases the image brightness."
            joke = "Shine bright like a diamond 💎"
            image = UIImage(named: "FilterBrightness")
        case is ConstrastFilter.Type:
            description = "Increases the overall color intensity of the image."
            joke = "For a more colorful world 🌸"
            image = UIImage(named: "FilterContrast")
        case is EqualizeFilter.Type:
            description = "Equalize the image, enhancing its quality."
            joke = "We are all equals 🌎"
            image = UIImage(named: "FilterEqualization")
        case is HistogramMatchMonoFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Turns the shades of origin image closer to the shades of a target one."
            joke = "I do not guarantee that you will look like Brad Pitt if you use his photo as target 🤷‍♂️"
            image = UIImage(named: "FilterHistogramMatch")
            //        case is ZoomOutFilter.Type:
            //            description = "Zoom out an image, making it smaller."
            //            joke = "It does not fit 📦"
            //        case is ZoomInFilter.Type:
            //            description = "Zoom in an image, making it bigger."
            //            joke = "Elementary 🕵️‍♂️"
            //        case is Rotate90Filter.Type:
            //            description = "Rotates an image 90 degrees."
        //            joke = "It is hot ☀️"
        case is ConvolutionFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Applies an space filter to an image."
            joke = "We all need our space 👽"
        case is GaussianFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Uses convolution to make image blurrier."
            joke = "did you see my glasses? 🤓"
            image = UIImage(named: "FilterGaussian")
        case is LaplacianFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Uses convolution to enhances image edges."
            joke = "It is all about lines 📏"
            image = UIImage(named: "FilterLaplacian")
        case is HighPassFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Uses convolution to enhances image edges."
            joke = "It is all about lines 📏"
            image = UIImage(named: "FilterHighPass")
        case is PrewittHxFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Uses convolution to enhances image edges."
            joke = "It is all about lines 📏"
            image = UIImage(named: "FilterPrewittHx")
        case is PrewittHyHxFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Uses convolution to enhances image edges."
            joke = "It is all about lines 📏"
            image = UIImage(named: "FilterPrewittHyHx")
        case is SobelHxFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Uses convolution to enhances image edges."
            joke = "It is all about lines 📏"
            image = UIImage(named: "FilterSobelHx")
        case is SobelHyFilter.Type:
            description = "(Image is converted to grayscale for simplicity). Uses convolution to enhances image edges."
            joke = "It is all about lines 📏"
            image = UIImage(named: "FilterSobelHy")
        default:
            description = ""
            joke = ""
        }
        
        return FilterDescriptionData(title: title, image: image, description: description, joke: joke)
    }
    
}
