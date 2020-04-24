import CLibSass

class LibSassContext {
	fileprivate var context: OpaquePointer
	
	fileprivate init(context: OpaquePointer) {
		self.context = context
	}
	
	func compile() throws -> String {
		guard sass_context_get_error_status(context) == 0 else {
			throw SassCompilerError(
				message: String(cString: sass_context_get_error_message(context)),
				description: String(cString: sass_context_get_error_text(context)),
				filename: sass_context_get_error_file(context).map({ String(cString: $0) }),
				line: sass_context_get_error_line(context),
				column: sass_context_get_error_column(context))
		}
		
		// Make sure that one of the compile functions is called first
		guard sass_context_get_output_string(context) != nil else {
			preconditionFailure("Failed to call a libass compile function before calling super.compile()")
		}
		
		return String(cString: sass_context_get_output_string(context))
	}
}

/// Wrapper around LibSass' `Sass_Data_Context` struct
final class LibSassDataContext: LibSassContext {
	init(sourceString: String) {
		let buffer = sass_copy_c_string(sourceString)
		super.init(context: sass_make_data_context(buffer))
	}
	
	override func compile() throws -> String {
		sass_compile_data_context(context)
		return try super.compile()
	}
	
	deinit {
		sass_delete_data_context(context)
	}
}

/// Wrapper around LibSass' `Sass_File_Context` struct
final class LibSassFileContext: LibSassContext {
	init(inputPath: String) {
		let buffer = sass_copy_c_string(inputPath)
		super.init(context: sass_make_file_context(buffer))
	}
	
	override func compile() throws -> String {
		sass_compile_file_context(context)
		return try super.compile()
	}
	
	deinit {
		sass_delete_file_context(context)
	}
}
