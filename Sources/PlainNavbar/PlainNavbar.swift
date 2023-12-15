import SwiftUI

public enum BarItemAlignment: String {
    case leading = "leading"
    case trailing = "trailing"
    case center = "center"
}
@available(iOS 15.0, *)
public enum BarForegroundType {
    case colored(Color)
    case none
}
@available(iOS 15.0, *)
struct NavigationBarContent: View {
    let foregroundStyle: BarForegroundType
    let barHeight: CGFloat
    
    let topLeft: [AnyView]
    let topCenter: [AnyView]
    let topRight: [AnyView]
    
    var body: some View {
        HStack {
            HStack(spacing: 20) {
                ForEach(topLeft.indices, id: \.self) { index in
                    topLeft[index]
                }
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                ForEach(topCenter.indices, id: \.self) { index in
                    topCenter[index]
                }
            }
            Spacer()
            HStack(spacing: 20) {
                ForEach(topRight.indices, id: \.self) { index in
                    topRight[index]
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(height: barHeight)
        .background(
            backgroundColor
        )
    }
}
@available(iOS 15.0, *)
extension NavigationBarContent {
    @ViewBuilder var backgroundColor: some View {
        switch foregroundStyle {
        case .none:
            Color.clear
                .ignoresSafeArea(edges: .top)
        case .colored(let color):
            color
                .ignoresSafeArea(edges: .top)
        }
    }
}

@available(iOS 15.0, *)
struct NavigationBarViewModifier<C: View>: ViewModifier {
    let foregroundStyle: BarForegroundType
    let barHeight: CGFloat
    @ViewBuilder let barItems: C
    
    func body(content: Content) -> some View {
        
        VStack(spacing: 0) {
            
            if #available(iOS 16.0, *) {
                content
                    .toolbar(.hidden, for: .navigationBar)
            } else {
                content
                    .navigationBarHidden(true)
            }
            Extract(barItems) { views in
                NavigationBarContent(
                    foregroundStyle: foregroundStyle,
                    barHeight: barHeight,
                    topLeft: filtered(views, .leading),
                    topCenter: filtered(views, .center),
                    topRight: filtered(views, .trailing)
                )
            }
        }
    }
    
    private func filtered(_ views: Views, _ side: BarItemAlignment) -> [AnyView] {
        var viewsArray = [AnyView]()
        views.forEach { view in
            if let id = view.id as? String,
               id.contains(side.rawValue) {
                viewsArray.append(AnyView(view))
            }
        }
        return viewsArray
    }
}
@available(iOS 15.0, *)
public extension View {
        
    /// In this example, we have a custom view instead of a disabled navigation bar.
    /// This toolbar is very easy to use: it is enough to transfer the content
    /// to this method, which is simple swift UIview object, as in the code example below:
    ///
    ///      var toolbar: some View {
    ///        Group {
    ///           leadingBarItem
    ///           trailingBarItem
    ///         }
    ///     }
    ///
    ///     Adding required properties to a toolbar object
    /// You must specify its belonging to the side where it should be located,
    /// when creating a Bar Item object, as an example (see the last line)
    ///
    ///     private var leadingBarItem: some View {
    ///         Image(systemName: "heart.fill")
    ///             .renderingMode(.template)
    ///             .onTapGesture {
    ///                 // some action
    ///             }
    ///             .toolbarSide(.leading)
    ///     }
    ///
    ///     Add the toolbar object to the modifier method and get the magic
    /// The previously created toolbar must be passed to the current modifier method
    /// as an incoming parameter, as in the example below:
    ///
    ///     .navigationBar {
    ///         toolbar
    ///             .renderingMode(.template)
    ///             .onTapGesture {
    ///                 // some action
    ///             }
    ///             .toolbarSide(.leading)
    ///     }
    ///
    func navigationBar<C: View>(
        foregroundStyle: BarForegroundType = .none,
        barHeight: CGFloat = 50,
        @ViewBuilder content: () -> C) -> some View {
            self.modifier(NavigationBarViewModifier(foregroundStyle: foregroundStyle, barHeight: barHeight, barItems: content))
        }
    
    func toolbarSide(_ alignmemt: BarItemAlignment) -> some View {
        self.id(UUID().uuidString + alignmemt.rawValue)
    }
}
