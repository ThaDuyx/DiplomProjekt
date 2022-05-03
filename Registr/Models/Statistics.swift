//
//  Statistics.swift
//  Registr
//
//  Created by Simon Andersen on 18/04/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Statistics: Codable {
    @DocumentID var id: String?
    var illegalMorning: Int
    var illegalAfternoon: Int
    var illnessMorning: Int
    var illnessAfternoon: Int
    var lateMorning: Int
    var lateAfternoon: Int
    var legalMorning: Int
    var legalAfternoon: Int
    var mon: Int
    var tue: Int
    var wed: Int
    var thu: Int
    var fri: Int
}
