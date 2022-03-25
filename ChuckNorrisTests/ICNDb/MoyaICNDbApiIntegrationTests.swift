import Combine
import CombineMoya
import Moya
import XCTest

@testable import ChuckNorris

/// These are API 'integration' tests (in the sense that they perform real network calls)
/// They are included here for developer convenience and not to be run in an automated suite.
/// To execute replace 'skip' with 'test' in the test names
class MoyaICNDbApiIntegrationTests : XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func skip_test_get_retrivesItem() {
        let expectation = expectation(description: "")

        let api = MoyaICNDbApi()
        
        api.get(id: 2)
            .catch({ (error) -> Just<ICNDbResult<ChuckNorrisJoke>> in
                XCTFail()
                return Just(ICNDbResult<ChuckNorrisJoke>(type: "failure", value: ChuckNorrisJoke(id:0, joke: "", categories:[])))
            })
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { result in
                XCTAssertEqual("MacGyver can build an airplane out of gum and paper clips. Chuck Norris can kill him and take it.", result.value.joke)
            })
            
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func skip_random_canDecodeResponse() {
        let expectation = expectation(description: "")

        let api = MoyaICNDbApi()
        
        api.random(firstName: "craig", lastName: nil, exclude: nil)
            .catch({ (error) -> Just<ICNDbResult<ChuckNorrisJoke>> in
                XCTFail()
                return Just(ICNDbResult<ChuckNorrisJoke>(type: "failure", value: ChuckNorrisJoke(id:0, joke: "", categories:[])))
            })
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { result in
                XCTAssertEqual("success", result.type)
            })
            
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func skip_randomWithName_includesName() {
        let expectation = expectation(description: "")
        
        let api = MoyaICNDbApi()
        
        api.random(firstName: "craig", lastName: nil, exclude: nil)
            .catch({ (error) -> Just<ICNDbResult<ChuckNorrisJoke>> in
                XCTFail()
                return Just(ICNDbResult<ChuckNorrisJoke>(type: "failure", value: ChuckNorrisJoke(id:0, joke: "", categories:[])))
            })
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { result in
                XCTAssertEqual("success", result.type)
                // Note: It's possible a joke references walker/texas ranger etc without the name
                XCTAssertTrue(result.value.joke.contains("craig"))
            })
            
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func skip_categories_canDecodeResponse() {
        let expectation = expectation(description: "")

        let api = MoyaICNDbApi()
        
        api.categories()
            .catch({ (error) -> Just<ICNDbResult<[String]>> in
                XCTFail()
                return Just(ICNDbResult<[String]>(type:"failure", value:["category 1"]))
            })
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { result in
                XCTAssertEqual("success", result.type)
                XCTAssertEqual("explicit", result.value.first)
                XCTAssertEqual("nerdy", result.value.last)
            })
            
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
