//
//  RegistrUnitTests.swift
//  RegistrUnitTests
//
//  Created by Simon Andersen on 07/05/2022.
//

import XCTest
import FirebaseFirestore
@testable import Registr

class RegistrUnitTests: XCTestCase {
    private let statisticsManager = StatisticsManager()
    private let db = Firestore.firestore()

    func testIncrementAndDecrementMethod() throws {
        let statManager = StatisticsManager()
        statManager.updateClassStatistics(oldValue: "For sent", newValue: "Ulovligt")
        XCTAssert(statManager.illegalCounter == Int64(1) &&
                  statManager.illnessCounter == Int64(0) &&
                  statManager.legalCounter == Int64(0) &&
                  statManager.lateCounter == Int64(-1))
    }
    
    func testOnlyDecrement() throws {
        let statManager = StatisticsManager()
        statManager.updateClassStatistics(oldValue: "For sent", newValue: "")
        XCTAssert(statManager.illegalCounter == Int64(0) &&
                  statManager.illnessCounter == Int64(0) &&
                  statManager.legalCounter == Int64(0) &&
                  statManager.lateCounter == Int64(-1))
    }
    
    func testOnlyIncrement() throws {
        let statManager = StatisticsManager()
        statManager.updateClassStatistics(oldValue: "", newValue: "For sent")
        XCTAssert(statManager.illegalCounter == Int64(0) &&
                  statManager.illnessCounter == Int64(0) &&
                  statManager.legalCounter == Int64(0) &&
                  statManager.lateCounter == Int64(1))
    }
    
    func testResetCounters() throws {
        let statManager = StatisticsManager()
        statManager.updateClassStatistics(oldValue: "", newValue: "For sent")
        statManager.updateClassStatistics(oldValue: "Ulovligt", newValue: "Sygdom")
        statManager.updateClassStatistics(oldValue: "", newValue: "Sygdom")
        statManager.updateClassStatistics(oldValue: "", newValue: "For sent")
        statManager.updateClassStatistics(oldValue: "", newValue: "For sent")
        statManager.updateClassStatistics(oldValue: "", newValue: "Sygdom")
        statManager.updateClassStatistics(oldValue: "For sent", newValue: "Ulovligt")
        statManager.updateClassStatistics(oldValue: "Ulovligt", newValue: "Ulovligt")
        statManager.resetStatCounters()
        
        XCTAssert(statManager.illegalCounter == Int64(0) &&
                  statManager.illnessCounter == Int64(0) &&
                  statManager.legalCounter == Int64(0) &&
                  statManager.lateCounter == Int64(0))
    }
    
    func testDecrementer() throws {
        let statManager = StatisticsManager()
        statManager.decrementCounters(value: "Sygdom")
        
        XCTAssert(statManager.illnessCounter == Int64(-1))
    }
    
    func testIncrementer() throws {
        let statManager = StatisticsManager()
        statManager.incrementCounters(value: "Sygdom")
        
        XCTAssert(statManager.illnessCounter == Int64(1))
    }

    func testFetchStudentsPerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            db
                .collection("fb_schools_path".localize)
                .document("EXvXPS4HuVnxu7LhZRPt")
                .collection("fb_classes_path".localize)
                .document("ZjHicqkeR0aERu6ZY87v")
                .collection("fb_students_path".localize)
                .getDocuments { querySnapshot, err in
                    if let err = err {
                        ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .registrationManagerInitError)
                    } else {
                        for document in querySnapshot!.documents {
                            let studentID = document.documentID
                            self.db.collection("fb_students_path".localize)
                                .document(studentID)
                                .getDocument { studentDoc, error in
                                    if let data = studentDoc {
                                        do {
                                            if let student = try data.data(as: Student.self) {
                                                print(student)
                                                
                                            }
                                        }
                                        catch {
                                            ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .registrationManagerInitError)
                                        }
                                    }
                                }
                        }
                    }
                }
        }
    }
}
