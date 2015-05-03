//
//  Plisty.swift
//  plisty
//
//  Created by Alexander Palmanshofer on 30.04.15.
//  Copyright (c) 2015 Alexander Palmanshofer. All rights reserved.
//

import Foundation

class Plisty {
    // The AnyObjects from the plist have different actual types than Swift
    // TYPE_MAP is a mapping between these Foundation/Cocoa Types to the Swift ones
    private let TYPE_MAP = ["Swift.Bool"     : "__NSCFBoolean",
                            "Swift.String"   : "__NSCFString",
                            "Swift.Double"   : "__NSCFNumber",
                            "Swift.Float"    : "__NSCFNumber",
                            "Swift.Int"      : "__NSCFNumber",
                            "__NSDate"       : "__NSDate",
                            "NSConcreteData" : "__NSCFData",
                            "_NSZeroData"    : "__NSCFData"]
    
    private func singleObjectByDictionary<T: NSObject>(dictionary: NSDictionary, classType: T.Type) -> T {
        // Instantiate object of given type
        var desiredObject = classType()
        // Get available properties of given type
        let mirrorType = reflect(desiredObject)
        // Iterate over available properties of the instantiated object (exclude 'super' -> i = 1)
        for var i = 1; i < mirrorType.count; i++ {
            let propertyName = mirrorType[i].0 // Fetch property name via reflection
            // Get corresponding value from our NSDictionary
            let dictionaryPropertyValue: AnyObject? = dictionary[propertyName]
            // Check if the value really exists inside the NSDictionary
            if let dictionaryPropertyValue: AnyObject = dictionaryPropertyValue {
                // Set value on our object
                desiredObject.setValue(dictionaryPropertyValue, forKey: propertyName)
            }
        }
        // Return the constructed object
        return desiredObject
    }
    /**
      Generates an object based on the given plist path and class type.
    
      :param: pathToPlist Path to plist as String
      :param: classType Type of desired object. e.g. MyClass.self
      :returns: Object of given type with properties set according to given plist
    */
    func singleObjectByPath<T: NSObject>(pathToPlist: String, classType: T.Type) -> T {
        // Load contents as NSDictionary
        let plistData = NSDictionary(contentsOfFile: pathToPlist)
        // Check if the file exists
        if let plistData = plistData {
            // Create the object based on our NSDictionary
            return singleObjectByDictionary(plistData, classType: classType)
        }
        // Return a non-initialized object instead of nil
        return classType()
    }
    /**
      Generates an array of objects based on the given plist path and class type.
    
      :param: pathToPlist Path to plist as String
      :param: classType Type of desired object. e.g. MyClass.self
      :returns: Array of objects of given type with properties set according to given plist
    */
    func multipleObjectsByPath<T: NSObject>(pathToPlist: String, classType: T.Type) -> [T] {
        // Load contents as NSArray
        let plistData = NSArray(contentsOfFile: pathToPlist)
        // Create list for our objects
        var listOfDesiredObjects: [T] = []
        // Check if the file exists
        if let plistData = plistData {
            // Iterate over the elements in our NSArray
            if let dictionaries = plistData as? [AnyObject] {
                for element in dictionaries {
                    // Only try to use actual dictionaries, simple Strings and Numbers cannot be used by
                    // us to set multiple properties
                    if element is NSDictionary {
                        listOfDesiredObjects.append(singleObjectByDictionary(element as! NSDictionary, classType: classType))
                    }
                }
            }
        }
        // Return an empty list instead of nil
        return listOfDesiredObjects
    }
    
    private func validateValueType() -> Bool {
        return false
    }
}