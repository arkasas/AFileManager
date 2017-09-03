//
//  APFileManager.swift
//  FileManager
//
//  Created by Arek on 16.05.2017.
//  Copyright © 2017 Arek. All rights reserved.
//

import UIKit
public enum UserDefaultDictionary: String {
    case music = "music"
    case document = "document"
    case image = "image"
    case root = "";
    static let allDictionary = [music, document, image];
}
public enum ImageFormat{
    case PNG
    case JPEG
}
public class APFileManager: NSObject {
    public static var path: String!;
    fileprivate static let fileManager = FileManager.default
    public class func start(){
        CheckPath();
        print(path);
        if (path) != nil{
            for dict in UserDefaultDictionary.allDictionary{
                CreateDirectory(name: dict.rawValue);
            }
        }
    }
    public class func CreateDirectory(name: String){
        CheckPath();
        let tempPath = path.appending("/\(name)");
        if !fileManager.fileExists(atPath: tempPath){
            do{
                try fileManager.createDirectory(atPath: tempPath, withIntermediateDirectories: false, attributes: nil);
            }
            catch{
                print("Error creating folder \(error)");
            }
        }
    }
    
    
    ///SAVE FILE
    public class func SaveFile(name: String, directory: String, data: Data?) -> Bool{
        CheckPath();
        let tempPath = path.appending("/\(directory)/\(name)");
        return fileManager.createFile(atPath: tempPath, contents: data, attributes: nil);
    }
    public class func SaveFile(name: String, directory: String, text: String) -> Bool{
        let data = text.data(using: .utf8);
        return SaveFile(name: name, directory: directory, data: data!);
    }
    public class func SaveFile(name: String, directory: UserDefaultDictionary, data: String) -> Bool{
        return SaveFile(name: name, directory: directory.rawValue, text: data);
    }
    public class func SaveImage(name: String, directory: String, image: UIImage, format: ImageFormat, quality: CGFloat = 1.0) -> Bool{
        var data: Data?;
        if format == .JPEG{
            data = UIImageJPEGRepresentation(image, quality)!;
        }
        else if format == .PNG{
            data = UIImagePNGRepresentation(image)!;
        }
        return SaveFile(name: name, directory: directory, data: data);
    }
    public class func SaveImage(name: String, directory: UserDefaultDictionary, image: UIImage, format: ImageFormat, quality: CGFloat = 1.0) -> Bool{
        var data: Data?;
        if format == .JPEG{
            data = UIImageJPEGRepresentation(image, quality)!;
        }
        else if format == .PNG{
            data = UIImagePNGRepresentation(image)!;
        }
        return SaveFile(name: name, directory: directory.rawValue, data: data);
    }
    
    ///REMOVE FILE
    public class func RemoveFile(name: String, directory: String) -> Bool{
        return Remove(name: "\(directory)/\(name)");
    }
    public class func RemoveDirectory(name: String) -> Bool{
        return Remove(name: name);
    }
    
    //OPEN FILE
    public class func OpenFile(name: String, directory: String) -> Data?{
        CheckPath();
        if directory == "" || directory.isEmpty{
            if let data =  OpenFile(path: path.appending("/\(name)")){
                return data;
            }
        }
        else{
            if let data = OpenFile(path: path.appending("/\(directory)/\(name)")){
                return data;
            }
        }
        return Data();
    }
    public class func OpenFile(name: String, directory: UserDefaultDictionary) -> Data?{
        CheckPath();
        if directory.rawValue == "" || directory.rawValue.isEmpty || directory == .root{
            if let data = OpenFile(path: path.appending("/\(name)")){
                return data;
            }
        }
        else{
            if let data = OpenFile(path: path.appending("/\(directory.rawValue)/\(name)")){
                return data;
            }
        }
        return Data();
    }
    public class func OpenTextFile(name: String, directory: String) -> String?{
        return String(data: OpenFile(name: name, directory: directory)!, encoding: .utf8);
    }
    public class func OpenTextFile(name: String, directory: UserDefaultDictionary) -> String?{
        return String(data: OpenFile(name: name, directory: directory.rawValue)!, encoding: .utf8);
    }
    public class func OpenImageFile(image name: String, directory: String) -> UIImage?{
        return UIImage(data: OpenFile(name: name, directory: directory)!);
    }
    public class func OpenImageFile(image name: String, directory: UserDefaultDictionary) -> UIImage?{
        return UIImage(data: OpenFile(name: name, directory: directory.rawValue)!);
    }
    
    //IS EXIST
    public class func IsFileExist(path: String) -> Bool{
        return fileManager.fileExists(atPath: path)
    }
    public class func IsFileExist(name: String, directory: String) -> Bool{
        CheckPath();
        if directory == "" || directory.isEmpty{
            return IsFileExist(path: path.appending("/\(name)"));
        }
        else{
            return IsFileExist(path: path.appending("/\(directory)/\(name)"));
        }
    }
    public class func IsFileExist(name: String, directory: UserDefaultDictionary) -> Bool{
        CheckPath();
        if directory == .root{
            return IsFileExist(path: path.appending("/\(name)"));
        }
        else{
            return IsFileExist(path: path.appending("/\(directory.rawValue)/\(name)"));
        }
    }
    //FILE/DIRECTORY LIST
    public class func GetFiles(inDirectory name: String, resourceKeys: [URLResourceKey]?) -> [URL]{
        CheckPath();
        var urlArray = [URL]();
        let tempPath = path.appending("/\(name)");
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(at: URL(string: tempPath)!, includingPropertiesForKeys: resourceKeys)!;
        for case let fileURL as URL in enumerator {
            urlArray.append(fileURL);
        }
        return urlArray;
    }
    public class func GetFiles(inDirectory name: UserDefaultDictionary, resourceKeys: [URLResourceKey]?) -> [URL]{
        CheckPath();
        var urlArray = [URL]();
        let tempPath = path.appending("/\(name.rawValue)");
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(at: URL(string: tempPath)!, includingPropertiesForKeys: resourceKeys)!;
        for case let fileURL as URL in enumerator {
            urlArray.append(fileURL);
        }
        return urlArray;
    }
}
public extension APFileManager{
    //SAVE FILE
    public class func SaveFile(name: String, directory: String, data: Data, completion: @escaping (_ result: Bool) -> Void){
        DispatchQueue.global(qos: .background).async {
            completion(SaveFile(name: name, directory: directory, data: data));
        }
    }
    public class func SaveFile(name: String, directory: UserDefaultDictionary, data: Data, completion: @escaping (_ result: Bool) -> Void){
        DispatchQueue.global(qos: .background).async {
            completion(SaveFile(name: name, directory: directory.rawValue, data: data));
        }
    }
    public class func SaveImage(name: String, directory: String, image: UIImage, format: ImageFormat, quality: CGFloat = 1.0, completion: @escaping(_ result: Bool) -> Void){
        var data: Data?;
        if format == .JPEG{
            data = UIImageJPEGRepresentation(image, quality)!;
        }
        else if format == .PNG{
            data = UIImagePNGRepresentation(image)!;
        }
        SaveFile(name: name, directory: directory, data: data!, completion: completion);
    }
    public class func SaveImage(name: String, directory: UserDefaultDictionary, image: UIImage, format: ImageFormat, quality: CGFloat = 1.0, completion: @escaping(_ result: Bool) -> Void){
        var data: Data?;
        if format == .JPEG{
            data = UIImageJPEGRepresentation(image, quality)!;
        }
        else if format == .PNG{
            data = UIImagePNGRepresentation(image)!;
        }
        SaveFile(name: name, directory: directory.rawValue, data: data!, completion: completion);
    }
    
    //OPEN FILE
    public class func OpenFile(name: String, directory: String, completion: @escaping(_ result: Data?) -> Void){
        DispatchQueue.global(qos: .background).async {
            if directory == "" || directory.isEmpty{
                completion(OpenFile(path: path.appending("/\(name)")))
            }
            else{
                completion(OpenFile(path: path.appending("/\(directory)/\(name)")));
            }
        }
    }
    public class func OpenFile(name: String, directory: UserDefaultDictionary, completion: @escaping(_ result: Data?) -> Void){
        DispatchQueue.global(qos: .background).async {
            if directory.rawValue == "" || directory.rawValue.isEmpty || directory == .root{
                completion(OpenFile(path: path.appending("/\(name)")))
            }
            else{
                completion(OpenFile(path: path.appending("/\(directory.rawValue)/\(name)")));
            }
        }
    }
    public class func OpenImage(name: String, directory: String, completion: @escaping(_ result: UIImage) -> Void){
        OpenFile(name: name, directory: directory, completion: {(data: Data?) in
            DispatchQueue.global(qos: .background).async {
                if data != nil{
                    let image = UIImage(data: data!);
                    DispatchQueue.main.async {
                        completion(image!);
                    }
                }
                else{
                    print("Cannot load file")
                }
            }
        })
    }
    public class func OpenImage(name: String, directory: UserDefaultDictionary, completion: @escaping(_ result: UIImage) -> Void){
        OpenFile(name: name, directory: directory, completion: {(data: Data?) in
            DispatchQueue.global(qos: .background).async {
                if data != nil{
                    let image = UIImage(data: data!);
                    DispatchQueue.main.async {
                        completion(image!);
                    }
                }
                else{
                    print("Cannot load file")
                }
            }
        })
    }
    public class func OpenTextFile(name: String, directory: String, completion: @escaping(_ result: String) -> Void) {
        OpenFile(name: name, directory: directory, completion: {(data: Data?) in
            DispatchQueue.global(qos: .background).async {
                if data != nil{
                    let textFile = String(data: data!, encoding: .utf8)
                    DispatchQueue.main.async {
                        completion(textFile!);
                    }
                }
                else{
                    print("Cannot open file");
                }
            }
        })
    }
    public class func OpenTextFile(name: String, directory: UserDefaultDictionary, completion: @escaping(_ result: String) -> Void) {
        OpenFile(name: name, directory: directory, completion: {(data: Data?) in
            DispatchQueue.global(qos: .background).async {
                if data != nil{
                    let textFile = String(data: data!, encoding: .utf8)
                    DispatchQueue.main.async {
                        completion(textFile!);
                    }
                }
                else{
                    print("Cannot open file");
                }
            }
        })
    }
    public class func GetFiles(inDirectory name: String, resourceKeys: [URLResourceKey]?, completion: @escaping(_ result: [URL]) -> Void){
        CheckPath();
        DispatchQueue.global(qos: .background).async {
            let urlArray = GetFiles(inDirectory: name, resourceKeys: resourceKeys);
            DispatchQueue.main.async {
                completion(urlArray);
            }
        }
    }
    public class func GetFiles(inDirectory name: UserDefaultDictionary, resourceKeys: [URLResourceKey]?, completion: @escaping(_ result: [URL]) -> Void){
        CheckPath();
        DispatchQueue.global(qos: .background).async {
            let urlArray = GetFiles(inDirectory: name, resourceKeys: resourceKeys);
            DispatchQueue.main.async {
                completion(urlArray);
            }
        }
    }
}
private extension APFileManager{
    class func CheckPath(){
        if path == nil{
            path = GetPath();
        }
    }
    class func GetPath() -> String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!;
    }
    class func Remove(name: String) -> Bool{
        CheckPath();
        let tempPath = path.appending("/\(name)");
        if IsFileExist(path: tempPath){
            do{
                try fileManager.removeItem(atPath: tempPath);
                return true;
            }
            catch{
                print("Error removing file \(error)");
                return false;
            }
        }
        return false;
    }
    class func OpenFile(path: String) -> Data? {
        if IsFileExist(path: path){
            do{
                return try Data(contentsOf: URL(fileURLWithPath: path));
            }
            catch{
                print("Cannot open \(error)");
            }
        }
        return nil;
    }
    class func IsDirectory(path: String) -> Bool{
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDir){
            if isDir.boolValue{
                return true
            }
        }
        return false;
    }
    //    class func SearchFile(name: String, directory: String) -> [String]{
    //
    //    }
}
