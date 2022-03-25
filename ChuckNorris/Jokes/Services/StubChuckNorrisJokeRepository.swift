import Combine
import Foundation

class StubChuckNorrisJokeRepository : ChuckNorrisJokeRepository {
    
    let defaultJoke:ChuckNorrisJoke = ChuckNorrisJoke(id: 0, joke: "Kryptonite has been found to contain trace elements of Chuck Norris roundhouse kicks to the face. This is why it is so deadly to Superman.", categories: [])
    let jokes:[ChuckNorrisJoke]
    var lastRequestedIncludeExplicit:Bool?
    
    init() {
        self.jokes = [
            defaultJoke
        ]
    }
    
    init(jokes:[ChuckNorrisJoke]) {
        self.jokes = jokes
    }
    
    func random(firstName:String?, lastName:String?, includeExplicit:Bool) -> AnyPublisher<ChuckNorrisJoke, Error> {
        self.lastRequestedIncludeExplicit = includeExplicit
        
        return Result.Publisher(self.jokes.first ?? defaultJoke)
            .eraseToAnyPublisher()
    }
    
    func randomNumber(number:Int, firstName:String?, lastName:String?, includeExplicit:Bool) -> AnyPublisher<[ChuckNorrisJoke], Error>
    {
        self.lastRequestedIncludeExplicit = includeExplicit
        
        let additionalElementsNeeded = number - self.jokes.count
        var jokes = self.jokes
        let highestId = jokes.map { $0.id }.max() ?? 0
        
        if (additionalElementsNeeded > 0) {
        
            for i in 1...additionalElementsNeeded {
                jokes.append(ChuckNorrisJoke(id: highestId + i, joke:"Stub Joke \(i)", categories: []))
            }
            
        }
        
        return Result.Publisher(jokes).eraseToAnyPublisher()
    }
}
