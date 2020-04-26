// swift-tools-version:5.1

import PackageDescription

let package = Package(
	name: "SwiftySass",
	products: [
		.library(
			name: "SwiftySass",
			targets: ["SwiftySass"]),
	],
	targets: [
		.target(
			name: "SwiftySass",
			dependencies: ["CLibSass"]),
		.testTarget(
			name: "SwiftySassTests",
			dependencies: ["SwiftySass"]),
		.systemLibrary(
			name: "CLibSass",
			pkgConfig: "libsass",
			providers: [
				.brew(["libsass"]),
			]
		),
	]
)
