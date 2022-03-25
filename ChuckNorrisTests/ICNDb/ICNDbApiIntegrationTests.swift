import Combine
import CombineMoya
import Moya
import XCTest

@testable import ChuckNorris

/// These are API 'integration' tests (in the sense that they perform real network calls)
/// They are included here for developer convenience and not to be run in an automated suite.
/// To execute replace 'skip' with 'test' in the test names
class ICNDbApiIntegrationTests : XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func skip_random_canDecodeResponse() {
        let expectation = expectation(description: "")
        let provider = MoyaProvider<ICNDbEndpoints>()
        
        provider.requestPublisher(
            .random(
                firstName:"craig",
                lastName:nil,
                limitTo:nil,
                exclude:nil
            ))
            .catch({ (error) -> Just<Response> in
                XCTFail()
                return Just(Response(statusCode:0, data: Data()))
            })
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { response in
                do {
                    let decoder = JSONDecoder()
                    let jokeResponse = try decoder.decode(
                        ICNDbResult<ChuckNorrisJoke>.self,
                        from: response.data
                    )
                    
                    XCTAssertEqual("success", jokeResponse.type)
                } catch _ {
                    XCTFail()
                }
            })
            
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func skip_randomWithName_includesName() {
        let expectation = expectation(description: "")
        let provider = MoyaProvider<ICNDbEndpoints>()
        
        provider.requestPublisher(
            .random(
                firstName:"craig",
                lastName:nil,
                limitTo:nil,
                exclude: nil
            ))
            .catch({ (error) -> Just<Response> in
                XCTFail()
                return Just(Response(statusCode:0, data: Data()))
            })
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { response in
                do {
                    let decoder = JSONDecoder()
                    let jokeResponse = try decoder.decode(
                        ICNDbResult<ChuckNorrisJoke>.self,
                        from: response.data
                    )
                    
                    XCTAssertEqual("success", jokeResponse.type)
                    // Note: It's possible a joke references walker/texas ranger etc without the name 
                    XCTAssertTrue(jokeResponse.value.joke.contains("craig"))
                } catch _ {
                    XCTFail()
                }
            })
            
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
