import UIKit

// MARK: - Methods
public extension UITextView {

	/// Scroll to the bottom of text view
	public func scrollToBottom() {
		let range = NSRange(location: (text as NSString).length - 1, length: 1)
		scrollRangeToVisible(range)
	}

	/// Scroll to the top of text view
	public func scrollToTop() {
		let range = NSRange(location: 0, length: 1)
		scrollRangeToVisible(range)
	}
}
