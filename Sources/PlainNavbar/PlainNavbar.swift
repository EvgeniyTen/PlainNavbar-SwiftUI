import SwiftUI
import Foundation

@available(iOS 15.0, *)
extension PlainNavbar {
    
    @available(iOS 15.0, *)
    class ViewModel: ObservableObject {
        
        @Published var title: Title
        @Published var leftButtons: [BaseButtonViewModel]
        @Published var rightButtons: [BaseButtonViewModel]
        @Published var textColor: Color
        @Published var state: State
        
        
        public init(title: Title,
                      leftButtons: [BaseButtonViewModel] = [],
                      rightButtons: [BaseButtonViewModel] = [],
                      textColor: Color,
                      state: State = .normal
        ) {
            
            self.title = title
            self.leftButtons = leftButtons
            self.rightButtons = rightButtons
            self.textColor = textColor
            self.state = state
        }
        
        enum State {
            case normal
            case hidden
        }
        
        enum Title {
            
            case text(String)
            case empty
        }
        
        class BaseButtonViewModel: ObservableObject ,Identifiable {
            
            let id: UUID = UUID()
        }
        
        class CloseButtonViewModel: BaseButtonViewModel {
            
            @Published var icon: Image = Image(systemName: "xmark")
            @Published var action: () -> Void
            
            init(action: @escaping () -> Void) {
                self.action = action
                super.init()
            }
        }
        
        class TextButtonViewModel: BaseButtonViewModel {
            
            @Published var text: String
            @Published var action: () -> Void
            
            init(text: String, action: @escaping () -> Void) {
                self.text = text
                self.action = action
                super.init()
            }
        }
        
        class LargeTitleLabel: BaseButtonViewModel {
            @Published var text: String
            init(text: String) {
                self.text = text
            }
        }
        
        class BackButtonViewModel: BaseButtonViewModel {
            
            @Published var text: String
            @Published var action: () -> Void
            
            init(action: @escaping () -> Void) {

                self.text = "Back"
                self.action = action
                super.init()
            }
        }
    }
}
@available(iOS 15.0, *)
struct PlainNavbar: View {

    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var leftPlaceholdersCount: Int {
        
        return max(viewModel.rightButtons.count - viewModel.leftButtons.count, 0)
    }
    
    var rightPlaceholdersCount: Int {
        
        return max(viewModel.leftButtons.count - viewModel.rightButtons.count, 0)
    }
    
    var body: some View {
        
        switch viewModel.state {
            
        case .normal:
            HStack(alignment: .center, spacing: 0) {
                
                HStack(alignment: .top, spacing: 18) {
                    
                    ForEach(viewModel.leftButtons) { button in
                        
                        switch button {
                        case let backButtonViewModel as PlainNavbar.ViewModel.BackButtonViewModel:
                            Button {
                                mode.wrappedValue.dismiss()
                                backButtonViewModel.action()
                            } label: {
                                Text(backButtonViewModel.text)
                                    .foregroundColor(viewModel.textColor)
                            }
                            
                        case let largeTile as PlainNavbar.ViewModel.LargeTitleLabel:
                            Text(largeTile.text)
                                .foregroundColor(viewModel.textColor)
                                .font(.largeTitle)
                        default:
                            EmptyView()
                        }
                    }
                    ForEach(0..<leftPlaceholdersCount, id: \.self) { _ in
                        Spacer().frame(width: 20, height: 20)
                    }
                }
                
                Spacer()
                
                switch viewModel.title {
                    
                case .text(let title):
                    Text(title)
                        .foregroundColor(viewModel.textColor)
                        .font(.callout)

                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                case .empty:
                    EmptyView()
                }
                
                Spacer()
                
                HStack(alignment: .top, spacing: 18) {
                    
                    ForEach(0..<rightPlaceholdersCount, id: \.self) { _ in
                        Spacer().frame(width: 20, height: 20)
                    }
                    ForEach(viewModel.rightButtons) { button in
                        
                        switch button {
                            
                        
                        case let buttonViewModel as PlainNavbar.ViewModel.CloseButtonViewModel:
                            Button {
                                buttonViewModel.action()
                                mode.wrappedValue.dismiss()
                                
                            } label: {
                                buttonViewModel.icon
                                    .renderingMode(.template)
                                    .foregroundColor(viewModel.textColor)
                                    .padding(5)
                                    .background(
                                        Circle()
                                            .foregroundColor(.white)
                                            .shadow(color: .gray.opacity(0.1), radius: 2)
                                    )
                                
                            }
                            
                        case let buttonViewModel as PlainNavbar.ViewModel.TextButtonViewModel:
                            Button {
                                buttonViewModel.action()
                            } label: {
                                Text(buttonViewModel.text)
                                    .foregroundColor(viewModel.textColor)
                                    .font(.callout)
                            }
                            
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(
                .ultraThinMaterial
            )
            
        case .hidden:
            EmptyView()
        }
    }

}

@available(iOS 15.0, *)
public struct PlainNavbarModifier: ViewModifier {
    
    @State var viewModel: PlainNavbar.ViewModel
    
    func body(content: Content) -> some View {
        
        switch viewModel.state {
            
        case .normal:
            
            ZStack(alignment: .top) {
                
                
                content
                    .navigationBarHidden(true)
                
                PlainNavbar(viewModel: viewModel)
                
                
               
                
            }
            
        case .hidden:
            
            VStack {
                PlainNavbar(viewModel: viewModel)
                content
                    .navigationBarHidden(true)
            }
        }
    }
}

@available(iOS 15.0, *)
public extension View {
    
    public func navigationBar(with viewModel: PlainNavbar.ViewModel) -> some View {
        
        self.modifier(PlainNavbarModifier(viewModel: viewModel))
    }
}

@available(iOS 15.0, *)
extension PlainNavbar.ViewModel {
    
    
    static let sample = PlainNavbar.ViewModel(title: .text("Main"),
                                                     leftButtons: [PlainNavbar.ViewModel.LargeTitleLabel(text: "hello")],
                                                     rightButtons: [PlainNavbar.ViewModel.CloseButtonViewModel(action: {}),
                                                                    PlainNavbar.ViewModel.TextButtonViewModel(text: "Forgot?", action: {})], textColor: .black)
    
    static let onlyBackButton = PlainNavbar.ViewModel(title: .empty,
                                                     leftButtons: [PlainNavbar.ViewModel.BackButtonViewModel(action: {})],
                                                      textColor: .black)
    
    static let onlyCloseButton = PlainNavbar.ViewModel(title: .empty,
                                                       rightButtons: [PlainNavbar.ViewModel.CloseButtonViewModel(action: {})],
                                                      textColor: .black)

    
}


@available(iOS 15.0, *)
struct PlainNavbar_Previews: PreviewProvider {
    
    static var previews: some View {

        Group {
            ScrollView {
                VStack(spacing: 10) {
                    Color.blue
                        .frame(height: 180)
                    Color.red
                        .frame(height: 180)
                }
            }
            .navigationBar(with: .sample)
            
            ScrollView {
                VStack(spacing: 10) {
                    Color.blue
                        .frame(height: 180)
                    Color.red
                        .frame(height: 180)
                }
            }
            .navigationBar(with: .onlyBackButton)
            
            ScrollView {
                VStack(spacing: 10) {
                    Color.blue
                        .frame(height: 180)
                    Color.red
                        .frame(height: 180)
                }
            }
            .navigationBar(with: .onlyCloseButton)
        }
    }
}
