import Combine
import CombineMoya
import Moya
import XCTest

@testable import ChuckNorris

class JokeListViewModel_loadMoreTests : XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func test_loadMore_publishesJokeViewModelsFromRepository() {
        let expectation = expectation(description: "")
        
        let itemsPerLoad = 10
        let repository = StubChuckNorrisJokeRepository()
        let profileService = InMemoryProfileService()
        let sut = JokeListViewModel(itemsPerLoad: itemsPerLoad, repository: repository, profileService: profileService)
               
        sut.$jokes
            .dropFirst(1) // Ignore initial state of property and wait for set from loadMore
            .sink(receiveCompletion: { completion in
            }, receiveValue: { results in
                XCTAssertEqual(itemsPerLoad, results.count)
                expectation.fulfill()
            })
            
            .store(in: &self.cancellables)
        
        sut.loadMore()
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

class JokeListViewModel_searchTests : XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func test_searchCoversBothItems_bothJokesPublished() {
        let expectation = expectation(description: "")
        
        let itemsPerLoad = 2
        let repository = StubChuckNorrisJokeRepository(jokes:
                                                        [
                                                            ChuckNorrisJoke(id: 0, joke: "test phrase", categories: []),
                                                            ChuckNorrisJoke(id: 1, joke: "other phrase", categories: []),
                                                        ])
        let profileService = InMemoryProfileService()
        let sut = JokeListViewModel(itemsPerLoad: itemsPerLoad, repository: repository, profileService: profileService)
               
        sut.$jokes
            .dropFirst(2) // Ignore initial state of property and first set of search and wait for set from loadMore
            .sink(receiveCompletion: { completion in
            }, receiveValue: { results in
                XCTAssertEqual(itemsPerLoad, results.count)
                expectation.fulfill()
            })
            
            .store(in: &self.cancellables)

        sut.search = "phrase"
        
        sut.loadMore()
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_searchCoversFirstItem_firstJokesPublished() {
        let expectation = expectation(description: "")
        
        let itemsPerLoad = 2
        let repository = StubChuckNorrisJokeRepository(jokes:
                                                        [
                                                            ChuckNorrisJoke(id: 0, joke: "test phrase", categories: []),
                                                            ChuckNorrisJoke(id: 1, joke: "other phrase", categories: []),
                                                        ])
        let profileService = InMemoryProfileService()
        let sut = JokeListViewModel(itemsPerLoad: itemsPerLoad, repository: repository, profileService: profileService)
               
        sut.$jokes
            .dropFirst(2) // Ignore initial state of property and first set of search and wait for set from loadMore
            .sink(receiveCompletion: { completion in
            }, receiveValue: { results in
                XCTAssertEqual(1, results.count)
                XCTAssertEqual(0, results.first!.id)
                expectation.fulfill()
            })
            
            .store(in: &self.cancellables)

        sut.search = "test"
        
        sut.loadMore()
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_searchCoversSecondItem_secondJokesPublished() {
        let expectation = expectation(description: "")
        
        let itemsPerLoad = 2
        let repository = StubChuckNorrisJokeRepository(jokes:
                                                        [
                                                            ChuckNorrisJoke(id: 0, joke: "test phrase", categories: []),
                                                            ChuckNorrisJoke(id: 1, joke: "other phrase", categories: []),
                                                        ])
        let profileService = InMemoryProfileService()
        let sut = JokeListViewModel(itemsPerLoad: itemsPerLoad, repository: repository, profileService: profileService)
               
        sut.$jokes
            .dropFirst(2) // Ignore initial state of property and first set of search and wait for set from loadMore
            .sink(receiveCompletion: { completion in
            }, receiveValue: { results in
                XCTAssertEqual(1, results.count)
                XCTAssertEqual(1, results.first!.id)
                expectation.fulfill()
            })
            
            .store(in: &self.cancellables)

        sut.search = "other"
        
        sut.loadMore()
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_searchAppliedToExistingJokeSet_publishesFilteredJokes() {
        let expectation = expectation(description: "")
        
        let itemsPerLoad = 2
        let repository = StubChuckNorrisJokeRepository(jokes:
                                                        [
                                                            ChuckNorrisJoke(id: 0, joke: "test phrase", categories: []),
                                                            ChuckNorrisJoke(id: 1, joke: "other phrase", categories: []),
                                                            ChuckNorrisJoke(id: 2, joke: "hello phrase", categories: [])
                                                        ])
        let profileService = InMemoryProfileService()
        let sut = JokeListViewModel(itemsPerLoad: itemsPerLoad, repository: repository, profileService: profileService)
               
        var jokeChangeIteration = 0
        
        sut.$jokes
            .dropFirst(1) // Ignore initial state of property
            .sink(receiveCompletion: { completion in
            }, receiveValue: { results in
                jokeChangeIteration += 1
                
                if(jokeChangeIteration == 1) {
                    // Set search after initial load
                    sut.search = "hello"
                } else {
                    // Identify that search changed items
                    XCTAssertEqual(1, results.count)
                    XCTAssertEqual(2, results.first!.id)
                    expectation.fulfill()
                }
            })
            
            .store(in: &self.cancellables)
        
        sut.loadMore()
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
