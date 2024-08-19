

import Foundation
import Alamofire

final class AnonymousFoodTruckListVM {

    // MARK: method 2 alamofire
    func fetchData2(parms: [String: Any], complition: @escaping (Result<AnonnymousTruckListModal, Error>) -> Void) {
        LoadingManager.shared.showLoading()
        let headers: HTTPHeaders = ["Authorization": "Bearer \(ApiEndpoints.token ?? "")"]
        AF.request(ApiEndpoints.truckListAnonnymous, method: .post, parameters: parms, headers: headers)
            .responseDecodable(of: AnonnymousTruckListModal.self) { response in
                LoadingManager.shared.hideLoading()
                switch response.result {
                case .success(let response):
                    complition(.success(response))
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
    
    
    // MARK: method 4 url session with common method of get or post
    func fetchData4(parms: [String: Any], complition: @escaping (Result<AnonnymousTruckListModal, Error>) -> Void) {
        LoadingManager.shared.showLoading()
        let token = ApiEndpoints.token ?? ""
        APIServices.shared.request(methodType: MethodType.post.rawValue, param: parms, dataResponse: AnonnymousTruckListModal.self, url: ApiEndpoints.truckListAnonnymous, token: "Bearer \(token)") {response in
            LoadingManager.shared.hideLoading()
            switch response{
            case .success(let user):
                complition(.success(user))
            case.failure(let erroor):
                complition(.failure(erroor))
            }
        }
    }
    
    
    
}
