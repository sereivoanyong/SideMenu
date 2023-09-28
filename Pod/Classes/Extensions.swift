//
//  Extensions.swift
//  Pods-Example
//
//  Created by Jon Kent on 7/1/19.
//

import UIKit

extension NSObject: InitializableClass {}

extension UIView {

    @discardableResult func untransformed(_ block: () -> CGFloat) -> CGFloat {
        let t = transform
        transform = .identity
        let value = block()
        transform = t
        return value
    }

    func bringToFront() {
        superview?.bringSubviewToFront(self)
    }

    func untransform(_ block: () -> Void) {
        untransformed { () -> CGFloat in
            block()
            return 0
        }
    }

    static func animationsEnabled(_ enabled: Bool = true, _ block: () -> Void) {
        let a = areAnimationsEnabled
        setAnimationsEnabled(enabled)
        block()
        setAnimationsEnabled(a)
    }
}

extension UIViewController {

    // View controller actively displayed in that layer. It may not be visible if it's presenting another view controller.
    var activeViewController: UIViewController {
        switch self {
        case let navigationController as UINavigationController:
            return navigationController.topViewController?.activeViewController ?? self
        case let tabBarController as UITabBarController:
            return tabBarController.selectedViewController?.activeViewController ?? self
        case let splitViewController as UISplitViewController:
            return splitViewController.viewControllers.last?.activeViewController ?? self
        default:
            return self
        }
    }

    // View controller being displayed on screen to the user.
    var topMostViewController: UIViewController {
        let activeViewController = activeViewController
        return activeViewController.presentedViewController?.topMostViewController ?? activeViewController
    }

    var containerViewController: UIViewController {
        return navigationController?.containerViewController ??
            tabBarController?.containerViewController ??
            splitViewController?.containerViewController ??
            self
    }

    @objc var isHidden: Bool {
        return presentingViewController == nil
    }
}

extension UIGestureRecognizer {

    func remove() {
        view?.removeGestureRecognizer(self)
    }
}

extension UIPanGestureRecognizer {

    var canSwitch: Bool {
        return !(self is UIScreenEdgePanGestureRecognizer)
    }

    var xTranslation: CGFloat {
        return view?.untransformed {
            return self.translation(in: view).x
            } ?? 0
    }

    var xVelocity: CGFloat {
        return view?.untransformed {
            return self.velocity(in: view).x
            } ?? 0
    }
}

extension UIApplication {

    var keyWindow: UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
}
