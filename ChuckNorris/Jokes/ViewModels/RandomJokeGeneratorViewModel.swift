import Combine
import Foundation
import SwiftUI

class RandomJokeGeneratorViewModel : ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var joke: JokeListItemViewModel?
    @Published var errorMessageKey: String = ""
    
    private let repository: ChuckNorrisJokeRepository
    private let profileService:ProfileService
    private var subscriptions = Set<AnyCancellable>()
    
    init(repository: ChuckNorrisJokeRepository, profileService:ProfileService) {
        self.repository = repository
        self.profileService = profileService
    }
       
    func load() {
        guard !self.isLoading else {
            return
        }
        
        let profile = self.profileService.getProfile()
        self.isLoading = true
        self.errorMessageKey = ""
        
        self.repository.random(firstName: profile?.firstName, lastName: profile?.lastName, includeExplicit: profile?.includeExplicit ?? false)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(_):
                    self.errorMessageKey = "joke-load-problem"
                    self.joke = nil
                case .finished:()
                }
                self.isLoading = false
            } receiveValue: { [self] joke in
                self.joke = JokeListItemViewModel(joke: joke)
            }
            .store(in: &self.subscriptions)
        }
}
