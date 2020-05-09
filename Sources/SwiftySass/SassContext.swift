import CLibSass

class SassContext {
	var cContext: OpaquePointer
	var options: SassOptions!
	
	fileprivate init(_ context: OpaquePointer) {
		self.cContext = context
		
		self.options = SassOptions(context: self)
	}
	
	func compile() throws -> String {
		guard sass_context_get_error_status(cContext) == 0 else {
			throw SassCompilerError(
				message: String(cString: sass_context_get_error_message(cContext)),
				description: String(cString: sass_context_get_error_text(cContext)),
				filename: sass_context_get_error_file(cContext).map({ String(cString: $0) }),
				line: sass_context_get_error_line(cContext),
				column: sass_context_get_error_column(cContext))
		}
		
		// Make sure that one of the compile functions is called first
		guard sass_context_get_output_string(cContext) != nil else {
			preconditionFailure("Failed to call a libsass compile function before calling super.compile()")
		}
		
		return String(cString: sass_context_get_output_string(cContext))
	}
}

/// Wrapper around LibSass' `Sass_Data_Context` struct
final class SassDataContext: SassContext {
	init(sourceString: String) {
		let buffer = sass_copy_c_string(sourceString)
		super.init(sass_make_data_context(buffer))
	}
	
	override func compile() throws -> String {
		sass_compile_data_context(cContext)
		return try super.compile()
	}
	
	deinit {
		sass_delete_data_context(cContext)
	}
}

/// Wrapper around LibSass' `Sass_File_Context` struct
final class SassFileContext: SassContext {
	init(inputPath: String) {
		let buffer = sass_copy_c_string(inputPath)
		super.init(sass_make_file_context(buffer))
	}
	
	override func compile() throws -> String {
		sass_compile_file_context(cContext)
		return try super.compile()
	}
	
	deinit {
		sass_delete_file_context(cContext)
	}
}
