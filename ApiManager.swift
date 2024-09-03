
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
    
    func request<T: Decodable>(methodType: String,
                               param: [String: Any] = [:],
                               singleMedia: [String: MediaType] = [:],
                               multipleImages: [String: [UIImage]] = [:],
                               dataResponse: T.Type,
                               url: String,
                               token: String = "",
                               completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = methodType
        
        if !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if !singleMedia.isEmpty {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let body = createMultipartBody(parameters: param, singleMedia: singleMedia, multipleImages: multipleImages, boundary: boundary)
            request.httpBody = body
        } else {
            if methodType == MethodType.post {
                let body = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed)
                request.httpBody = body
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
                let json = try JSONDecoder().decode(dataResponse, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func createMultipartBody(parameters: [String: Any], singleMedia: [String: MediaType], multipleImages: [String: [UIImage]] = [:], boundary: String) -> Data {
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        // Append single media
        for (key, mediaType) in singleMedia {
            appendMedia(mediaType, withKey: key, toBody: body, boundary: boundary)
        }
        
        // Append multiple images if contain
        if !multipleImages.isEmpty {
            for (key, mediaArray) in multipleImages {
                for mediaType in mediaArray {
                    if let imageData = mediaType.jpegData(compressionQuality: 0.7) {
                        let fileName = "swift_file\(arc4random_uniform(100)).jpeg"
                        body.append(convertFileData(fieldName: key, fileName: fileName, mimeType: "image/jpeg", fileData: imageData, boundary: boundary))
                    }
                }
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    func appendMedia(_ mediaType: MediaType, withKey key: String, toBody body: NSMutableData, boundary: String) {
        switch mediaType {
        case .image(let image, let fileName):
            if let imageData = image.jpegData(compressionQuality: 0.7) {
                body.append(convertFileData(fieldName: key, fileName: fileName ?? key, mimeType: "image/jpeg", fileData: imageData, boundary: boundary))
            }
        case .video(let videoData, let fileName):
            body.append(convertFileData(fieldName: key, fileName: fileName ?? key, mimeType: "video/mp4", fileData: videoData, boundary: boundary))
        case .none:
            print("")
        }
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
    
    
}

struct MethodType {
    static let get = "GET"
    static let post = "POST"
}

enum MediaType {
    case none
    case image(UIImage, String? = nil)  // UIImage and filename
    case video(Data, String? = nil)     // Video data and filename
}



extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

