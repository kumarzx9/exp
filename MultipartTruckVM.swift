

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
    
    // MARK: almofire golf app single video upload
    func singleVideoUpload(parameters: [String: Any], videoURL: URL, videoParamName: String, completion: @escaping (_ result: VideoUploadModal?, _ error: Error?) -> ()) {

        let token = ApiEndpoints.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token ?? "")"]
        
        APIServices.shared.alamofire_uploadVideo(url: "https://golf-aligner.netscapelabs.com/api/user/video-upload", method: .post, parameters: parameters, videoURL: videoURL, videoParamName: videoParamName, headers: headers) { data, error in
            
            if let error = error {
                // Handle error scenario
                self.vidUploadData = nil
                completion(nil, error)
            } else if let data = data {
                // Decode the raw data into the VideoUploadModal
                do {
                    let decodedResult = try JSONDecoder().decode(VideoUploadModal.self, from: data)
                    self.vidUploadData = decodedResult
                    completion(decodedResult, nil)
                } catch {
                    // Handle decoding error
                    print("Decoding error: \(error.localizedDescription)")
                    self.vidUploadData = nil
                    completion(nil, error)
                }
            }
        }
    }

    
    // MARK: url session single img/video upload eg. here golf, eg. babblebot phase 2
    func imgVidUpload(parameters: [String: Any], uploadDataType: String, imgVidData: Data, imgVidParamName: String, completion: @escaping (_ result: VideoUploadModal?, _ error: Error?) -> ()) {

        let headers: [String: String] = ["Authorization": "Bearer \(ApiEndpoints.token ?? "")"]
        APIServices.shared.urlSessionUploadVideo(url: "https://golf-aligner.netscapelabs.com/api/user/video-upload", uploadDataType: uploadDataType, method: "POST", parameters: parameters, imgVidData: imgVidData, imgVidParamName: imgVidParamName, headers: headers) { data, response, error in
                
                if let error = error {
                    completion(nil, error)
                    return
                }

                guard let data = data else {
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(VideoUploadModal.self, from: data)
                    completion(result, nil)
                } catch let parsingError {
                    completion(nil, parsingError)
                }
            }
        }

    
    
 
    
}
