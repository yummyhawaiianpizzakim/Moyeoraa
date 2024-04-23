import ProjectDescription

public extension TargetDependency {
    struct SPM {}
    struct Package {}
}

public extension TargetDependency.SPM {
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let RxRelay = TargetDependency.external(name: "RxRelay")
    static let RxGesture = TargetDependency.external(name: "RxGesture")
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
//    static let Firebase = TargetDependency.external(name: "Firebase")
    static let FirebaseCore = TargetDependency.external(name: "FirebaseCore")
    static let FirebaseAuth = TargetDependency.external(name: "FirebaseAuth")
    static let FirebaseFirestore = TargetDependency.external(name: "FirebaseFirestore")
//    static let FirebaseFirestoreSwift = TargetDependency.external(name: "FirebaseFirestoreSwift")
    static let FirebaseStorage = TargetDependency.external(name: "FirebaseStorage")
    static let FirebaseDatabase = TargetDependency.external(name: "FirebaseDatabase")
    static let FirebaseMessaging = TargetDependency.external(name: "FirebaseMessaging")
}

public extension TargetDependency.Package {
    static let FirebaseAuth = TargetDependency.package(product: "FirebaseAuth")
    static let FirebaseFirestore = TargetDependency.package(product: "FirebaseFirestore")
    static let FirebaseStorage = TargetDependency.package(product: "FirebaseStorage")
    static let FirebaseDatabase = TargetDependency.package(product: "FirebaseDatabase")
    static let FirebaseMessaging = TargetDependency.package(product: "FirebaseMessaging")
//    static let Firebase = TargetDependency.package(product: "Firebase")
    static let FirebaseCore = TargetDependency.package(product: "FirebaseCore")
    
    static let RxSwift = TargetDependency.package(product: "RxSwift")
    static let RxCocoa = TargetDependency.package(product: "RxCocoa")
    static let RxRelay = TargetDependency.package(product: "RxRelay")
    static let RxGesture = TargetDependency.package(product: "RxGesture")
    static let SnapKit = TargetDependency.package(product: "SnapKit")
    static let Kingfisher = TargetDependency.package(product: "Kingfisher")
    
//    static let FBLPromises = TargetDependency.package(product: "FBLPromises")
//    static let GTMSessionFetcherCore = TargetDependency.package(product: "GTMSessionFetcherCore")
//    static let GoogleDataTransport = TargetDependency.package(product: "GoogleDataTransport")
//    static let GoogleUtilitiesAppDelegateSwizzler = TargetDependency.package(product: "GoogleUtilities-AppDelegateSwizzler")
//    static let GoogleUtilitiesEnvironment = TargetDependency.package(product: "GoogleUtilities-Environment")
//    static let GoogleUtilitiesLogger = TargetDependency.package(product: "GoogleUtilities-Logger")
//    static let GoogleUtilitiesNSData = TargetDependency.package(product: "GoogleUtilities-NSData")
//    static let GoogleUtilitiesNetwork = TargetDependency.package(product: "GoogleUtilities-Network")
//    static let GoogleUtilitiesReachability = TargetDependency.package(product: "GoogleUtilities-Reachability")
//    static let GoogleUtilitiesPrivacy = TargetDependency.package(product: "GoogleUtilitiesPrivacy")
//    static let leveldb = TargetDependency.package(product: "leveldb")
//    static let nanopb = TargetDependency.package(product: "nanopb")
//    static let FirebaseAppCheckInterop = TargetDependency.package(product: "FirebaseAppCheckInterop")
//    static let FirebaseCoreExtension = TargetDependency.package(product: "FirebaseCoreExtension")
//    static let FirebaseSharedSwift = TargetDependency.package(product: "FirebaseSharedSwift")
}

public extension Package {
    static let firebaseSDK = Package.remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "10.22.1"))
    static let RxSwift = Package.remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMajor(from: "6.6.0"))
    static let RxGesture = Package.remote(url: "https://github.com/RxSwiftCommunity/RxGesture.git", requirement: .upToNextMajor(from: "4.0.0"))
    static let SnapKit = Package.remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.7.0"))
    static let Kingfisher = Package.remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "7.0"))
}
