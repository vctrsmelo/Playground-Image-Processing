//#-hidden-code
import PlaygroundSupport
import UIKit
//#-end-hidden-code
/*:
 **Goal:** Have fun composing and customizing filters. 😆
 
 **Motivation:** Since I started programming, I have always been intrigued about how images are manipulated digitally. So, I decided to learn digital image processing then applied that knowledge in this project. All filters were implemented by myself. I hope you like it! 😃
 
 # Quick Intro
 There are two kind of filters:
 
 **Pixel-based Filters:** These filters modify the RGB color of each pixel individually. Filters used by Instagram are of this kind.
 
 **Space Filters:** These filters apply an operation, called [convolution](glossary://Convolution), over a group of near pixels using a kernel. Some of these filters are applied in computer vision.
 
 Below you can see and modify these filters parameters. Feel free to explore them. 🚀
 
 ## Tips:
 * You can undo and redo filters applications using the buttons at top right corner.
 * Long pressing the image will show the original one. 👇
 * You can toouch the "?" button below the undo and redo buttons to learn about the last applied filter.
 * Try using an image from your library modifying the *editableImage* constant below.
 */

let editableImage = #imageLiteral(resourceName: "default1.jpg")

var filters: [Filter] = [
    
    // Pixel-based Filters
    MixFilter(),
    InvertFilter(),
    HorizontalFlipFilter(),
    VerticalFlipFilter(),
    BrightnessFilter(value: 30),
    ConstrastFilter(scale: 1.5),
    EqualizeFilter(),
    ColorsLimited8Filter(),
    GreyScaleFilter(),
    GreyQuantizationFilter(greyColors: 6),
    HistogramMatchMonoFilter(source: #imageLiteral(resourceName: "default2.jpg")),
    
    // Space Filters
    GaussianFilter(),
    LaplacianFilter(),
    HighPassFilter(),
    PrewittHxFilter(summingValue: 120),
    PrewittHyHxFilter(summingValue: 120),
    SobelHxFilter(summingValue: 120),
    SobelHyFilter(summingValue: 120)
]

//#-hidden-code
let vc = ViewController(image: editableImage)
vc.setFilters(filters)

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code

