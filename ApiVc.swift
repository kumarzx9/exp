//--------------------------------------------

//MARK: Private Methods
private extension ApiVc {
    
    // url session post(with common get and post method)
    func foodTruckApi(parms: [String: Any]) {
        anonymousFoodTruckListVM.fetchRequest(parm: parms) { response in
            switch response {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Alamofire post
    func foodTruckApiAlamofire(parms: [String: Any]) {
        anonymousFoodTruckListVM.fetchData2(parms: parms) { response in
            switch response {
            case .success(let res):
                debugPrint(res)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // MARK: create truck url session chow
    func createTruck() {
        let param = ["cuisine_id": "45","name":"demno","description":"from demo","website_url":"","address":"Alaska, USA","latitude":"64.2008413","longitude":"-149.4936733"] as [String : Any]
        let imageArray = [UIImage(named: "Group 490")!, UIImage(named: "Group 491")!, UIImage(named: "Group 492")!]
        let mapLogoImage = UIImage(named: "rose")!
        let truckLogoImage = UIImage(named: "flower")!
        
        multipartTruckVM.mediaUpload(parms: param, singleMedia: ["map_logo": .image(mapLogoImage), "truck_logo": .image(truckLogoImage)], multipleImages: ["images[]": imageArray]) { response in
            switch response {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: url Session single video upload golf
    func singleVideoUpload() {
        
        let videoURL = Bundle.main.url(forResource: "samplevid", withExtension: "mov")
        guard let imgVidData = try? Data(contentsOf: videoURL!) else {return}
        
        multipartTruckVM.videoUpload(singleMedia: ["video": .video(imgVidData)]) { response in
            switch response {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
