//
//  RegistrUITests.swift
//  RegistrUITests
//
//  Created by Christoffer Detlef on 06/05/2022.
//

import XCTest

class RegistrUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private var currentDate = Date()
    
    override func setUp() {
        super.setUp()
        
        self.app = XCUIApplication()
        self.app.launch()
    }
    
    // MARK: - Test for login
    func test_parent_login() {
        logout()
        // LoginOptions
        self.app.buttons["parentNavigationLink"].tap()
        
        // UserIDView
        let userIDTextField = self.app.textFields["userIDTextField"]
        userIDTextField.tap()
        userIDTextField.typeText("test1@test.com")
        
        self.app.buttons["userIDNextView"].tap()
        
        // PasswordView
        let passwordTextField = self.app.secureTextFields["passwordTextField"]
        passwordTextField.tap()
        passwordTextField.typeText("test1234")
        
        self.app.buttons["passwordLogin"].tap()
    }
    
    func test_teacher_login() {
        logout()
        // LoginOptions
        self.app.buttons["teacherNavigationLink"].tap()
        
        // UserIDView
        let userIDTextField = self.app.textFields["userIDTextField"]
        userIDTextField.tap()
        userIDTextField.typeText("teacher@test.com")
        
        self.app.buttons["userIDNextView"].tap()
        
        // PasswordView
        let passwordTextField = self.app.secureTextFields["passwordTextField"]
        passwordTextField.tap()
        passwordTextField.typeText("test1234")
        
        self.app.buttons["passwordLogin"].tap()
    }
    
    // MARK: - Test for creating a report as a teacher
    func test_make_new_report_registration() {

        let elementsQuery = test_access_report_view()
        
        var pickedDate: Date
        
        // If the current date is a weekend, there will not be displayed any kids, so we will need to move the date.
        if Calendar.current.isDateInWeekend(currentDate) {
            var dateComponent = DateComponents()
            dateComponent.day = 2
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
            pickedDate = futureDate
        } else {
            pickedDate = currentDate
        }
        
        // Select the date
        let scrollViewDate = elementsQuery.staticTexts[dateFormatter(date: pickedDate)]
        scrollViewDate.tap()
        scrollViewDate.tap()
        
        // Select a child to give an absence
        let studentScrollView = self.app.scrollViews["studentScrollView"].otherElements
        let selectStudent = studentScrollView.staticTexts["Alexander Larsen"]
        selectStudent.tap()
        
        // Select the absence for the child
        self.app.buttons["For sent"].tap()
        
        // Save the report
        self.app/*@START_MENU_TOKEN@*/.buttons["Gem"]/*[[".otherElements[\"tabbar\"].buttons[\"Gem\"]",".buttons[\"Gem\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    // MARK: - Checking if there is 15 dates, since it should take currentDate, and then 7 days in the future and 7 days in the past.
    func test_check_date_carousel_count() {
        // Getting the scrollView
        let element = test_access_report_view()
        
        // Counting all the items inside the scrollView
        var elementLabels = [String]()
        for i in 0..<element.staticTexts.count {
            elementLabels.append (element.staticTexts.element(boundBy: i).label)
        }
                
        // Using minus 1 here, since it also takes the text "I dag" into account, since it also is part of the scrollview
        let elementsCount = elementLabels.count-1
        
        // Checking if the amount of dates displayed is 15, since that is the amount there should be displayed.
        XCTAssertEqual(15, elementsCount)
        
    }
    
    // MARK: - Creat a new absence registration for child.
    func test_make_new_absence_registration() {
        // Login flow for parent
        let tabbar = self.app.tabBars["Fanelinje"]
        logout()
        test_parent_login()
        
        // Select registration in tabbar
        let tabBarItemRegistration = tabbar.buttons["Indberet"]
        tabBarItemRegistration.tap()
        
        
        // Select pick child in registration
        let selectClass = self.app.tables.children(matching: .cell).otherElements
        let accessClass = selectClass.firstMatch
        accessClass.tap()
        
        // Getting all the children in the collectionview
        let collectionViewStudents = self.app.collectionViews.children(matching: .cell)
        // Using a delay here, to make sure that the childrens get fetched from the server.
        
        // Selects the first child in the list.
        let selectStudent = collectionViewStudents.firstMatch
        selectStudent.tap()

        
        // Select absence reason menu
        self.app.buttons["absenceReasonMenu"].tap()
        
        // Select a reason from the absence reason menu
        self.app.buttons["For sent"].tap()
        
        // Write on the description for absence
        let writeDescriptionForAbsence = self.app.textViews["writeDescriptionForAbsence"]
        writeDescriptionForAbsence.tap()
        writeDescriptionForAbsence.typeText("Simone kommer for sent i dag, da vi var til bryllup i går.")
        // Need a second tap, to remove the focus from the TextEditor
        writeDescriptionForAbsence.tap()

        // Create the registration
        self.app.buttons["createRegistration"].tap()
        
        // If there already have been made a registration that day, there will appear an alert.
        // This will handle that, where it will tap on the OK button and then continue with showing that there is more than one registration.
        if app.alerts["Hov, dette er ikke muligt!"].exists {
            let okButton = app.alerts.buttons["OK"]
              if okButton.exists {
                okButton.tap()
              }
            self.child_absence_registration_count(isAfterRegistration: true)
        } else {
            self.child_absence_registration_count(isAfterRegistration: true)
        }
    }
    
    // MARK: - Gets the absence count, without needing to create one first.
    func test_child_absence_registration_count() {
        child_absence_registration_count(isAfterRegistration: false)
    }
}


extension RegistrUITests {
    func logout() {
        let tabbar = self.app.tabBars["Fanelinje"]
        if tabbar.buttons["Børn"].exists {
            app.tabBars["Fanelinje"].buttons["Profil"].tap()
            app.buttons["Log ud"].tap()
        } else if tabbar.buttons["Indberettelser"].exists {
            app.navigationBars["Indberettelser"].buttons["person"].tap()
            app.buttons["Log ud"].tap()
        } else {
            XCTAssertTrue(true)
        }
    }
    
    func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MMM"
        
        return dateFormatter.string(from: date)
    }
    
    
    // MARK: - Access the report view
    func test_access_report_view() -> XCUIElementQuery {
        // Login flow for teacher
        logout()
        test_teacher_login()
        
        // Select report in tabbar
        let tabbar = self.app.tabBars["Fanelinje"]
        let tabBarItemRegistration = tabbar.buttons["Fravær"]
        tabBarItemRegistration.tap()
        
        // Select a class to make the report.
        let selectClass = self.app.tables.children(matching: .cell)
        let accessClass = selectClass.firstMatch
        accessClass.tap()
        
        let elementsQuery = self.app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"tabbar\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements
        return elementsQuery
    }
    
    func child_absence_registration_count(isAfterRegistration: Bool) {
        
        let tabbar = self.app.tabBars["Fanelinje"]
        if isAfterRegistration {
            // Select home in tabbar
            let tabBarItemRegistration = tabbar.buttons["Børn"]
            tabBarItemRegistration.tap()
        } else {
            // Uses the parent login flow
            logout()
            test_parent_login()
        }
        // Getting the list of children
        let childCount = self.app.tables.children(matching: .cell)
        
        // Using a delay here, to make sure that the childrens get fetched from the server.
        childCount.element.waitForExistence(timeout: 1)
        
        // Selects the first child in the list.
        childCount.firstMatch.tap()
        
        // Selects the button for the absence registration.
        self.app.buttons["Indberettelser"].tap()
        
        // Gets the count for all the absences
        let cellCount = self.app.tables.children(matching: .cell).count
                
        if isAfterRegistration {
            XCTAssertGreaterThan(cellCount, 0)
        } else {
            XCTAssertGreaterThanOrEqual(cellCount, 0)
        }
    }
}
