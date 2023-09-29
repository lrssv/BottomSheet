import UIKit

class ViewController: UIViewController {

    // MARK: Properties

    let sheet = SheetView()

    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheet.delegate = self
    }

    // MARK: Methods

    @IBAction func didTouchUp(_ sender: UIButton) {
        // You can use the sheet as BottomSheetProtocol to access delegate functions
        // if that doesn't interested you, just create a sheet as UIView and
        // use the func showBottomSheet(with sheet: UIView, ...)
        showBottomSheet(by: sheet, showIndicatorView: true)
    }
}

// MARK: Methods of SheetViewDelegate

extension ViewController: SheetViewDelegate {

    func cancelButtonWasClicked() {
        dismissBottomSheet()
    }

    func confirmButtonWasClicked() {
        dismissBottomSheet {
            print("do some action after confirm button clicked")
        }
    }

    func didDismiss() {
        print("bottom sheet didDismiss by delegate")
    }
}

// MARK: UIViewController extension

extension UIViewController {

    // If you want access in any view controller your sheet class that was insert
    // you can use this through of a casting to your custom class
    var presentedSheet: UIView? {
        (presentedViewController as? PresentedSheetViewController)?.sheet
    }

    func showBottomSheet(with sheet: UIView, edges: UIEdgeInsets? = nil, showIndicatorView: Bool = false) {
        // The indicator view is a UI accessory that is default in your bottom sheet, witch you can show or not show
        // depending on the constructor. You can have any type of customization in your presented sheet view controller
        let presented = PresentedSheetViewController(sheet: sheet, showIndicatorView: showIndicatorView)
        let bottomSheet = BottomSheetViewController(
            presented: presented,
            presenting: self,
            edges: edges, // for insert margins inside your bottom sheet
            sheetGestures: sheet.gestureRecognizers // in case of have previous gestures in your sheet like swipe
        )
        // The magic happens here. You'll tell your presented view controller what class is responsible to present it
        presented.transitioningDelegate = bottomSheet
        present(presented, animated: true, completion: nil)
    }

    func showBottomSheet(by sheet: BottomSheetProtocol, edges: UIEdgeInsets? = nil, showIndicatorView: Bool = false) {
        let presented = PresentedSheetViewController(sheet: sheet, showIndicatorView: showIndicatorView)
        let bottomSheet = BottomSheetViewController(
            presented: presented,
            presenting: self,
            edges: edges,
            sheetGestures: sheet.gestureRecognizers
        )
        presented.transitioningDelegate = bottomSheet
        bottomSheet.delegate = sheet
        present(presented, animated: true, completion: nil)
    }

    func dismissBottomSheet(completion: (() -> Void)? = nil) {
        presentedViewController?.dismiss(animated: true, completion: completion)
    }
}
