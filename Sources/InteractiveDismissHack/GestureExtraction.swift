//
//  File.swift
//  InteractiveDismissHack
//
//  Created by Łukasz Rutkowski on 27/07/2024.
//

import Foundation
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

#if os(iOS)
extension EnvironmentValues {
    /// Interactive dismiss gesture that is available for current view hierarchy.
    ///
    /// - Note: For this to work correctly call ``View/extractInteractiveDismissGesture()`` in parent context.
    public fileprivate(set) var interactiveDismissGesture: UIGestureRecognizer? {
        get { self[InteractiveDismissGestureKey.self] }
        set { self[InteractiveDismissGestureKey.self] = newValue }
    }
}
#endif

extension View {
    /// Extracts interactive dismiss gesture from the current view and makes
    /// it available for subviews via environment through ``EnvironmentValues/interactiveDismissGesture``.
    @MainActor
    @available(macOS, unavailable)
    public func extractInteractiveDismissGesture() -> some View {
        #if os(iOS)
        return self.modifier(ExtractInteractiveDismissGesture())
        #else
        return self
        #endif
    }
}

// MARK: - Internal

#if os(iOS)
@MainActor
private struct ExtractInteractiveDismissGesture: ViewModifier {
    @State private var interactiveDismissGesture: UIGestureRecognizer?

    func body(content: Content) -> some View {
        content
            .introspect(.viewController, on: .iOS(.v16...)) { (viewController: UIViewController) in
                guard interactiveDismissGesture == nil else { return }
                self.extractInteractiveDismissGesture(from: viewController)
            }
            .environment(\.interactiveDismissGesture, interactiveDismissGesture)
    }

    private func extractInteractiveDismissGesture(from viewController: UIViewController) {
        let sheetViewController = sequence(first: viewController, next: \.parent)
            .first { $0.presentationController?.presentedView != nil }
        if
            let presentedView = sheetViewController?.presentationController?.presentedView,
            let dismissGesture = presentedView.gestureRecognizers?.first
        {
            DispatchQueue.main.async {
                interactiveDismissGesture = dismissGesture
            }
        }
    }
}

private struct InteractiveDismissGestureKey: EnvironmentKey {
    static let defaultValue: UIGestureRecognizer? = nil
}
#endif
