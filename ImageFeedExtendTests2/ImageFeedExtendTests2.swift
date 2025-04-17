//
//  ImageFeedExtendTests2.swift
//  ImageFeedExtendTests2
//
//  Created by Nadin on 16.04.2025.
//
import XCTest

@testable import ImageFeedExtend

final class ImageFeedExtendTests2: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app.launchArguments.append("UITestMode")
        app.launch()
    }
    
    func testAuth() throws {
        
        let authButton = app.buttons["AuthButton"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 30), "Кнопка авторизации 'AuthButton' не найдена")
        authButton.tap()
        
        let webView = app.webViews.element(boundBy: 0)
        XCTAssertTrue(webView.waitForExistence(timeout: 30), "'UnsplashWebView' не загрузился")
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 30), "Поле логина не найдено")
        loginTextField.tap()
        loginTextField.typeText("minadin.m@gmail.com")
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 5), "Кнопка Done не появилась")
        doneButton.tap()
        webView.swipeUp()
        sleep(2)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 30), "Поле пароля не найдено")
        XCTAssertTrue(passwordTextField.isHittable, "Поле пароля не доступно для нажатия")
        let coordinate = passwordTextField.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        passwordTextField.tap()
        sleep(2)
        
        passwordTextField.typeText("1726252Kgt")
        XCTAssertTrue(doneButton.waitForExistence(timeout: 5), "Кнопка Done не появилась")
        doneButton.tap()
        
        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 30), "Кнопка логина не найдена")
        loginButton.tap()
        sleep(15)
        
        let tablesQuery = app.tables
        
        XCTAssertTrue(tablesQuery.element.waitForExistence(timeout: 50), "Таблица не найдена на экране")
        
        let tableElement = tablesQuery.element
        tableElement.swipeUp()
        
        let cell = app.tables.cells["ImagesListCell"]
        XCTAssertTrue(cell.waitForExistence(timeout: 120), "Лента не загрузилась")
    }
    
    func testFeed() throws {
        let table = app.tables["ImagesListTable"]
        XCTAssertTrue(table.waitForExistence(timeout: 10), "Таблица не появилась")
        
        let cell = table.cells.element(boundBy: 1)
        XCTAssertTrue(cell.waitForExistence(timeout: 5), "Вторая ячейка не найдена")
        if !cell.isHittable {
            while !cell.isHittable {
                table.swipeUp()
            }
        }
        cell.swipeUp()
        sleep(2)
        cell.swipeDown()
        
        let likeButton = cell.buttons["Like Button"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5), "Кнопка лайка не найдена")
        XCTAssertTrue(likeButton.isHittable, "Кнопка есть, но не hittable")
        XCTAssertEqual(likeButton.value as? String, "Off", "Ожидали состояние OFF")
        
        likeButton.tap()
        let onPredicate = NSPredicate(format: "value == 'On'")
        expectation(for: onPredicate, evaluatedWith: likeButton, handler: nil)
        waitForExpectations(timeout: 10)
        XCTAssertEqual(likeButton.value as? String, "On", "Ожидали состояние ON")
        
        likeButton.tap()
        let offPredicate = NSPredicate(format: "value == 'Off'")
        expectation(for: offPredicate, evaluatedWith: likeButton, handler: nil)
        waitForExpectations(timeout: 10)
        XCTAssertEqual(likeButton.value as? String, "Off", "Ожидали состояние OFF после второго тапа")
        
        cell.tap()
        let image = app.scrollViews.images.firstMatch
        XCTAssertTrue(image.waitForExistence(timeout: 5), "Изображение не появилось")
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["nav back button white"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Кнопка «Назад» не найдена")
        backButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Nadin"].exists)
        XCTAssertTrue(app.staticTexts["@minadin"].exists)
        
        app.buttons["Exit"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
    
    
    
    
    
    
    
    
}





