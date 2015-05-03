# Swift-Plisty
Plisty converts property list files to actual Swift objects.
It uses Swift's reflection capabilities as well as NSObject's Key Value Coding
to dynamically read property names and set their values.

Things to consider:
* Objects correspond to Dictionaries inside a plist
* Arrays of objects correspond to Arrays of Dictionaries inside a plist
* Your objects must not contain Optionals and should set all properties to default values
* Recursive definitions of objects are not supported

Plisty is able to check types for you and only set properties when their types match with the ones
inside the plist. If this is problematic for your use case, you can disable the functionality by telling
Plisty that you don't want your types checked when creating the Plisty object.

## Todo
* Proper tests
* Support for arrays of primitive values