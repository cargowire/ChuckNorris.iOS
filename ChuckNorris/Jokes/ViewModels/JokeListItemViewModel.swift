import Combine
import Foundation

class JokeListItemViewModel: ObservableObject, Identifiable, Equatable {
    
    @Published var id: Int
    @Published var joke: String
    
    init(joke: ChuckNorrisJoke) {
        self.id = joke.id
        self.joke = String(htmlEncodedString: joke.joke) ?? ""
    }
    
    static func ==(lhs: JokeListItemViewModel, rhs: JokeListItemViewModel) -> Bool {
        return  lhs.id == rhs.id
    }
}
