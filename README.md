# PlainNavbar
The GitHub repository provides a custom navigation bar element for use in Swift UI projects. There is plain custom navigation bar element​​​​​​. That's all :)

For a more comprehensive understanding or usage examples of this Swift package, it would be advisable to explore the source code directly in the repository or contact the repository owner for more detailed information.

# Define a Custom Toolbar View:
First, create a custom view for the toolbar. This view can contain any SwiftUI view elements. In this example, it consists of leading and trailing bar items grouped together:

```swift
var toolbar: some View {
    Group {
       leadingBarItem
       trailingBarItem
    }
}
```

# Define the Bar Items:
Define the individual bar items that make up the toolbar. Each bar item should specify its position (leading or trailing). Here's an example for a leading bar item:

```swift
private var leadingBarItem: some View {
    Image(systemName: "heart.fill")
        .renderingMode(.template)
        .onTapGesture {
            // some action
        }
        .toolbarSide(.leading)
}
```

# Add the Toolbar to Your View:
Finally, add the toolbar to your view using the .navigationBar modifier. You pass the previously defined toolbar view as a parameter to this modifier. The toolbar view is rendered accordingly, and you can attach actions to its elements:

```swift
.navigationBar {
    toolbar
}
```

This example shows how to integrate a custom navigation bar into your SwiftUI views, allowing you to customize the appearance and behavior of the navigation elements. The toolbarSide method is presumably a custom method provided by the PlainNavbar-SwiftUI package to specify the position of each bar item within the navigation bar.
