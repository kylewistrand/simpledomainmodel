//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var newAmount : Int = amount
    if currency == "USD" {
        if to == "GBP" {
            newAmount = amount / 2
        } else if to == "EUR" {
            newAmount = Int(Double(amount) * 1.5)
        } else if to == "CAN" {
            newAmount = Int(Double(amount) * 1.25)
        }
    } else if currency == "GBP" {
        if to == "USD" {
            newAmount = amount * 2
        } else if to == "EUR" {
            return Money(amount: amount, currency: currency).convert("USD").convert("EUR")
        } else if to == "CAN" {
            return Money(amount: amount, currency: currency).convert("USD").convert("CAN")
        }
    } else if currency == "EUR" {
        if to == "USD" {
            newAmount = Int(Double(amount) / 1.5)
        } else if to == "GBP" {
            return Money(amount: amount, currency: currency).convert("USD").convert("GBP")
        } else if to == "CAN" {
            return Money(amount: amount, currency: currency).convert("USD").convert("CAN")
        }
    } else if currency == "CAN" {
        if to == "USD" {
            newAmount = Int(Double(amount) / 1.25)
        } else if to == "GBP" {
            return Money(amount: amount, currency: currency).convert("USD").convert("GBP")
        } else if to == "EUR" {
            return Money(amount: amount, currency: currency).convert("USD").convert("EUR")
        }
    }
    
    return Money(amount: newAmount, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    return Money(amount: to.convert(currency).amount + amount, currency: currency).convert(to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    return Money(amount: from.convert(currency).amount - amount, currency: currency).convert(from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let hourly):
        return Int(hourly * Double(hours))
    case .Salary(let salary):
        return salary
    }
  }
  
  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let hourly):
        type = .Hourly(hourly + amt)
    case .Salary(let salary):
        type = .Salary(salary + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return self._job }
    set(value) {
        if age >= 16 {
            self._job = value
        } else {
            self._job = nil
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return self._spouse }
    set(value) {
        if age >= 18 {
            self._spouse = value
        } else {
            self._spouse = nil
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    print("[Person: firstName: \(firstName) lastName: \(lastName) age: \(age) job: \(job?.type) spouse: \(spouse?.firstName)]")
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.type) spouse:\(spouse?.firstName)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        members.append(spouse1)
        members.append(spouse2)
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    for member in members {
        if member.age >= 21 {
            members.append(child)
            return true
        }
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var income : Int = 0
    for member in members {
        income += member.job?.calculateIncome(2000) ?? 0
    }
    return income
  }
}






