import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

extension View {
    /// Modifies sheet interactive dismiss behavior to work for nested scroll views.
    ///
    /// In the following example this function will make it possible to dismiss modal sheet by swiping down on scroll
    /// view that is nested inside of TabView with page style.
    ///
    /// ```swift
    /// TabView {
    ///     ScrollView {
    ///         // ...
    ///     }
    ///     .nestedInteractiveDismissEnabled()
    /// }
    /// .tabViewStyle(.page)
    /// ```
    @MainActor
    @available(macOS, unavailable)
    public func nestedInteractiveDismissEnabled() -> some View {
        #if os(iOS)
        return self.introspect(.scrollView, on: .iOS(.v16...)) { scrollView in
            scrollView.enableInteractiveDismiss()
        }
        #else
        return self
        #endif
    }
}

#if os(iOS)
extension UIScrollView {
    fileprivate static let swizzleInteractiveDismiss: Void = {
        guard
            let original = class_getInstanceMethod(UIScrollView.self, Selector(("_parentScrollView"))),
            let swizzled = class_getInstanceMethod(UIScrollView.self, #selector(swizzledParentScrollView))
        else {
            assertionFailure("Unable to enable nested interactive dismiss. Most likely internal implementation of UIScrollView changed making this library unusable.")
            return
        }
        method_exchangeImplementations(original, swizzled)
    }()

    fileprivate static var shouldEnableInteractiveDismissHack: Set<ObjectIdentifier> = []

    fileprivate func enableInteractiveDismiss() {
        Self.swizzleInteractiveDismiss
        Self.shouldEnableInteractiveDismissHack.insert(ObjectIdentifier(self))
    }

    @objc private func swizzledParentScrollView() -> UIScrollView? {
        if Self.shouldEnableInteractiveDismissHack.contains(ObjectIdentifier(self)) {
            return nil
        }
        return swizzledParentScrollView()
    }
}
#endif
