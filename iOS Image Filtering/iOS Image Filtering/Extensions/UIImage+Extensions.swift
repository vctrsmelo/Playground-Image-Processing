import UIKit

extension UIImage {
    func resize(to size: CGSize, keepingAspectRatio: Bool = true) -> UIImage {
        
        let oldWidth: CGFloat = self.size.width
        let scaleFactorByWidth: CGFloat = size.width / oldWidth
        
        let oldHeight: CGFloat = self.size.height
        let scaleFactorByHeight: CGFloat = size.height / oldHeight
        
        let newHeight: CGFloat
        let newWidth: CGFloat

        if keepingAspectRatio {
            if self.size.width <= self.size.height {
                newHeight = self.size.height * scaleFactorByHeight
                newWidth = oldWidth * scaleFactorByHeight
            } else {
                newHeight = self.size.height * scaleFactorByWidth
                newWidth = oldWidth * scaleFactorByWidth
            }
        } else {
            newHeight = size.height
            newWidth = size.width
        }
        
        UIGraphicsBeginImageContext(size)
        let x: CGFloat = (size.width - newWidth)/2
        let y: CGFloat = (size.height - newHeight)/2
        self.draw(in: CGRect(x: x, y: y, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

//extension NSImage {
//
//    func fixedOrientation() -> NSImage? {
//
//        guard imageOrientation != UIImageOrientation.up else {
//            //This is default orientation, don't need to do anything
//            return self.copy() as? UIImage
//        }
//
//        guard let cgImage = self.cgImage else {
//            //CGImage is not available
//            return nil
//        }
//
//        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
//            return nil //Not able to create CGContext
//        }
//
//        var transform: CGAffineTransform = CGAffineTransform.identity
//
//        switch imageOrientation {
//        case .down, .downMirrored:
//            transform = transform.translatedBy(x: size.width, y: size.height)
//            transform = transform.rotated(by: CGFloat.pi)
//            break
//        case .left, .leftMirrored:
//            transform = transform.translatedBy(x: size.width, y: 0)
//            transform = transform.rotated(by: CGFloat.pi / 2.0)
//            break
//        case .right, .rightMirrored:
//            transform = transform.translatedBy(x: 0, y: size.height)
//            transform = transform.rotated(by: CGFloat.pi / -2.0)
//            break
//        case .up, .upMirrored:
//            break
//        }
//
//        //Flip image one more time if needed to, this is to prevent flipped image
//        switch imageOrientation {
//        case .upMirrored, .downMirrored:
//            transform.translatedBy(x: size.width, y: 0)
//            transform.scaledBy(x: -1, y: 1)
//            break
//        case .leftMirrored, .rightMirrored:
//            transform.translatedBy(x: size.height, y: 0)
//            transform.scaledBy(x: -1, y: 1)
//        case .up, .down, .left, .right:
//            break
//        }
//
//        ctx.concatenate(transform)
//
//        switch imageOrientation {
//        case .left, .leftMirrored, .right, .rightMirrored:
//            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
//        default:
//            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            break
//        }
//
//        guard let newCGImage = ctx.makeImage() else { return nil }
//        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
//    }
//}
