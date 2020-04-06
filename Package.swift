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
			dependencies: ["LibSass"]),
		.testTarget(
			name: "SwiftySassTests",
			dependencies: ["SwiftySass"]),
		.systemLibrary(
			name: "LibSass",
			pkgConfig: "libsass",
			providers: [
				.brew(["libsass"]),
			]
		),
	]
)
