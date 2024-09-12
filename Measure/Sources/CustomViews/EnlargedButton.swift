import UIKit

final class EnlargedButton: UIButton {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let touchArea = CGRect(
            x: -bounds.width * 0.25,
            y: -bounds.height * 0.25,
            width: bounds.width * 1.5,
            height: bounds.height * 1.5
        )

        return touchArea.contains(point) ? self : nil
    }
}
