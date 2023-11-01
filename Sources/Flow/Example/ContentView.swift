import SwiftUI

@available(macOS 13.0, *)
struct ContentView: View {
    @State private var axis: Axis = .horizontal
    @State private var width: CGFloat = 400
    @State private var height: CGFloat = 400
    @State private var itemSpacing: CGFloat? = nil
    @State private var lineSpacing: CGFloat? = nil
    @State private var horizontalAlignment: HAlignment = .center
    @State private var verticalAlignment: VAlignment = .center
    private let items: [String] = "This is a long text that wraps nicely in flow layout".components(separatedBy: " ")

    enum HAlignment: String, Hashable, CaseIterable, CustomStringConvertible {
        case leading, center, trailing
        var description: String { rawValue }
        var value: HorizontalAlignment {
            switch self {
                case .leading: return .leading
                case .center: return .center
                case .trailing: return .trailing
            }
        }
    }

    enum VAlignment: String, Hashable, CaseIterable, CustomStringConvertible {
        case top, baseline, center, bottom
        var description: String { rawValue }
        var value: VerticalAlignment {
            switch self {
                case .top: return .top
                case .baseline: return .firstTextBaseline
                case .center: return .center
                case .bottom: return .bottom
            }
        }
    }

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List {
                Section(header: Text("Layout")) {
                    picker($axis)
                }
                Section(header: Text("Size")) {
                    Grid {
                        GridRow {
                            Text("Width").gridColumnAlignment(.leading)
                            Slider(value: $width.animation(), in: 0...400)
                                .padding(.horizontal)
                        }
                        GridRow {
                            Text("Height")
                            Slider(value: $height.animation(), in: 0...400)
                                .padding(.horizontal)
                        }
                    }
                }
                Section(header: Text("Alignment")) {
                    switch axis {
                    case .horizontal:
                        picker($verticalAlignment)
                    case .vertical:
                        picker($horizontalAlignment)
                    }
                }
                Section(header: Text("Spacing")) {
                    stepper("Item", $itemSpacing)
                    stepper("Line", $lineSpacing)
                }
            }
            .listStyle(.sidebar)
            .frame(minWidth: 250)
            .navigationTitle("Flow Layout")
            .padding()
        } detail: {
            layout {
                ForEach(items, id: \.self, content: Text.init)
            }
            .border(.red.opacity(0.2))
            .frame(maxWidth: width, maxHeight: height)
            .border(.red)
        }
    }

    private func stepper(_ title: String, _ selection: Binding<CGFloat?>) -> some View {
        HStack {
            Toggle(isOn: Binding(get: { selection.wrappedValue != nil },
                                 set: { selection.wrappedValue = $0 ? 8 : nil }).animation()) {
                Text(title)
            }
            if let value = selection.wrappedValue {
                Text("\(value.formatted())")
                Stepper("", value: Binding(get: { value },
                                           set: { selection.wrappedValue = $0 }).animation(), step: 4)
            }
        }.fixedSize()
    }

    private func picker<Value>(_ selection: Binding<Value>) -> some View where Value: Hashable & CaseIterable & CustomStringConvertible, Value.AllCases: RandomAccessCollection {
        Picker("", selection: selection.animation()) {
            ForEach(Value.allCases, id: \.self) { value in
                Text(value.description).tag(value)
            }
        }
        #if !os(watchOS)
        .pickerStyle(.segmented)
        #endif
    }

    private var layout: AnyLayout {
        switch axis {
            case .horizontal:
            return AnyLayout(
                HFlow(
                    alignment: verticalAlignment.value,
                    itemSpacing: itemSpacing,
                    rowSpacing: lineSpacing
                )
            )
            case .vertical:
            return AnyLayout(
                VFlow(
                    alignment: horizontalAlignment.value,
                    itemSpacing: itemSpacing,
                    columnSpacing: lineSpacing
                )
            )
        }
    }
}

@available(macOS 13.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
