import Foundation

extension String {
   
    func wrap(prefix:String?, suffix:String?) -> String? {
      return "\(prefix ?? "")\(self)\(suffix ?? "")"
    }
    
}
