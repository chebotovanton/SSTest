import Alamofire

protocol SearchPerformerDelegate: class {
    func didStartSearch()
    func didReceiveFirstPage(_ itiniraries: [Itinerary])
    func didReceiveNextPage(_ newItiniraries: [Itinerary])
    func didFail(with error: Error?)
}

enum SearchPerformerState {
    case unknown
    case loading
    case finished
    case error
}

class SearchPerformer {
    weak var delegate: SearchPerformerDelegate?

    private let kBaseUrl = "http://partners.api.skyscanner.net/apiservices/"
    private let kCreateSessionUrl = "pricing/v1.0"
    private let kApiKey = "ss630745725358065467897349852985"

    private var pollingLocation: String?
    private let kPageSize = 10
    private var lastPageIndex = 0

    private (set) var state: SearchPerformerState = .unknown

    func startSearch(_ searchInfo: SearchInfo) {
        addStatusBarActivityIndicator()
        let parameters = parametersDict(from: searchInfo)
        Alamofire.request(kBaseUrl + kCreateSessionUrl, method: .post, parameters: parameters).responseJSON { [weak self] (response) in
            self?.delegate?.didStartSearch()
            self?.handleSessionCreationResponse(response)
        }
        state = .loading
    }

    private func handleSessionCreationResponse(_ response: DataResponse<Any>) {
        if let pollingLocation = response.response?.allHeaderFields["Location"] as? String {
            self.pollingLocation = pollingLocation
            let parameters: [String : Any] = ["apiKey" : kApiKey,
                                              "pageIndex" : 0,
                                              "pageSize" : kPageSize]
            pollResults(parameters: parameters)
        }
    }

    private func pollResults(parameters: Dictionary<String, Any>) {
        guard let pollingLocation = pollingLocation else { return }
        Alamofire.request(pollingLocation, parameters:parameters).responseObject() { [weak self] (response: DataResponse<PollResponse>) in
            guard let pollResponse = response.result.value else {
                self?.handleLoadingError(statusCode: response.response?.statusCode)
                return
            }

            DispatchQueue.global(qos: .userInitiated).sync {
                let (itineraries, shouldContinueSearch) = ResultsParser.parseResults(pollResponse)
                DispatchQueue.main.async {
                    self?.delegate?.didReceiveFirstPage(itineraries)
                    if shouldContinueSearch {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self?.pollResults(parameters: parameters)
                        }
                    } else {
                        self?.removeStatusBarActivityIndicator()
                        self?.state = .finished
                    }
                }
            }
        }
    }

    func pollNextPage() {
        //code duplication?
        guard state == .finished, let pollingLocation = pollingLocation else { return }
        let parameters: [String : Any] = ["apiKey" : kApiKey,
                      "pageIndex" : lastPageIndex,
                      "pageSize" : kPageSize]
        state = .loading
        Alamofire.request(pollingLocation, parameters:parameters).responseObject() { [weak self] (response: DataResponse<PollResponse>) in
            guard let pollResponse = response.result.value else {
                self?.handleLoadingError(statusCode: response.response?.statusCode)
                return
            }

            self?.lastPageIndex += 1
            DispatchQueue.global(qos: .userInitiated).sync {
                let (itineraries, _) = ResultsParser.parseResults(pollResponse)
                DispatchQueue.main.async {
                    self?.delegate?.didReceiveNextPage(itineraries)
                    self?.removeStatusBarActivityIndicator()
                    self?.state = .finished
                }
            }
        }
    }

    private func handleLoadingError(statusCode: Int?) {
        if let httpCode = statusCode, httpCode == 304 {
            state = .finished
        } else {
            state = .error
            removeStatusBarActivityIndicator()
            delegate?.didFail(with: nil)
        }
    }

    // move somewhere
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
