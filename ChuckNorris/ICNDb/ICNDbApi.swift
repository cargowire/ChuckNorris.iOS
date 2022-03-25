import Combine
import Foundation

protocol ICNDbApi {
    
    func get(id:Int) -> AnyPublisher<ICNDbResult<ChuckNorrisJoke>, Error>
    
    func random(firstName:String?, lastName:String?, exclude:[String]?) -> AnyPublisher<ICNDbResult<ChuckNorrisJoke>, Error>
    
    func randomNumber(number:Int, firstName:String?, lastName:String?, exclude:[String]?) -> AnyPublisher<ICNDbResult<[ChuckNorrisJoke]>, Error>

    func categories() -> AnyPublisher<ICNDbResult<[String]>, Error>
}
