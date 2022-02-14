//
//  OSSExceptionalTests.swift
//  OSSSwiftDemoTests
//
//  Created by huaixu on 2018/1/13.
//  Copyright © 2018年 aliyun. All rights reserved.
//

import XCTest
import AliyunOSSiOS
import AliyunOSSSwiftSDK

class OSSExceptionalTests: OSSSwiftDemoTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAPI_putObjectWithErrorOfInvalidKey() -> Void {
        let request = OSSPutObjectRequest()
        let fileName = "oracle"
        let fileExtension = "pdf"
        request.bucketName = OSS_BUCKET_PRIVATE
        request.uploadingFileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)!
        request.objectKey = "/file1m"
        request.objectMeta = ["x-oss-meta-name1": "value1"];
        request.contentType = "application/pdf"
        request.uploadProgress = {(bytesSent, totalByteSent, totalBytesExpectedToSend) ->Void in
            print("bytesSent: \(bytesSent),totalByteSent: \(totalByteSent),totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        }
        
        let task = client.putObject(request)
        task.continue({ (t) -> Any? in
            XCTAssertNotNil(t.error)
            let error = t.error! as NSError
            XCTAssertEqual(OSSClientErrorCODE.codeInvalidArgument.rawValue, error.code);
            return nil
        }).waitUntilFinished()
    }
    
    func testAPI_putObjectWithErrorOfNoSource() -> Void {
        let request = OSSPutObjectRequest()
        request.bucketName = OSS_BUCKET_PRIVATE
        request.objectKey = "noresource"
        request.objectMeta = ["x-oss-meta-name1": "value1"];
        request.contentType = "application/pdf"
        request.uploadProgress = {(bytesSent, totalByteSent, totalBytesExpectedToSend) ->Void in
            print("bytesSent: \(bytesSent),totalByteSent: \(totalByteSent),totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        }
        
        let task = client.putObject(request)
        task.continue({ (t) -> Any? in
            XCTAssertNotNil(t.error)
            let error = t.error! as NSError
            XCTAssertEqual(OSSClientErrorCODE.codeInvalidArgument.rawValue, error.code);
            return nil
        }).waitUntilFinished()
    }
    
    func testAPI_putObjectWithErrorOfInvalidBucketName() {
        let request = OSSPutObjectRequest()
        let fileName = "oracle"
        let fileExtension = "pdf"
        request.bucketName = "oss-testcase-unexist-bucket"
        request.uploadingFileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)!
        request.objectKey = fileName + "." + fileExtension
        request.objectMeta = ["x-oss-meta-name1": "value1"];
        request.contentType = "application/pdf"
        request.uploadProgress = {(bytesSent, totalByteSent, totalBytesExpectedToSend) ->Void in
            print("bytesSent: \(bytesSent),totalByteSent: \(totalByteSent),totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        }
        
        let task = client.putObject(request)
        task.continue({ (t) -> Any? in
            XCTAssertNotNil(t.error)
            let error = t.error! as NSError
            XCTAssertEqual(-404, error.code);
            return nil
        }).waitUntilFinished()
    }
    
}
