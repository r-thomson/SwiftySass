import Foundation

/// Swift package manager does not have proper support for resources
/// [(yet)](https://bit.ly/2UPouzJ ). This utility struct abuses `#file` as
/// a workaround to access resources in the `SwiftySassTestResources` directory.
/// The interface is similar to `Bundle`.
enum TestResources {
	static let resourceDirectory = URL(fileURLWithPath: #file)
		.deletingLastPathComponent() // SwiftySass/Tests/SwiftySassTests/
		.deletingLastPathComponent() // SwiftySass/Tests/
		.appendingPathComponent("SwiftySassTestResources/")
	
	static func url(forResourceAtPath path: String) -> URL {
		return resourceDirectory.appendingPathComponent(path).standardizedFileURL
	}
	
	static func path(forResourceAtPath path: String) -> String? {
		let fileURL = resourceDirectory.appendingPathComponent(path).standardizedFileURL

		return try? fileURL.checkResourceIsReachable() ? fileURL.path : nil
	}
}
