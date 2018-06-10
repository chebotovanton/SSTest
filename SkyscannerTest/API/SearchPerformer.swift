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

    var searchInfo: SearchInfo?

    private let kBaseUrl = "http://partners.api.skyscanner.net/apiservices/"
    private let kCreateSessionUrl = "pricing/v1.0"
    private let kApiKey = ApiKeyStorage.loadApiKey()

    private var pollingLocation: String?
    private let kPageSize = 20
    private var lastPageIndex = 0

    private (set) var state: SearchPerformerState = .unknown

    func startSearch(_ searchInfo: SearchInfo) {
        self.searchInfo = searchInfo
        addStatusBarActivityIndicator()
        let parameters = ParametersConverter.searchSessionInitParameters(searchInfo: searchInfo, apiKey: kApiKey)
        Alamofire.request(kBaseUrl + kCreateSessionUrl, method: .post, parameters: parameters).responseJSON { [weak self] (response) in
            self?.delegate?.didStartSearch()
            self?.handleSessionCreationResponse(response)
        }
        state = .loading
    }

    private func handleSessionCreationResponse(_ response: DataResponse<Any>) {
        if let pollingLocation = response.response?.allHeaderFields["Location"] as? String {
            self.pollingLocation = pollingLocation
            let parameters = ParametersConverter.pollParameters(apiKey: kApiKey, pageIndex: 0, pageSize: kPageSize)
            pollResults(parameters: parameters)
        }
    }

    private func pollResults(parameters: [String: Any]) {
        guard let pollingLocation = pollingLocation else {
            handleErrorWithoutRetry()
            return
        }
        Alamofire.request(pollingLocation, parameters:parameters).responseObject { [weak self] (response: DataResponse<PollResponse>) in
            guard let pollResponse = response.result.value else {
                self?.handleLoadingError(statusCode: response.response?.statusCode, pollParameters: parameters)
                return
            }

            DispatchQueue.global(qos: .background).sync {
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
        guard state == .finished, let pollingLocation = pollingLocation else { return }
        let parameters = ParametersConverter.pollParameters(apiKey: kApiKey, pageIndex: 0, pageSize: kPageSize)
        state = .loading
        Alamofire.request(pollingLocation, parameters:parameters).responseObject { [weak self] (response: DataResponse<PollResponse>) in
            guard let pollResponse = response.result.value else {
                self?.handleErrorWithoutRetry()
                return
            }

            self?.lastPageIndex += 1
            DispatchQueue.global(qos: .background).sync {
                let (itineraries, _) = ResultsParser.parseResults(pollResponse)
                DispatchQueue.main.async {
                    self?.delegate?.didReceiveNextPage(itineraries)
                    self?.removeStatusBarActivityIndicator()
                    self?.state = .finished
                }
            }
        }
    }

    func stopLoading() {
        removeStatusBarActivityIndicator()

        SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach { $0.cancel() }
        }
    }

    private func handleLoadingError(statusCode: Int?, pollParameters: [String: Any]) {
        if let httpCode = statusCode, httpCode == 304 {
            pollResults(parameters: pollParameters)
        } else {
            state = .error
            removeStatusBarActivityIndicator()
            delegate?.didFail(with: nil)
        }
    }

    private func handleErrorWithoutRetry() {
        state = .finished
        removeStatusBarActivityIndicator()
        delegate?.didFail(with: nil)
    }

    // move somewhere
    private func addStatusBarActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    private func removeStatusBarActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
