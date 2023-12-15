//
//  Extract.swift
//  CustomNavigationBar
//
//  https://github.com/GeorgeElsham/ViewExtractor
//
//

import SwiftUI

@available(iOS 15.0, *)
protocol Extractable: View {
    associatedtype Content: View
    associatedtype ViewsContent: View

    var content: () -> Content { get }
    var views: (Views) -> ViewsContent { get }

    init(_ content: Content, @ViewBuilder views: @escaping (Views) -> ViewsContent)
    init(@ViewBuilder _ content: @escaping () -> Content, @ViewBuilder views: @escaping (Views) -> ViewsContent)
}

@available(iOS 15.0, *)
public typealias Views = _VariadicView.Children

@available(iOS 15.0, *)
public struct Extract<Content: View, ViewsContent: View>: Extractable {
    let content: () -> Content
    let views: (Views) -> ViewsContent

    public init(_ content: Content, @ViewBuilder views: @escaping (Views) -> ViewsContent) {
        self.content = { content }
        self.views = views
    }

    public init(@ViewBuilder _ content: @escaping () -> Content, @ViewBuilder views: @escaping (Views) -> ViewsContent) {
        self.content = content
        self.views = views
    }

    public var body: some View {
        _VariadicView.Tree(
            UnaryViewRoot(views: views),
            content: content
        )
    }
}

@available(iOS 15.0, *)
fileprivate struct UnaryViewRoot<Content: View>: _VariadicView_UnaryViewRoot {
    let views: (Views) -> Content

    func body(children: Views) -> some View {
        views(children)
    }
}
