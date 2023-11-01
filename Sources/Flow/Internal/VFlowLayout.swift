import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct VFlowLayout {
    private let layout: FlowLayout

    public init(
        alignment: HorizontalAlignment,
        itemSpacing: CGFloat?,
        columnSpacing: CGFloat?
    ) {
        layout = .vertical(alignment: alignment,
                           itemSpacing: itemSpacing,
                           lineSpacing: columnSpacing)
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension VFlowLayout: Layout {
    public func sizeThatFits(proposal: ProposedViewSize, subviews: LayoutSubviews, cache: inout ()) -> CGSize {
        layout.sizeThatFits(proposal: proposal, subviews: subviews, cache: &cache)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: LayoutSubviews, cache: inout ()) {
        layout.placeSubviews(in: bounds, proposal: proposal, subviews: subviews, cache: &cache)
    }

    public static var layoutProperties: LayoutProperties {
        var properties = LayoutProperties()
        properties.stackOrientation = .vertical
        return properties
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior {
        layout.layoutDirectionBehavior
    }
}
