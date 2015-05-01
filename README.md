# Plisty
Plisty converts property list files to actual Swift objects.
It uses Swift's reflection capabilities as well as NSObject's Key Value Coding
to dynamically read property names and setting their values.

Things to consider:
* Types are neither checked nor enforced
* Objects correspond to Dictionaries inside a plist
* Arrays of objects correspond to Arrays of Dictionaries inside a plist
* Your objects must not contain Optionals and should set all properties to default values
* Recursive definitions of objects are not supported
* Plisty doesn't fail when it encounters:
  * Properties in a plist which don't have a counterpart in your object
  * Properties with a different type than Dictionary inside an Array in a plist
* Plisty fails spectacularly when it encounters:
  * Mismatching types

## Todo
* Proper tests
* Exception handling
