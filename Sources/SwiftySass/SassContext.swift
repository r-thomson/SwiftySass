import CLibSass

class SassContext {
	fileprivate var cContext: OpaquePointer
	
	fileprivate init(_ context: OpaquePointer) {
		self.cContext = context
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

// Safe wrappers around LibSass getters and setters
extension SassContext {
	/// Precision for fractional numbers
	var precision: Int32 {
		get {
			sass_option_get_precision(cContext)
		}
		set {
			sass_option_set_precision(cContext, newValue)
		}
	}
	
	/// Sets the formatting for the compiled CSS
	var outputStyle: SassOutputStyle {
		get {
			// FIXME: This forced unwrap may be unsafe
			SassOutputStyle.init(rawValue: sass_option_get_output_style(cContext))!
		}
		set {
			sass_option_set_output_style(cContext, newValue.rawValue)
		}
	}
	
	/// Adds source comments to the compiled CSS
	var sourceComments: Bool {
		get {
			sass_option_get_source_comments(cContext)
		}
		set {
			sass_option_set_source_comments(cContext, newValue)
		}
	}
	
	/// Selects between the newer SCSS syntax and the original indented syntax
	var syntaxType: SassSyntax {
		get {
			sass_option_get_is_indented_syntax_src(cContext) ? .indented : .scss
		}
		set {
			sass_option_set_is_indented_syntax_src(cContext, newValue == .indented)
		}
	}
	
	/// String to be used for indentation
	var indentation: String {
		get {
			String(cString: sass_option_get_indent(cContext))
		}
		set {
			sass_option_set_indent(cContext, sass_copy_c_string(newValue))
		}
	}
	
	/// String to be used for line feeds
	var lineFeed: String {
		get {
			String(cString: sass_option_get_linefeed(cContext))
		}
		set {
			sass_option_set_linefeed(cContext, sass_copy_c_string(newValue))
		}
	}
}
