public class Histogram: CustomStringConvertible {
    private(set) var values = [Int](repeating: 0, count: 256)
    
    public var numberOfPixels: Int {
        return values.reduce(0,+)
    }
    
    public var description: String {
        return values.description
    }
    
    public init(values: [Int]? = nil) {
        if values != nil && values!.count != self.values.count {
            fatalError("Histogram creation error: values.count is \(values!.count). It should be \(self.values.count)")
        }
        
        guard let val = values else { return }
        self.values = val
    }
    
    public func set(atIndex index: Int, value: Int) {
        values[index] = value
    }
    
    public func get(at index: Int) -> Int {
        return values[index]
    }
    
    public func sum(toIndex index: Int, value: Int) {
        values[index] += value
    }
    
    //MARK: - Operations
    
    public func getCumulativeHistogram() -> Histogram {
        let cumulativeHistogram = Histogram()
        for i in 0 ..< values.count {
            if i == 0 {
                cumulativeHistogram.set(atIndex: i, value: values[i])
                continue
            }
            cumulativeHistogram.set(atIndex: i, value: cumulativeHistogram.values[i-1])
            cumulativeHistogram.sum(toIndex: i, value: values[i])
        }
        
        return cumulativeHistogram
    }
    
    public func getEqualizedHistogram() -> Histogram {
        let cumHist = getCumulativeHistogram()
        let total = cumHist.values.last!
        let avg = total / 255
        
        let equalizedHistogram = Histogram()
        for i in 0 ..< values.count {
            equalizedHistogram.set(atIndex: i, value: Int(avg))
        }
        
        return equalizedHistogram
    }
    
    public func normalized(to val: Double = 255.0) -> Histogram {
        let normalizedHistogram = Histogram(values: self.values)
        let maxVal = normalizedHistogram.values.max()!
        normalizedHistogram.values = normalizedHistogram.values.map { return Int((Double($0) / Double(maxVal))*val) }
        
        return normalizedHistogram
    }
}
