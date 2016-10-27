# TrendingGIT

The main idea of the project is to list trending projects of Github and when tap on one of them, show their details.

#Required

    Swift 2.3, Xcode 8
    iOS 9+


#Pod details

For Installing it on Swift 2.3 with CocoaPods, specify it in your 'Podfile'.
```
platform :ios, '9.0'
pod ‘AFNetworking’
pod ‘SDWebImage’
pod 'MBProgressHUD'

Run 'pod install'
```

#Third party usage
```
AFNetworking for handing network calls
SDWebImage for downloading and caching profile image
MBProgressHUD for loading indicator 
```
# Class Details
```
ProjectListTableViewController:- Which shows list of projects 
Project:- project model 
ProjectServiceHelper:- To call webservces and load data
DetailViewController:- Shows data related to developer
```
