//
//  Toast.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 10.04.2021.
//

import UIKit

class Toast {
    
    class func makeToast(_ message: String, duration: TimeInterval = 3.0) {
        guard let toast = toastViewForMessage(message) else { return }

        showToast(toast, duration: duration)
    }

    private class func topWindow() -> UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
        }
        return nil
    }


    private class func showToast(_ toast: UIView, duration: TimeInterval) {
        guard let superview = Self.topWindow() else { return }
        
        let verticalPadding: CGFloat = 10.0
        let bottomPadding: CGFloat = verticalPadding + superview.csSafeAreaInsets.bottom
        
        let centerPoint = CGPoint(
            x: superview.bounds.size.width / 2.0,
            y: (superview.bounds.size.height - (toast.frame.size.height / 2.0)) - bottomPadding
        )

        let shiftedCenterPoint = CGPoint(
            x: centerPoint.x,
            y: centerPoint.y + 5
        )
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleToastTapped(_:)))
        toast.addGestureRecognizer(recognizer)
        toast.isUserInteractionEnabled = true
        toast.isExclusiveTouch = true
        
        superview.addSubview(toast)

        toast.center = shiftedCenterPoint
        toast.alpha = 0.0

        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            toast.alpha = 1.0
            toast.center = centerPoint
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.hideToast(toast)
            }
        }
    }
    
    private class func hideToast(_ toast: UIView, fromTap: Bool = false) {
        let shiftedCenterPoint = CGPoint(
            x: toast.center.x,
            y: toast.center.y + 5
        )

        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            toast.alpha = 0.0
            toast.center = shiftedCenterPoint
        }) { _ in
            toast.removeFromSuperview()
        }
    }
    
    @objc
    private class func handleToastTapped(_ recognizer: UITapGestureRecognizer) {
        guard let toast = recognizer.view else { return }
        hideToast(toast, fromTap: true)
    }
    
    private class func toastViewForMessage(_ message: String) -> UIView? {
        guard let superview = topWindow() else { return nil }

        let maxWidthPercentage: CGFloat = 0.8

        let horizontalPadding: CGFloat = 10.0
        let verticalPadding: CGFloat = 4.0

        let wrapperView = UIView()
        wrapperView.backgroundColor = .red
        wrapperView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        wrapperView.layer.cornerRadius = 5
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.numberOfLines = 2
        messageLabel.font = .systemFont(ofSize: 16.0)
        messageLabel.textAlignment = .center
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.textColor = .white
        messageLabel.backgroundColor = UIColor.clear

        let maxMessageSize = CGSize(width: superview.bounds.size.width * maxWidthPercentage, height: superview.bounds.size.height)
        
        let messageSize = messageLabel.sizeThatFits(maxMessageSize)
        let actualWidth = min(messageSize.width, maxMessageSize.width)
        let actualHeight = min(messageSize.height, maxMessageSize.height)
        messageLabel.frame = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)

        
        var messageRect = CGRect.zero
        messageRect.origin.x = horizontalPadding
        messageRect.origin.y = verticalPadding
        messageRect.size.width = messageLabel.bounds.size.width
        messageRect.size.height = messageLabel.bounds.size.height
        
        let wrapperWidth = (messageRect.origin.x + messageRect.size.width + horizontalPadding)
        let wrapperHeight = (messageRect.origin.y + messageRect.size.height + verticalPadding)
        
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)
        
        messageLabel.frame = messageRect
        wrapperView.addSubview(messageLabel)
        
        return wrapperView
    }
}


private extension UIView {
    
    var csSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return .zero
        }
    }
    
}
