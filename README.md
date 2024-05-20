# InteractiveDismissHack

`InteractiveDismissHack` allows you to enable interactive dismiss on modal screens that contain scroll views nested in other scroll views.

In the following example this function will make it possible to dismiss modal sheet by swiping down on `ScrollView` that is placed inside of `TabView` with page style.

```swift
TabView {
    ScrollView {
        // ...
    }
    .nestedInteractiveDismissEnabled()
}
.tabViewStyle(.page)
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
