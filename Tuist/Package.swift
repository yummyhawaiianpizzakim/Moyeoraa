// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [:],
//                productTypes: [
//                    "RxSwift": .framework,
//                    "RxCocoa": .framework,
//                    "RxRelay": .framework,
//                    "RxGesture": .framework,
//                    "SnapKit": .framework,
//                    "Kingfisher": .framework,
//                    "FirebaseAuth": .framework,
//                    "FirebaseFirestore": .framework,
////                    "FirebaseFirestoreSwift": .framework,
//                    "FirebaseStorage": .framework,
//                    "FirebaseDatabase": .framework,
//                    "FirebaseMessaging": .framework
//                ],
                baseSettings: .settings(
                        configurations: [
                            .debug(name: .dev),
                            .debug(name: .stage),
                            .release(name: .prod)
                        ]
                    )
    )
#endif

let package = Package(
    name: "Moyeoraa",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
//        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.6.0")),
//        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", .upToNextMajor(from: "4.0.0")),
//        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.22.0")),
//        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.7.0")),
//        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.0"))
    ]
)
