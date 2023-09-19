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
        showBottomSheet(with: sheet)
    }
}

// MARK: Methods of SheetViewDelegate

extension ViewController: SheetViewDelegate {

    func cancelButtonWasClicked() {
        dismissBottomSheet()
    }

    func confirmButtonWasClicked() {
        dismissBottomSheet {
            print("do action after cancel button clicked")
        }
    }
}

// MARK: UIViewController extension

extension UIViewController {

    func showBottomSheet(with sheet: UIView) {
        let presented = PresentedSheetViewController(sheet: sheet)
        let bottomSheet = BottomSheetViewController(
            presented: presented,
            presenting: self,
            edges: .init(top: 16, left: 16, bottom: 16, right: 16),
            sheetGestures: sheet.gestureRecognizers
        )
        presented.transitioningDelegate = bottomSheet
        present(presented, animated: true, completion: nil)
    }

    func dismissBottomSheet(completion: (() -> Void)? = nil) {
        presentedViewController?.dismiss(animated: true, completion: completion)
    }
}
