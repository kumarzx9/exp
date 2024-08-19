
import UIKit


//--------------------------------------------

//MARK: Private Methods
extension ApiVc {
    
    // url session post(with common get and post method)
    private func foodTruckApi(parms: [String: Any]) {
        anonymousFoodTruckListVM.fetchData4(parms: parms) { ress in
            switch ress{
            case .success(let res):
                debugPrint(res)
                DispatchQueue.main.async {
                    if res.status == true{
                        print("sucess, method4")
                    }else{
                    }
                }
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                }
            }
        }
    }
    
    // Alamofire post
    private func foodTruckApiAlamofire(parms: [String: Any]) {
        anonymousFoodTruckListVM.fetchData2(parms: parms) { response in
            switch response {
            case .success(let res):
                debugPrint(res)
                    if res.status == true{
                        print("sucess, method2")
                    }else{
                    }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // MARK: create truck alamofire chow
    private func createTruck() {
        let param = ["cuisine_id": "45","name":"demno","description":"from demo","website_url":"","address":"Alaska, USA","latitude":"64.2008413","longitude":"-149.4936733"] as [String : Any]
        let imageArray = [UIImage(named: "Group 490")!, UIImage(named: "Group 491")!, UIImage(named: "Group 492")!]
        print(param)
        multipartTruckVM.createTruck(parameters: param, profileImage1: UIImage(named: "rose"), profileImgName1: "map_logo", profileImage2: UIImage(named: "flower"), profileImgName2: "truck_logo", imagesArray: imageArray) { result, error in
            if let result = result {
                print("Success: \(result)")
                DispatchQueue.main.async {
                    if result.status ?? false {
                        print("sucess, method5 multipart")
                    }else{
                    }
                }
            }else if let error = error {
                print("Error: \(error)")
            }
        }
        
        
        
        
    }
    
    private func singleVideoUpload() {
        
        // MARK: alamofire single video upload golf
        let videoURL = Bundle.main.url(forResource: "samplevid", withExtension: "mov")
        //let videoData = try Data(contentsOf: videoURL!) // in do catch
        multipartTruckVM.singleVideoUpload(parameters: [:], videoURL: videoURL!, videoParamName: "video") { result, error in
            if let result = result {
                
                print("Success: \(result)")
                DispatchQueue.main.async {
                    if result.status ?? false {
                        print("sucess, method5 multipart")
                    }else{
                    }
                }
            } else if let error = error {
                print("Error: \(error)")
            }
            
            
            
            
            // MARK: url session single video upload golf
            var imgVidData: Data?
            // url of internal video added
            let videoURL = Bundle.main.url(forResource: "samplevid", withExtension: "mov")
            do {
                imgVidData = try Data(contentsOf: videoURL!) // in do catch
            } catch {
                print("error converting to data")
            }
            
            
            /*
             MultipartTruckVM.shared.imgVidUpload(parameters: [:], uploadDataType: UploadImageType.vid.rawValue, imgVidData: imgVidData ?? Data(), imgVidParamName: "video") { result, error in
             if let result = result {
             print("Success: \(result)")
             DispatchQueue.main.async {
             if result.status ?? false {
             print("sucess, method5 multipart")
             print(result)
             }else{
             print(result.error ?? "")
             }
             }
             } else if let error = error {
             print("Error: \(error)")
             }
             */
            
        }
    }
}
