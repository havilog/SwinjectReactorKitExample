import ProjectDescription
import ProjectDescriptionHelpers

/*
                +-------------+
                |             |
                |     App     | Contains TuistSample App target and TuistSample unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */


let targetActions = [
    TargetAction.pre(
        path: "Scripts/SwiftLintRunScript.sh",
        arguments: [],
        name: "SwiftLint"
    ),
    TargetAction.pre(
        path: "Scripts/RSwiftRunScript.sh",
        arguments: [],
        name: "R.swift",
        inputPaths: [Path.init("$TEMP_DIR/rswift-lastrun")],
        inputFileListPaths: [],
        outputPaths: [Path.init("$SRCROOT/SwinjectReactorKitExample/Resources/R.generated.swift")],
        outputFileListPaths: []
    )
]

let targets = [
    Target(
        name: "SwinjectReactorKitExample",
        platform: .iOS,
        product: .app,
        bundleId: "com.havi.SwinjectReactorKitExample",
        deploymentTarget: .iOS(targetVersion: "14.5", devices: [.iphone]),
        infoPlist: "SwinjectReactorKitExample/Supporting/Info.plist",
        sources: "SwinjectReactorKitExample/Sources/**",
        resources: "SwinjectReactorKitExample/Resources/**",
        actions: targetActions,
        dependencies: [
            .cocoapods(path: ".")
        ]
    ),
    Target(
        name: "SwinjectReactorKitExampleTests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "com.havi.SwinjectReactorKitExampleTests",
        infoPlist: "SwinjectReactorKitExampleTests/Info.plist",
        sources: "SwinjectReactorKitExampleTests/**",
        dependencies: [
            .target(name: "SwinjectReactorKitExample")
        ]
    ),
    Target(
        name: "SwinjectReactorKitExampleUITests",
        platform: .iOS,
        product: .uiTests,
        bundleId: "com.havi.SwinjectReactorKitExampleUITests",
        infoPlist: "SwinjectReactorKitExampleTests/Info.plist",
        sources: "SwinjectReactorKitExampleUITests/**",
        dependencies: [
            .target(name: "SwinjectReactorKitExample")
        ]
    )
]

// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project(
    name: "SwinjectReactorKitExample",
    organizationName: "havi",
    targets: targets
)
