import Foundation
import CoreData

extension ProfileEntity {

    var isAuthorized: Bool {
        return token?.isEmpty == false
            && sandboxToken?.isEmpty == false
    }
}
