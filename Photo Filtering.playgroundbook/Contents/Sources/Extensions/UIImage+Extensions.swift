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
