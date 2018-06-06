import Alamofire

protocol SearchPerformerDelegate: class {
    func didReceiveData()
    func didFail(with error: Error)
    func didFinishSearch()
}

class SearchPerformer {
    weak var delegate: SearchPerformerDelegate?

    private let kBaseUrl = "http://partners.api.skyscanner.net/apiservices/"
    private let kCreateSessionUrl = "pricing/v1.0"

    func startSearch(_ searchInfo: SearchInfo) {
        let parameters = parametersDict(from: searchInfo)
        Alamofire.request(kBaseUrl + kCreateSessionUrl, method: .post, parameters: parameters).responseJSON { response in
            NSLog(response.debugDescription)
        }
    }

    private func parametersDict(from searchInfo: SearchInfo) -> [String : String] {
        return ["cabinclass" : "Economy",
                      "country" : "UK",
                      "currency" : "GBP",
                      "locale" : "en-GB",
                      "locationSchema" : searchInfo.locationSchema,
                      "originplace" : searchInfo.originIata,
                      "destinationplace" : searchInfo.destinationIata,
                      "outbounddate" : searchInfo.outboundDate,
                      "inbounddate" : searchInfo.inboundDate,
                      "adults" : "1",
                      "children" : "0",
                      "infants" : "0",
                      "apikey" : searchInfo.apiKey]
    }
}
