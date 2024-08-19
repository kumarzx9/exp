
import Foundation
import Alamofire


// MARK: ApiParms
struct ApiParms {

    static let  = ""

}

//--------------------------------------------

// MARK: ApiEndpoints
struct ApiEndpoints {
    
    static let baseUrl                  =         ""
    static let       =         baseUrl + ""
    
    static let token: String? = ""
}

//--------------------------------------------

// MARK: ApiManager
class APIServices {
    
    static let shared = APIServices()
    private init(){}
    
    // MARK:  struct methodType used globally with instance
      func request<T:Decodable>(methodType: String, param: [String:Any], dataResponse: T.Type , url: String, token: String, complition: @escaping (Result<T,Error>) -> Void) {
         guard let Url = URL(string: url) else{
             return
         }
         var request = URLRequest(url: Url)
         request.httpMethod = methodType
         if methodType == MethodType.post.rawValue {
             let body = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed)
             request.httpBody = body
         }
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         if !token.isEmpty {
             request.setValue("\(token)", forHTTPHeaderField: "Authorization")
         }
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data else {
                 complition(.failure(error!))
                 return
             }
             do{
                 let json = try JSONDecoder().decode(dataResponse, from: data)
                 complition(.success(json))
             }
             catch{
                 complition(.failure(error))
             }
         }
         task.resume()
     }
    
    // MARK: alamofire multipart upload two individual images and a array of image and parameters
     func alamofire_uploadImages(url: String, method: HTTPMethod, parameters: [String: Any], profileImage1: UIImage?, profileImgName1: String, profileImage2: UIImage?, profileImgName2: String, imagesArray: [UIImage], headers: HTTPHeaders?, completion: @escaping (_ result: AnyObject?, _ error: Error?) -> ()) {
        
        AF.upload(multipartFormData: { multipartFormData in
            // Profile image 1
            if let imageData1 = profileImage1?.jpegData(compressionQuality: 0.1) {
                multipartFormData.append(imageData1, withName: profileImgName1, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpg")
            }

            // Profile image 2
            if let imageData2 = profileImage2?.jpegData(compressionQuality: 0.1) {
                multipartFormData.append(imageData2, withName: profileImgName2, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpg")
            }

            // Images array
            imagesArray.forEach { img in
                if let imageData = img.jpegData(compressionQuality: 0.1) {
                    multipartFormData.append(imageData, withName: "images[]", fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpg")
                }
            }

            // Other parameters
            for (key, value) in parameters {
                if let val = value as? String {
                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
                }
            }

        }, to: url, method: method, headers: headers)
        .uploadProgress { progress in
             print(progress) //if needed
        }
        .responseDecodable(of: MultipartTruckModal.self) { response in
            switch response.result {
            case .success(let result):
                completion(result as AnyObject, nil)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
    
    // MARK: alamofire single video upload
      func alamofire_uploadVideo(url: String, method: HTTPMethod, parameters: [String: Any], videoURL: URL, videoParamName: String, headers: HTTPHeaders?, completion: @escaping (_ data: Data?, _ error: Error?) -> ()) {

        AF.upload(multipartFormData: { multipartFormData in
            // Video
            multipartFormData.append(videoURL, withName: videoParamName, fileName: "video_file\(arc4random_uniform(100)).mov", mimeType: "video/quicktime")

            // Other parameters
            for (key, value) in parameters {
                if let val = value as? String {
                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
                }
            }

        }, to: url, method: method, headers: headers)
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }

    // MARK: url session single image upload eg. here golf
     func urlSessionUploadVideo(url: String, uploadDataType: String, method: String, parameters: [String: Any], imgVidData: Data, imgVidParamName: String, headers: [String: String]?, completion: @escaping (_ result: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
               
               // Create URL request
               var request = URLRequest(url: URL(string: url)!)
               request.httpMethod = method
               
               // Add headers
               headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }

               // Boundary for multipart form data
               let boundary = "Boundary-\(UUID().uuidString)"
               request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

               // Create multipart form data body
               let httpBody = NSMutableData()

               // Add parameters
               for (key, value) in parameters {
                   httpBody.appendString(convertFormField(named: key, value: "\(value)", using: boundary))
               }
/// additionally if url instead data, change parm data to url and here convert url to data
//        let videoData = try? Data(contentsOf: videoURL)
               // Add image/video
               httpBody.append(convertFileData(fieldName: imgVidParamName,
                                               fileName: uploadDataType == UploadImageType.vid.rawValue ? "video_file\(arc4random_uniform(100)).mov" : "image_file\(arc4random_uniform(100)).jpg",
                                               mimeType: uploadDataType == UploadImageType.vid.rawValue ? "video/quicktime" : "image/jpeg",
                                               fileData: imgVidData, // videoData!
                                               using: boundary))

               // End boundary
               httpBody.appendString("--\(boundary)--")

               request.httpBody = httpBody as Data

               // URL session task
               let session = URLSession.shared
               let task = session.dataTask(with: request) { data, response, error in
                   DispatchQueue.main.async {
                       completion(data, response, error)
                   }
               }
               task.resume()
           }
           private func convertFormField(named name: String, value: String, using boundary: String) -> String {
               return "--\(boundary)\r\n" +
                      "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n" +
                      "\(value)\r\n"
           }
           private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
               let data = NSMutableData()
               data.appendString("--\(boundary)\r\n")
               data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
               data.appendString("Content-Type: \(mimeType)\r\n\r\n")
               data.append(fileData)
               data.appendString("\r\n")
               return data as Data
           }
    
}

enum MethodType: String {
    case get = "GET"
    case post = "POST"
}

enum UploadImageType: String {
    case img = "img"
    case vid = "vid"
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

