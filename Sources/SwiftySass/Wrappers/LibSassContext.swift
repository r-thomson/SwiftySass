import CLibSass

protocol LibSassContext {
	func compile() throws -> String
}

private extension LibSassContext {
	func getOutput(context: OpaquePointer) throws -> String {
		guard sass_context_get_error_status(context) == 0 else {
			throw SassCompilerError(
				message: String(cString: sass_context_get_error_message(context)),
				issue: String(cString: sass_context_get_error_text(context)),
				filename: String(cString: sass_context_get_error_file(context)),
				line: sass_context_get_error_line(context),
				column: sass_context_get_error_column(context))
		}
		
		return String(cString: sass_context_get_output_string(context))
	}
}

class LibSassDataContext: LibSassContext {
	private var context: OpaquePointer
	
	init(sourceString: String) {
		let buffer = sass_copy_c_string(sourceString)
		context = sass_make_data_context(buffer)
	}
	
	func compile() throws -> String {
		sass_compile_data_context(context)
		return try getOutput(context: context)
	}
	
	deinit {
		sass_delete_data_context(context)
	}
}

class LibSassFileContext: LibSassContext {
	private var context: OpaquePointer
	
	init(inputPath: String) {
		let buffer = sass_copy_c_string(inputPath)
		context = sass_make_file_context(buffer)
	}
	
	func compile() throws -> String {
		sass_compile_file_context(context)
		return try getOutput(context: context)
	}
	
	deinit {
		sass_delete_file_context(context)
	}
}
