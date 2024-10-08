import Foundation

import Alamofire

class MultipartTruckVM {
    
    var multipartTruckData: MultipartTruckModal?
    var vidUploadData: VideoUploadModal?
    
    // MARK: url session single video upload
    func videoUpload(singleMedia: [String: MediaType],
                     complition: @escaping (Result<VideoUploadModal, Error>) -> Void) {
        
        APIServices.shared.request(
            methodType: MethodType.post,
            singleMedia: singleMedia,
            dataResponse: VideoUploadModal.self,
            url: ApiEndpoints.videoUploadGolf,
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


