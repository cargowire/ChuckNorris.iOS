import Combine
import Foundation

class JokeListViewModel: ObservableObject {
    
    let itemsPerLoad:Int
    @Published var isLoading: Bool = false
    @Published var jokes: [JokeListItemViewModel] = []
    @Published var search: String = ""
    @Published var errorMessageKey: String = ""
    
    private var unfilteredJokes: [JokeListItemViewModel] = []
    private let repository: ChuckNorrisJokeRepository
    private let profileService: ProfileService
    private var subscriptions = Set<AnyCancellable>()
    
    convenience init(repository: ChuckNorrisJokeRepository, profileService: ProfileService) {
        self.init(itemsPerLoad: 5, repository: repository, profileService: profileService)
    }
    
    init(itemsPerLoad: Int, repository: ChuckNorrisJokeRepository, profileService:ProfileService) {
        self.itemsPerLoad = itemsPerLoad
        self.repository = repository
        self.profileService = profileService
        
        $search.sink { searchText in
            self.jokes = self.unfilteredJokes.filter { j in
                return searchText.isEmpty || j.joke.lowercased().range(of: searchText.lowercased()) != nil
            }
        }
        .store(in: &self.subscriptions)
    }
       
    func loadMore() {
        guard !self.isLoading else {
            return
        }
        
        let profile = self.profileService.getProfile()
        self.isLoading = true
        self.errorMessageKey = ""
        
        self.repository.randomNumber(number: self.itemsPerLoad, firstName: profile?.firstName, lastName: profile?.lastName, includeExplicit: profile?.includeExplicit ?? false)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(_):
                    self.errorMessageKey = "joke-load-problem"
                case .finished:()
                }
                self.isLoading = false
            } receiveValue: { [self] jokes in
                self.unfilteredJokes += jokes.map { j in
                    JokeListItemViewModel(joke: j)
                }.filter { newJoke in
                    !self.jokes.contains(where: { j in j.id == newJoke.id })
                }
                
                self.jokes = self.unfilteredJokes.filter { j in
                    return self.search.isEmpty || j.joke.range(of: self.search) != nil
                }
            }
            .store(in: &self.subscriptions)
        }
}
