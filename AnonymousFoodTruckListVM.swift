

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
    
    
 // MARK: url session post/get
    func fetchRequest(parm: [String: Any], complition: @escaping (Result<AnonnymousTruckListModal, Error>) -> Void) {
        APIServices.shared.request(methodType: MethodType.post,
                                   param: parm,
                                   dataResponse: AnonnymousTruckListModal.self,
                                   url: ApiEndpoints.truckListAnonnymous,
                                   token: ApiEndpoints.token ?? "") { response in
            switch response {
            case .success(let data):
                complition(.success(data))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    
    
}
