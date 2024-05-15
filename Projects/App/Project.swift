import ConfigurationPlugin
import DependencyPlugin
import EnvironmentPlugin
import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let configurations: [Configuration] = .default

let settings: Settings = .settings(
    base: env.baseSetting,
    configurations: configurations,
    defaultSettings: .recommended
)

let scripts: [TargetScript] = generateEnvironment.scripts

let packages: [Package] = [
    .firebaseSDK,
    .SnapKit,
    .RxSwift,
    .RxGesture,
    .Kingfisher
]

let targets: [Target] = [
    .target(
        name: env.name,
        destinations: env.destinations,
        product: .app,
        bundleId: "\(env.organizationName).\(env.name)",
        deploymentTargets: env.deploymentTargets,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: ["Resources/**",
                    "../../GoogleService-Info.plist"
                   ],
        scripts: scripts,
        dependencies: [
//            .Package.Firebase,
            .Package.FirebaseAuth,
//            .Package.FirebaseCore,
            .Package.FirebaseStorage,
            .Package.FirebaseDatabase,
            .Package.FirebaseFirestore,
            .Package.FirebaseMessaging,
            .Package.RxSwift,
            .Package.RxCocoa,
            .Package.RxRelay,
            .Package.RxGesture,
            .Package.Kingfisher,
            .Package.SnapKit,
        ],
        settings: .settings(base: env.baseSetting)
    )
]

let schemes: [Scheme] = [
    .scheme(
        name: "\(env.name)-DEV",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.name)"]),
        runAction: .runAction(configuration: .dev, 
                              executable: "\(env.name)",
                              arguments: Arguments.arguments(environmentVariables: ["IDEPreferLogStreaming": "YES"])),
        archiveAction: .archiveAction(configuration: .dev),
        profileAction: .profileAction(configuration: .dev),
        analyzeAction: .analyzeAction(configuration: .dev)
    ),
    .scheme(
        name: "\(env.name)-STAGE",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.name)"]),
        runAction: .runAction(configuration: .stage, 
                              executable: "\(env.name)",
                              arguments: Arguments.arguments(environmentVariables: ["IDEPreferLogStreaming": "YES"])),
        archiveAction: .archiveAction(configuration: .stage),
        profileAction: .profileAction(configuration: .stage),
        analyzeAction: .analyzeAction(configuration: .stage)
    ),
    .scheme(
        name: "\(env.name)-PROD",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.name)"]),
        runAction: .runAction(configuration: .prod,
                              executable: "\(env.name)",
                              arguments: Arguments.arguments(environmentVariables: ["IDEPreferLogStreaming": "YES"])),
        archiveAction: .archiveAction(configuration: .prod),
        profileAction: .profileAction(configuration: .prod),
        analyzeAction: .analyzeAction(configuration: .prod)
    )
]

let project = Project(
    name: env.name,
    organizationName: env.organizationName,
    packages: packages,
    settings: settings,
    targets: targets,
    schemes: schemes
)
