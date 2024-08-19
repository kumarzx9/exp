
import Foundation
import ProgressHUD

class LoadingManager {
    
    static let shared = LoadingManager()
    private init() {
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    func showLoading() {
        ProgressHUD.animate()
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
    }
}
