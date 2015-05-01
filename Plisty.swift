// The MIT License (MIT)
//
// Copyright (c) 2015 Alexander Palmanshofer
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

class Plisty {
    private class func singleObjectByDictionary<T: NSObject>(dictionary: NSDictionary, classType: T.Type) -> T {
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
    * Generates an object based on the given plist path and class type.
    * @param pathToPlist Path to plist as String
    * @param classType Type of desired object. e.g. MyClass.self
    * @return Object of given type with properties set according to given plist
    */
    class func singleObjectByPath<T: NSObject>(pathToPlist: String, classType: T.Type) -> T {
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
    * Generates an array of objects based on the given plist path and class type.
    * @param pathToPlist Path to plist as String
    * @param classType Type of desired object. e.g. MyClass.self
    * @return Array of objects of given type with properties set according to given plist
    */
    class func multipleObjectsByPath<T: NSObject>(pathToPlist: String, classType: T.Type) -> [T] {
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
}
