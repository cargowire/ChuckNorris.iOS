import Combine
import CombineMoya
import Moya
import XCTest

@testable import ChuckNorris

class RandomJokeGeneratorViewModelTests : XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func test_loadWithoutExplicitProfile_usesIncludeExplicitFromProfile() {
        let expectation = expectation(description: "")
        
        let repository = StubChuckNorrisJokeRepository()
        let profileService = InMemoryProfileService()
        profileService.setProfile(value: UserProfile(firstName: "", lastName: "", includeExplicit: false))
        
        let sut = RandomJokeGeneratorViewModel(repository: repository, profileService: profileService)
               
        sut.$joke
            .dropFirst(1) // Ignore initial state of property and wait for set from loadMore
            .sink(receiveCompletion: { completion in
            }, receiveValue: { results in
                XCTAssertFalse(repository.lastRequestedIncludeExplicit!)
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        sut.load()
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_loadWithExplicitProfile_usesIncludeExplicitFromProfile() {
        let expectation = expectation(description: "")
        
        let repository = StubChuckNorrisJokeRepository()
        let profileService = InMemoryProfileService()
        profileService.setProfile(value: UserProfile(firstName: "", lastName: "", includeExplicit: true))
        
        let sut = RandomJokeGeneratorViewModel(repository: repository, profileService: profileService)
               
        sut.$joke
            .dropFirst(1) // Ignore initial state of property and wait for set from loadMore
            .sink(receiveCompletion: { completion in
            }, receiveValue: { results in
                XCTAssertTrue(repository.lastRequestedIncludeExplicit!)
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        sut.load()
               
        waitForExpectations(timeout: 10, handler: nil)
    }
}
