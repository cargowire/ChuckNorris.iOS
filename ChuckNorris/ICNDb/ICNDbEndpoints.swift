import Foundation
import Moya

/// Defines the available endpoints on the 'Internet Chuck Norris Database' API
enum ICNDbEndpoints {
    
    case get(
        id:Int
    )
    
    case random(
        firstName:String?,
        lastName:String?,
        limitTo:[String]?,
        exclude:[String]?
    )
    
    case randomNumber(
        number:Int,
        firstName:String?,
        lastName:String?,
        limitTo:[String]?,
        exclude:[String]?
    )
    
    case categories
    
    case count(
        count:Int
    )
}

extension ICNDbEndpoints : TargetType {
    
    var baseURL: URL { URL(string: "https://api.icndb.com")! }
    var path: String {
         switch self {
         case .get(let id):
             return "/jokes/\(id)"
         case .random(_, _, _,  _):
             return "/jokes/random"
         case .randomNumber(let number, _, _, _, _):
             return "/jokes/random/\(number)"
         case .categories:
             return "/categories"
         case .count:
             return "/jokes/count"
         }
     }
    
     var method: Moya.Method {
         switch self {
         case .get, .random, .randomNumber, .categories, .count:
             return .get
         }
     }
    
     var task: Task {
         switch self {
         case .get, .categories, .count:
             return .requestPlain
         case .random(let firstName, let lastName, let limitTo, let exclude), .randomNumber(_, let firstName, let lastName, let limitTo, let exclude):
             
             var params: [String:Any] = [:]
             if let firstName = firstName {
                 params["firstName"] = firstName
             }

             if let lastName = lastName {
                 params["lastName"] = lastName
             }
         
             if let limitTo = limitTo {
                 params["limitTo"] = limitTo.joined(separator: ",").wrap(prefix:"[", suffix: "]")
             }
             
             if let exclude = exclude {
                 params["exclude"] = exclude.joined(separator: ",").wrap(prefix:"[", suffix: "]")
             }
         
             return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
         }
     }
    
     var sampleData: Data {
         switch self {
         case .get(let id):
             return "{\"type\": \"success\",\"value\": { \"id\": \(id), \"joke\": \"Chuck Norris did in fact, build Rome in a day.\",\"categories\": [] } }".utf8Encoded
         case .random(let firstName, let lastName, _, _):
             return "{\"type\": \"success\",\"value\": { \"id\": 159, \"joke\": \"\(firstName ?? "Chuck") \(lastName ?? "Norris") did in fact, build Rome in a day.\",\"categories\": [] } }".utf8Encoded
         case .randomNumber(_, let firstName, let lastName, _, _):
             return "{\"type\": \"success\", \"value\": [ { \"id\": 413, \"joke\": \"Those aren't credits that roll after Walker Texas Ranger. It is actually a list of fatalities that occurred during the making of the episode.\",\"categories\": [] }, { \"id\": 13,\"joke\": \"\(firstName ?? "Chuck") \(lastName ?? "Norris") once challenged Lance Armstrong in a &quot;Who has more testicles?&quot; contest. \(firstName ?? "Chuck") \(lastName ?? "Norris") won by 5.\", \"categories\": [\"explicit\"] } ] }".utf8Encoded
         case .categories:
             return "{\"type\": \"success\", \"value\": [\"explicit\",\"nerdy\"] }".utf8Encoded
         case .count:
             return "{\"type\": \"success\", \"value\": 574 }".utf8Encoded
         }
     }
    
     var headers: [String: String]? {
         return ["Content-type": "application/json"]
     }
}
