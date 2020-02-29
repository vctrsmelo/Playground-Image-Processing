import Foundation
import GLKit

/// Increases the overall color intensity of the image. (For a more colorful world 🌸)
public class ScaleIntensityFilter: PixelBasedFilter {
    
    public static let name = "Scale Intensity"
    
    let scale: Double
    
    public init(scale: Double) {
        self.scale = scale
    }
    
    public func apply(input: Image) -> Image {
        return input.transformPixels({ (p1) -> RGBAPixel in
            var p = p1
            
            var newRed = Double(p.red)*self.scale
            newRed = newRed > 255 ? 255 : newRed
            
            var newGreen = Double(p.green)*self.scale
            newGreen = newGreen > 255 ? 255 : newGreen
            
            var newBlue = Double(p.blue)*self.scale
            newBlue = newBlue > 255 ? 255 : newBlue
            
            p.red = UInt8(newRed)
            p.green = UInt8(newGreen)
            p.blue = UInt8(newBlue)
            return p
        })
    }
}

/// Switches all green, red and blue from image. May be applied twice. (Is the sky green now? 🤯)
public class MixFilter: PixelBasedFilter {
    
    public static let name = "Mix"
    
    public init() {}
    
    public func apply(input: Image) -> Image {
        return input.transformPixels({ (p1) -> RGBAPixel in
            var p = p1
            let r = p.red
            p.red = p.blue
            p.blue = p.green
            p.green = r
            
            return p
        })
    }
}

/// Converts the image to black and white. (One time I heard this is how dogs see 🐕)
public class GreyScaleFilter: PixelBasedFilter {
    
    public static let name = "Greyscale"
    
    public init() {}
    
    public func apply(input: Image) -> Image {
        let greyImage = input.transformPixels({ (p1) -> RGBAPixel in
            let i = p1.greyScale
            return RGBAPixel(red: i, green: i, blue: i)
        })
        greyImage.isGreyScale = true
        return greyImage
    }
}

/// Obtains the image negative. If applied twice, returns to the original one. (We should all be more positive 👍)
public class InvertFilter: PixelBasedFilter {
    
    public static let name = "Invert"
    
    public init() {}
    
    public func apply(input: Image) -> Image {
        return input.transformPixels({ (p1) -> RGBAPixel in
            return RGBAPixel(red: 0xFF-p1.red, green: 0xFF-p1.green, blue: 0xFF-p1.blue)
        })
    }
    let a = #colorLiteral(red: 1, green: 0.005364716923, blue: 0, alpha: 1)
}

/// Flip the image horizontally. (Is this my left or your left? 👈)
public class HorizontalFlipFilter: PixelBasedFilter {
    
    public static let name = "Horizontal Flip"
    
    public init() {}
    
    public func apply(input: Image) -> Image {
        let newImage = Image(width: input.width, height: input.height)
        for y in 0 ..< input.height {
            for x in 0 ..< input.width {
                let p1 = input.getPixel(x: x, y: y)
                newImage.setPixel(p1, x: input.width-x-1, y: y)
            }
        }
        return newImage
    }
}

/// Flip the image vertically. (Is this the upsidedown world? 🤔)
public class VerticalFlipFilter: PixelBasedFilter {
    
    public static let name = "Vertical Flip"
    
    public init() {}
    
    public func apply(input: Image) -> Image {
        let newImage = Image(width: input.width, height: input.height)
        for y in 0 ..< input.height {
            for x in 0 ..< input.width {
                let p1 = input.getPixel(x: x, y: y)
                newImage.setPixel(p1, x: x, y: input.height-y-1)
            }
        }
        return newImage
    }
}

/// Using a color palette, maps image colors to the colors presented in this palette. (become an artist 👨‍🎨)
public class ColorsLimited8Filter: PixelBasedFilter {
    
    public static let name = "Colors Limited 8"
    
    public init() {}
    
    public func apply(input: Image) -> Image {
        return input.transformPixels({ (p) -> RGBAPixel in
            return p.findClosestMatch(palette: self.palette)
        })
    }
    
    let palette: [RGBAPixel] = [
        RGBAPixel(red: 0, green: 0, blue: 0),
        RGBAPixel(red: 0xFF, green: 0xFF, blue: 0xFF),
        RGBAPixel(red: 0xFF, green: 0x0, blue: 0x0),
        RGBAPixel(red: 0x0, green: 0xFF, blue: 0x0),
        RGBAPixel(red: 0x0, green: 0x0, blue: 0xFF),
        RGBAPixel(red: 0xFF, green: 0xFF, blue: 0x0),
        RGBAPixel(red: 0x0, green: 0xFF, blue: 0xFF),
        RGBAPixel(red: 0xFF, green: 0x0, blue: 0xFF)
    ]
}

/// Applied only for greyscale images. Limit the number of shades of grey. (Relax, it is safe for work if you select 50 shades 😂)
public class GreyQuantizationFilter: PixelBasedFilter {
    
    public static let name = "Grey Quantization"
    
    var greyColors: Int
    let palette: [RGBAPixel] = {
        var pal = [RGBAPixel]()
        for i in 0 ... 255 {
            pal.append(RGBAPixel(gray: UInt8(i)))
        }
        return pal
    }()
    
    public init(greyColors: Int) {
        self.greyColors = greyColors
    }
    
    public func apply(input: Image) -> Image {
        let grayInput = input.isGreyScale ? input : input.apply(GreyScaleFilter())
        let nth = ((256 - greyColors)/greyColors)+1
        
        var usedPalette = [RGBAPixel]()
        for i in 0 ..< palette.count {
            if i % nth == 0 {
                usedPalette.append(palette[i])
            }
        }
        
        if usedPalette.count > greyColors {
            usedPalette.remove(at: Int(ceil(Double(usedPalette.count/2))))
        }
        
        return grayInput.transformPixels({ (p) -> RGBAPixel in
            return p.findClosestMatch(palette: usedPalette)
        })
    }
}

/// It increases the image brightness. (Shine bright like a diamond 💎)
public class BrightnessFilter: PixelBasedFilter {
    
    public static let name = "Brightness"
    
    var value: Int16
    
    public init(value: Int16) {
        self.value = value
    }
    
    public func apply(input: Image) -> Image {
        let newImage = Image(width: input.width, height: input.height)
        for y in 0 ..< input.height {
            for x in 0 ..< input.width {
                let p1 = input.getPixel(x: x, y: y)
                
                
                var newRed: Int = Int(p1.red)+Int(value)
                if !(0...255).contains(newRed) {
                    newRed = (newRed < 0) ? 0 : 255
                }
                
                var newGreen: Int = Int(p1.green)+Int(value)
                if !(0...255).contains(newGreen) {
                    newGreen = (newGreen < 0) ? 0 : 255
                }
                
                var newBlue: Int = Int(p1.blue)+Int(value)
                if !(0...255).contains(newBlue) {
                    newBlue = (newBlue < 0) ? 0 : 255
                }
                
                let newPixel = RGBAPixel(red: UInt8(newRed), green: UInt8(newGreen), blue: UInt8(newBlue))
                newImage.setPixel(newPixel, x: x, y: y)
            }
        }
        return newImage
        
    }
}

/// Increases image overall contrast. (the opposites attract themselves 🤗)
public class ConstrastFilter: PixelBasedFilter {
    
    public static let name = "Contrast"
    
    var scale: Double
    
    public init(scale: Double) {
        if scale < 0 {
            self.scale = 0
            
        } else if scale > 255 {
            self.scale = 255
            
        } else {
            self.scale = scale
        }
    }
    
    public func apply(input: Image) -> Image {
        return input.transformPixels({ (p1) -> RGBAPixel in
            var p = p1
            
            var newRed = Double(p.red)*self.scale
            newRed = newRed > 255 ? 255 : newRed
            
            var newGreen = Double(p.green)*self.scale
            newGreen = newGreen > 255 ? 255 : newGreen
            
            var newBlue = Double(p.blue)*self.scale
            newBlue = newBlue > 255 ? 255 : newBlue
            
            p.red = UInt8(newRed)
            p.green = UInt8(newGreen)
            p.blue = UInt8(newBlue)
            return p
        })
    }
}

/// Equalize an image, enhancing its quality. (We are all equals 🌎)
public class EqualizeFilter: PixelBasedFilter {
    
    public static let name = "Equalize"
    
    public init() {}
    
    public func apply(input: Image) -> Image {
        if input.isGreyScale {
            return input.greyscaleEqualized()
        } else {
            return input.coloredEqualized()
        }
    }
}

/// Used for greyscaled images. Turns the shades of one image closer to the shades of another. (I do not guarantee that you will look like Brad Pitt if you use his photo 🤷‍♂️)
public class HistogramMatchMonoFilter: PixelBasedFilter {
    
    public static let name = "Histogram Match"
    
    private let matchHistogram: Histogram
    
    public convenience init(source uiImage: UIImage) {
        let image = Image(image: uiImage)
        
        self.init(matchGreyscaleHistogram: image.greyscaleHistogram)
    }
    
    public init(matchGreyscaleHistogram: Histogram) {
        self.matchHistogram = matchGreyscaleHistogram
    }
    
    public func apply(input: Image) -> Image {
        
        let histSrc = input.greyscaleHistogram
        let histTarget = matchHistogram
        let histSrcCum = histSrc.getCumulativeHistogram().normalized()
        let histTargetCum = histTarget.getCumulativeHistogram().normalized()
        
        var hm = [Int](repeating: 0, count: 256)
        
        for i in 0 ... 255 {
            var closestIndex = 128
            for j in 0 ... 255 {
                if abs(histSrcCum.values[i] - histTargetCum.values[j]) < abs(histSrcCum.values[i] - histTargetCum.values[closestIndex]) {
                    closestIndex = j
                }
            }
            hm[i] = closestIndex
        }
        
        let newImage = Image(width: input.width, height: input.height)
        
        for x in 0 ..< input.width {
            for y in 0 ..< input.height {
                let originalGrey = input.getPixel(x: x, y: y).greyScale
                let newGray = hm[Int(originalGrey)]
                let newPixel = RGBAPixel(gray: UInt8(truncatingIfNeeded: newGray))
                newImage.setPixel(newPixel, x: x, y: y)
            }
        }
        
        return newImage
    }
}

/// Zoom out an image, making it smaller. (It does not fit 📦)
public class ZoomOutFilter: PixelBasedFilter {
    
    public static let name = "Zoom Out"
    
    let sx: Double
    let sy: Double
    
    public init(sx: Double, sy: Double) {
        self.sx = sx
        self.sy = sy
    }
    
    public func apply(input: Image) -> Image {
        let newImage = input.zoomedOut(sx: sx, sy: sy)
        return newImage
    }
}

/// Zoom in an image, making it bigger. (Elementary 🕵️‍♂️)
public class ZoomInFilter: PixelBasedFilter {
    
    public static let name = "Zoom In"
    
    public init() {}
    
    public func apply(input: Image) -> Image {
        let newImage = input.zoomedIn2x2()
        return newImage
    }
}

/// Rotates an image 90 degrees. (It is hot ☀️)
public class Rotate90Filter: PixelBasedFilter {
    
    public static let name = "Rotate 90"
    
    private var isClockwise: Bool
    
    public init(isClockwise: Bool = true) {
        self.isClockwise = isClockwise
    }
    
    public func apply(input: Image) -> Image {
        if isClockwise {
            return rotate90Clockwise(input: input)
        } else {
            return rotate90Anticlockwise(input: input)
        }
    }
    
    private func rotate90Clockwise(input: Image) -> Image {
        let newImage = Image(width: input.height, height: input.width)
        var newColumn = 0
        var newRow = newImage.height-1
        
        for oldColRev in 0 ... input.width-1 {
            let oldColumn = input.width-1 - oldColRev
            
            newColumn = newImage.width-1
            for oldRow in 0 ..< input.height {
                newImage.setPixel(input.getPixel(x: oldColumn, y: oldRow), x: newColumn, y: newRow)
                
                newColumn -= 1
            }
            
            newRow -= 1
        }
        
        return newImage
    }
    
    private func rotate90Anticlockwise(input: Image) -> Image {
        let newImage = Image(width: input.height, height: input.width)
        var newColumn = 0
        var newRow = 0
        
        for oldColRev in 0 ... input.width-1 {
            let oldColumn = input.width-1 - oldColRev
            
            newColumn = 0
            for oldRow in 0 ..< input.height {
                newImage.setPixel(input.getPixel(x: oldColumn, y: oldRow), x: newColumn, y: newRow)
                
                newColumn += 1
            }
            
            newRow += 1
        }
        
        return newImage
    }
}

/// Applies an space filter to an image. (We all need our space 👽)
public class ConvolutionFilter: SpaceFilter {
    
    public static let name = "Convolution"
    
    var kernel: GLKMatrix3
    var summingValue: Float
    
    public init(kernel: GLKMatrix3, summingValue: Float = 0.0) {
        self.kernel = kernel
        self.summingValue = summingValue
    }
    
    public func apply(input: Image) -> Image {
        if input.isGreyScale {
            return input.applyConvolution(kernel: kernel, summingValue: summingValue)
        }
        
        return input.apply(GreyScaleFilter()).applyConvolution(kernel: kernel, summingValue: summingValue)
    }
}

/// Makes image blurrier (did you see my glasses? 🤓)
public class GaussianFilter: SpaceFilter {
    
    public static let name = "Gaussian"
    
    let kernel: GLKMatrix3 = GLKMatrix3.gaussian
    var summingValue: Float
    
    public init(summingValue: Float = 0.0) {
        self.summingValue = summingValue
    }
    
    public func apply(input: Image) -> Image {
        if input.isGreyScale {
            return input.applyConvolution(kernel: kernel, summingValue: summingValue)
        }
        
        return input.apply(GreyScaleFilter()).applyConvolution(kernel: kernel, summingValue: summingValue)
    }
}

/// Enhances image edges. (It is all about lines 📏)
public class LaplacianFilter: SpaceFilter {
    
    public static let name = "Laplacian"
    
    let kernel: GLKMatrix3 = GLKMatrix3.laplacian
    var summingValue: Float
    
    public init(summingValue: Float = 0.0) {
        self.summingValue = summingValue
    }
    
    public func apply(input: Image) -> Image {
        if input.isGreyScale {
            return input.applyConvolution(kernel: kernel, summingValue: summingValue)
        }
        
        return input.apply(GreyScaleFilter()).applyConvolution(kernel: kernel, summingValue: summingValue)
    }
}
/// Enhances image edges (It is all about lines 📏)
public class HighPassFilter: SpaceFilter {
    
    public static let name = "Highpass"
    
    let kernel: GLKMatrix3 = GLKMatrix3.highPass
    var summingValue: Float
    
    public init(summingValue: Float = 0.0) {
        self.summingValue = summingValue
    }
    
    public func apply(input: Image) -> Image {
        if input.isGreyScale {
            return input.applyConvolution(kernel: kernel, summingValue: summingValue)
        }
        
        return input.apply(GreyScaleFilter()).applyConvolution(kernel: kernel, summingValue: summingValue)
    }
}

/// Enhances image edges (It is all about lines 📏)
public class PrewittHxFilter: SpaceFilter {
    
    public static let name = "PrewittHx"
    
    let kernel: GLKMatrix3 = GLKMatrix3.prewittHx
    var summingValue: Float
    
    public init(summingValue: Float = 0.0) {
        self.summingValue = summingValue
    }
    
    public func apply(input: Image) -> Image {
        if input.isGreyScale {
            return input.applyConvolution(kernel: kernel, summingValue: summingValue)
        }
        
        return input.apply(GreyScaleFilter()).applyConvolution(kernel: kernel, summingValue: summingValue)
    }
}

/// Enhances image edges (It is all about lines 📏)
public class PrewittHyHxFilter: SpaceFilter {
    
    public static let name = "PrewittHyHx"
    
    let kernel: GLKMatrix3 = GLKMatrix3.prewittHyHx
    var summingValue: Float
    
    public init(summingValue: Float = 0.0) {
        self.summingValue = summingValue
    }
    
    public func apply(input: Image) -> Image {
        if input.isGreyScale {
            return input.applyConvolution(kernel: kernel, summingValue: summingValue)
        }
        
        return input.apply(GreyScaleFilter()).applyConvolution(kernel: kernel, summingValue: summingValue)
    }
}

/// Enhances image edges (It is all about lines 📏)
public class SobelHxFilter: SpaceFilter {
    
    public static let name = "SobelHx"
    
    let kernel: GLKMatrix3 = GLKMatrix3.sobelHx
    var summingValue: Float
    
    public init(summingValue: Float = 0.0) {
        self.summingValue = summingValue
    }
    
    public func apply(input: Image) -> Image {
        if input.isGreyScale {
            return input.applyConvolution(kernel: kernel, summingValue: summingValue)
        }
        
        return input.apply(GreyScaleFilter()).applyConvolution(kernel: kernel, summingValue: summingValue)
    }
}

/// Enhances image edges (It is all about lines 📏)
public class SobelHyFilter: SpaceFilter {
    
    public static let name = "SobelHy"
    
    let kernel: GLKMatrix3 = GLKMatrix3.sobelHy
    var summingValue: Float
    
    public init(summingValue: Float = 0.0) {
        self.summingValue = summingValue
    }
    
    public func apply(input: Image) -> Image {
        if input.isGreyScale {
            return input.applyConvolution(kernel: kernel, summingValue: summingValue)
        }
        
        return input.apply(GreyScaleFilter()).applyConvolution(kernel: kernel, summingValue: summingValue)
    }
}

