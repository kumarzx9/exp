

import Foundation

import Alamofire

class MultipartTruckVM {
    
    var multipartTruckData: MultipartTruckModal?
    var vidUploadData: VideoUploadModal?
    
    // MARK: almofire chorwtux create or edit truck
    func createTruck(parameters: [String: Any], profileImage1: UIImage?, profileImgName1: String, profileImage2: UIImage?, profileImgName2: String, imagesArray: [UIImage], completion: @escaping (_ result: MultipartTruckModal?, _ error: Error?) -> ()) {
        let token = ApiEndpoints.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token ?? "")"]
        APIServices.shared.alamofire_uploadImages(url: ApiEndpoints.createTruck, method: .post, parameters: parameters, profileImage1: profileImage1, profileImgName1: profileImgName1, profileImage2: profileImage2, profileImgName2: profileImgName2, imagesArray: imagesArray, headers: headers) { result, error in
            if let result = result {
               // debugPrint("Success: \(result)")
                self.multipartTruckData = result as? MultipartTruckModal
                completion(result as? MultipartTruckModal, nil)
            } else if let error = error {
                //print("Error: \(error)")
                self.multipartTruckData = nil
                completion(nil, error)
            }
        }
        
    }
    
     // MARK: media Upload Url session // image or video with optional image array
    func mediaUpload(parms: [String: Any],
                     singleMedia: [String: MediaType],
                     multipleImages: [String: [UIImage]],
                     complition: @escaping (Result<MultipartTruckModal, Error>) -> Void) {
        
        APIServices.shared.request(
            methodType: MethodType.post,
            param: parms,
            singleMedia: singleMedia,
            multipleImages: multipleImages,
            dataResponse: MultipartTruckModal.self,
            url: ApiEndpoints.createTruck,
            token: ApiEndpoints.token ?? ""
        ) { response in
            switch response {
            case .success(let data):
                complition(.success(data))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    
 
    
}
