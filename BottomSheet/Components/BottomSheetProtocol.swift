import UIKit

// Protocol to give access to presentation delegates
public protocol BottomSheetProtocol: UIAdaptivePresentationControllerDelegate, AnyObject where Self: UIView {}
