public protocol Filter {
    static var name: String { get }
    func apply(input: Image) -> Image
}

public protocol PixelBasedFilter: Filter { }
public protocol SpaceFilter: Filter { }
