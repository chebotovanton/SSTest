import Alamofire

protocol SearchPerformerDelegate: class {
    func didStartSearch()
    func didReceiveData(_ newItiniraries: [Itinerary])
    func didFail(with error: Error?)
    func didFinishSearch(finished: Bool)
}

class SearchPerformer {
    weak var delegate: SearchPerformerDelegate?

    private let kBaseUrl = "http://partners.api.skyscanner.net/apiservices/"
    private let kCreateSessionUrl = "pricing/v1.0"
    private let kApiKey = "ss630745725358065467897349852985"

    func startSearch(_ searchInfo: SearchInfo) {
        addStatusBarActivityIndicator()
        let parameters = parametersDict(from: searchInfo)
        Alamofire.request(kBaseUrl + kCreateSessionUrl, method: .post, parameters: parameters).responseJSON { [weak self] (response) in
            self?.delegate?.didStartSearch()
            self?.handleSessionCreationResponse(response)
        }
    }

    private func handleSessionCreationResponse(_ response: DataResponse<Any>) {
        if let pollingLocation = response.response?.allHeaderFields["Location"] as? String {
            let parameters: [String : Any] = ["apiKey" : kApiKey,
                                              "pageIndex" : 0,
                                              "pageSize" : 1]
            pollResults(pollingLocation: pollingLocation, parameters: parameters)
        }
    }

    private func pollResults(pollingLocation: String, parameters: Dictionary<String, Any>) {
        let headers = ["Content-Type" : "application/json"]
        Alamofire.request(pollingLocation, parameters:parameters, headers: headers).responseObject() { [weak self] (response: DataResponse<PollResponse>) in
            guard let pollResponse = response.result.value else {
                if let httpCode = response.response?.statusCode, httpCode == 304 {
                    self?.pollResults(pollingLocation: pollingLocation, parameters: parameters)
                } else {
                    self?.removeStatusBarActivityIndicator()
                    self?.delegate?.didFail(with: nil)
                }
                return
            }

            //move to another thread
            let (itineraries, shouldContinueSearch) = ResultsParser.parseResults(pollResponse)
            self?.delegate?.didReceiveData(itineraries)
            if shouldContinueSearch {
                // don't do it immediatelly?
                self?.pollResults(pollingLocation: pollingLocation, parameters: parameters)
            } else {
                self?.removeStatusBarActivityIndicator()
                self?.delegate?.didFinishSearch(finished: true)
            }
        }
    }

    private func addStatusBarActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    private func removeStatusBarActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    //move to tested params converter
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
                      "apiKey" : kApiKey]
    }
}
