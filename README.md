# InteractiveDismissHack

`InteractiveDismissHack` allows you to enable interactive dismiss on modal screens that contain scroll views nested in other scroll views.

In the following example this function will make it possible to dismiss modal sheet by swiping down on `ScrollView` that is placed inside of `TabView` with page style.

```swift
import SwiftUI
import InteractiveDismissHack

struct ContentView: View {
    var body: some View {
        TabView {
            ScrollView {
                // ...
            }
            .nestedInteractiveDismissEnabled()
        }
        .tabViewStyle(.page)
    }
}
```

Additionally you can access interactive dismiss gesture recognizer via environment.

```swift
import SwiftUI
import InteractiveDismissHack

struct ParentView: View {
    var body: some View {
        ZStack {
            // ...
        }
        .sheet(isPresented: ...) {
            ChildView()
                .extractInteractiveDismissGesture() // Make gesture available
        }
    }
}

struct ChildView: View {
    // Access gesture
    @Environment(\.interactiveDismissGesture) private var interactiveDismissGesture
    
    var body: some View {
        // ...
    }
}
```  

> [!IMPORTANT]
> This library modifies internal behavior of UIScrollView and might break with newer version of iOS. Use at your own risk.

## Installation

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/Tunous/InteractiveDismissHack", from: "0.1.0"),
    ],
    targets: [
        .target(name: <#Target Name#>, dependencies: [
            .product(name: "InteractiveDismissHack", package: "InteractiveDismissHack"),
        ]),
    ]
)
```
