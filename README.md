# AFileManager
Simple file manager

## Getting Started
This is a very simple file library that allows you minimalise your works with files.

## Features
- [x] Read/Write file
- [x] Read/Write Image (.png, .jpeg)
- [x] Delete file
- [x] Create/Remove directory

## Requirements
- iOS 8.0+ 
- Xcode 8.1+
- Swift 3.0+

### Installing
#### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build Alamofire 4.0.0+.

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'AFileManager', :git => 'https://github.com/arkasas/AFileManager.git', :tag => '0.0.3'
end
```
Then, run the following command:

```bash
$ pod install
```

## Usage
### Recommended usage
Create 3 directory into your project root directory {image, document, music}
```swift
import AFileManager

AFileManager.start();
```
### Enums
```swift
    UserDefaultDictionary
    ImageFormat
```
UserDefaultDictionary contains default directory {image, document, music}. ImageFormat contains two possible picture format {PNG, JPEG}.

### Functions
To create directory
```swift
CreateDirectory(name: String)
```
To remove directory
```swift
RemoveDirectory(name: String)
```

To create file
```swift
SaveFile(name: String, directory: String, data: Data?)
SaveFile(name: String, directory: String, text: String)
SaveFile(name: String, directory: UserDefaultDictionary, data: String)
SaveImage(name: String, directory: String, image: UIImage, format: ImageFormat)
SaveImage(name: String, directory: String, image: UIImage, format: ImageFormat, quality: CGFloat)
SaveImage(name: String, directory: UserDefaultDictionary, image: UIImage, format: ImageFormat)
SaveImage(name: String, directory: UserDefaultDictionary, image: UIImage, format: ImageFormat, quality: CGFloat)
SaveFile(name: String, directory: String, data: Data, completion: @escaping (_ result: Bool) -> Void)
SaveFile(name: String, directory: UserDefaultDictionary, data: Data, completion: @escaping (_ result: Bool) -> Void)
SaveImage(name: String, directory: String, image: UIImage, format: ImageFormat, quality: CGFloat = 1.0, completion: @escaping(_ result: Bool) -> Void)
SaveImage(name: String, directory: UserDefaultDictionary, image: UIImage, format: ImageFormat, quality: CGFloat = 1.0, completion: @escaping(_ result: Bool) -> Void)
```
To remove file
```swift
RemoveFile(name: String, directory: String)
```

To open file
```swift
OpenFile(name: String, directory: String)
OpenTextFile(name: String, directory: String)
OpenTextFile(name: String, directory: UserDefaultDictionary)
OpenImageFile(image name: String, directory: String)
OpenImageFile(image name: String, directory: UserDefaultDictionary)
OpenFile(name: String, directory: String, completion: @escaping(_ result: Data?) -> Void)
OpenFile(name: String, directory: UserDefaultDictionary, completion: @escaping(_ result: Data?) -> Void)
OpenImage(name: String, directory: String, completion: @escaping(_ result: UIImage) -> Void)
OpenImage(name: String, directory: UserDefaultDictionary, completion: @escaping(_ result: UIImage) -> Void)
OpenTextFile(name: String, directory: String, completion: @escaping(_ result: String) -> Void)
OpenTextFile(name: String, directory: UserDefaultDictionary, completion: @escaping(_ result: String) -> Void)
```
To check is file exist
```swift
IsFileExist(path: String)
IsFileExist(name: String, directory: String)
IsFileExist(name: String, directory: UserDefaultDictionary)
```

To get files list
```swift
GetFiles(inDirectory name: String, resourceKeys: [URLResourceKey]?)
GetFiles(inDirectory name: UserDefaultDictionary, resourceKeys: [URLResourceKey]?)
GetFiles(inDirectory name: String, resourceKeys: [URLResourceKey]?, completion: @escaping(_ result: [URL]) -> Void)
GetFiles(inDirectory name: UserDefaultDictionary, resourceKeys: [URLResourceKey]?, completion: @escaping(_ result: [URL]) -> Void)
```
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
