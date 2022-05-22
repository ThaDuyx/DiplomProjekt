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
    private let statisticsViewModel = StatisticsViewModel()
    private let db = Firestore.firestore()
    
    //MARK: - Statistic unit tests
    func testIncrementAndDecrementMethod() throws {
        let statViewModel = StatisticsViewModel()
        statViewModel.updateClassStatistics(oldValue: "For sent", newValue: "Ulovligt")
        XCTAssert(statViewModel.illegalCounter == Int64(1) &&
                  statViewModel.illnessCounter == Int64(0) &&
                  statViewModel.legalCounter == Int64(0) &&
                  statViewModel.lateCounter == Int64(-1))
    }
    
    func testOnlyDecrement() throws {
        let statViewModel = StatisticsViewModel()
        statViewModel.updateClassStatistics(oldValue: "For sent", newValue: "")
        XCTAssert(statViewModel.illegalCounter == Int64(0) &&
                  statViewModel.illnessCounter == Int64(0) &&
                  statViewModel.legalCounter == Int64(0) &&
                  statViewModel.lateCounter == Int64(-1))
    }
    
    func testOnlyIncrement() throws {
        let statViewModel = StatisticsViewModel()
        statViewModel.updateClassStatistics(oldValue: "", newValue: "For sent")
        XCTAssert(statViewModel.illegalCounter == Int64(0) &&
                  statViewModel.illnessCounter == Int64(0) &&
                  statViewModel.legalCounter == Int64(0) &&
                  statViewModel.lateCounter == Int64(1))
    }
    
    func testResetCounters() throws {
        let statViewModel = StatisticsViewModel()
        statViewModel.updateClassStatistics(oldValue: "", newValue: "For sent")
        statViewModel.updateClassStatistics(oldValue: "Ulovligt", newValue: "Sygdom")
        statViewModel.updateClassStatistics(oldValue: "", newValue: "Sygdom")
        statViewModel.updateClassStatistics(oldValue: "", newValue: "For sent")
        statViewModel.updateClassStatistics(oldValue: "", newValue: "For sent")
        statViewModel.updateClassStatistics(oldValue: "", newValue: "Sygdom")
        statViewModel.updateClassStatistics(oldValue: "For sent", newValue: "Ulovligt")
        statViewModel.updateClassStatistics(oldValue: "Ulovligt", newValue: "Ulovligt")
        statViewModel.resetStatCounters()
        
        XCTAssert(statViewModel.illegalCounter == Int64(0) &&
                  statViewModel.illnessCounter == Int64(0) &&
                  statViewModel.legalCounter == Int64(0) &&
                  statViewModel.lateCounter == Int64(0))
    }
    
    func testDecrementer() throws {
        let statViewModel = StatisticsViewModel()
        statViewModel.decrementCounters(value: "Sygdom")
        
        XCTAssert(statViewModel.illnessCounter == Int64(-1))
    }
    
    func testIncrementer() throws {
        let statViewModel = StatisticsViewModel()
        statViewModel.incrementCounters(value: "Sygdom")
        
        XCTAssert(statViewModel.illnessCounter == Int64(1))
    }
    
    //MARK: - Date conversions unit tests
    func testSelectedDateFormatted() throws {
        var dateComponents = DateComponents(); dateComponents.year = 2022; dateComponents.month = 1; dateComponents.day = 1
        let userCalendar = Calendar(identifier: .gregorian)
        if let date = userCalendar.date(from: dateComponents) {
            let selectedDateFormatted = date.selectedDateFormatted
            XCTAssertEqual(selectedDateFormatted, "01-01-2022")
        }
    }
    
    func testDayOfDate() throws {
        var dateComponents = DateComponents(); dateComponents.year = 2022; dateComponents.month = 1; dateComponents.day = 1
        let userCalendar = Calendar(identifier: .gregorian)
        if let date = userCalendar.date(from: dateComponents) {
            let dayOfDate = date.dayOfDate
            XCTAssertEqual(dayOfDate, "Lør")
        }
    }

    func testFormatSpecificDate() throws {
        var dateComponents = DateComponents(); dateComponents.year = 2022; dateComponents.month = 1; dateComponents.day = 1
        let userCalendar = Calendar(identifier: .gregorian)
        if let date = userCalendar.date(from: dateComponents) {
            let formattedSpecifcDate = date.formatSpecificDate(date: date)
            XCTAssertEqual(formattedSpecifcDate, "01-01-2022")
        }
    }
    
    func testComingDays() throws {
        let date = Date()
        let comingDays = date.comingDays(days: 7)
        XCTAssertEqual(comingDays.count, 7)
    }
    
    func testPreviousDays() throws {
        let date = Date()
        let comingDays = date.previousDays(days: 7)
        XCTAssertEqual(comingDays.count, 7)
    }
    
    func testDates() throws {
        var dateComponents = DateComponents(); dateComponents.year = 2022; dateComponents.month = 1; dateComponents.day = 1
        var dateComponents2 = DateComponents(); dateComponents2.year = 2022; dateComponents2.month = 1; dateComponents2.day = 7
        let userCalendar = Calendar(identifier: .gregorian)
        if let date = userCalendar.date(from: dateComponents), let date2 = userCalendar.date(from: dateComponents2) {
            let dates = Date.dates(from: date, to: date2)
            XCTAssertEqual(dates.count, 5)
        }
    }
    
    func testDateFromString() throws {
        var dateComponents = DateComponents(); dateComponents.year = 2022; dateComponents.month = 1; dateComponents.day = 1
        let userCalendar = Calendar(identifier: .gregorian)
        if let date = userCalendar.date(from: dateComponents) {
            let stringDate = "01-01-2022"
            let dateFromString = stringDate.dateFromString
            XCTAssertEqual(dateFromString, date)
        }
    }
    
    // MARK: - Firebase unit tests
    
    //We are not able to directly access the firebase db methods we are using in our system.
    func testFetchStudentsPerformance() throws {
        // This is an example of a performance test case.
        var students = [Student]()
        
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
                                                students.append(student)
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
    
    func testFetchTestStudentsPerformance() throws {
        var students = [Student]()
        
        self.measure {
            func fetchTestStudents() {
                db
                    .collection("test")
                    .document("testableData")
                    .collection("students")
                    .getDocuments { querySnapshot, err in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                do {
                                    if let student = try document.data(as: Student.self) {
                                        students.append(student)
                                    }
                                }
                                catch {
                                    print(error)
                                }
                            }
                        }
                    }
            }
        }
    }
    
    /// We are unable to directly test the method because of serveral private parameteres that is sat when logged in and user input.
    func testFetchClassesPerformance() throws {
        var classes = [ClassInfo]()
        
        self.measure {
            db
                .collection("fb_schools_path".localize)
                .document("EXvXPS4HuVnxu7LhZRPt")
                .collection("fb_classes_path".localize)
                .getDocuments { querySnapshot, err in
                    if let err = err {
                        ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .classManagerError)
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let classSnapshot = try document.data(as: ClassInfo.self) {
                                    classes.append(classSnapshot)
                                }
                            }
                            catch {
                                ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .classManagerError)
                            }
                        }
                    }
                }
        }
    }
    
    func testFetchRegistrations() throws {
        var registrations = [Registration]()
        
        self.measure {
            db
                .collection("test")
                .document("testableData")
                .collection("registration")
                .document("09-05-2022")
                .collection("morning")
                .getDocuments() {  (querySnapshot, err) in
                    if let err = err {
                        ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: err.localizedDescription, type: .registrationManagerError)
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let registration = try document.data(as: Registration.self) {
                                    registrations.append(registration)
                                    registrations.sort { $0.studentName < $1.studentName }
                                    print(registration)
                                }
                            }
                            catch {
                                ErrorHandling.shared.appError = ErrorType(title: "alert_title".localize, description: error.localizedDescription, type: .registrationManagerError)
                            }
                        }
                    }
                }
        }
    }
    
    func testWriteReport() throws {
        let report = Report(parentName: "test", parentID: "test", studentName: "test", studentID: "test", className: "test", classID: "test", date: Date(), endDate: nil, timeOfDay: .morning, description: nil, reason: .late, registrationType: .late, validated: false, teacherValidation: .pending, isDoubleRegistrationActivated: false)
        let writeDb = Firestore.firestore()
        
        do {
            let newReportRef = writeDb
                .collection("test")
                .document("testableData")
                .collection("reports")
                .document()
                
            let docID = newReportRef.documentID
            
            try newReportRef.setData(from: report)
            
            let newlyCreatedReportRef = writeDb
                .collection("test")
                .document("testableData")
                .collection("reports")
                .document(docID)
            
            newlyCreatedReportRef.getDocument { document, err in
                if let err = err {
                    print(err)
                } else {
                    if let document = document {
                        do {
                            if let report = try document.data(as: Report.self) {
                                if let id = report.id {
                                    XCTAssertEqual(docID, id)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func testWriteRegistration() throws {
        let registration = Registration(studentID: "test", studentName: "test", className: "test", date: "test", reason: .late, endDate: nil, validated: false, isAbsenceRegistered: false, isMorning: true)
        let writeDb = Firestore.firestore()
        
        do {
            let newRegistrationRef = writeDb
                .collection("test")
                .document("testableData")
                .collection("absence")
                .document()
                
            let docID = newRegistrationRef.documentID
            
            try newRegistrationRef.setData(from: registration)
            
            let newlyCreatedRegistrationRef = writeDb
                .collection("test")
                .document("testableData")
                .collection("absence")
                .document(docID)
            
            newlyCreatedRegistrationRef.getDocument { document, err in
                if let err = err {
                    print(err)
                } else {
                    if let document = document {
                        do {
                            if let report = try document.data(as: Report.self) {
                                if let id = report.id {
                                    XCTAssertEqual(docID, id)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
