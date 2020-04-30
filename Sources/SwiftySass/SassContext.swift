import CLibSass

public class SassContext {
	fileprivate var cContext: OpaquePointer
	var options: Options!
	
	fileprivate init(_ context: OpaquePointer) {
		self.cContext = context
		
		self.options = Options(context: self)
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

// MARK: - Sass context configuration options

extension SassContext {
	
	public struct Options {
		private unowned var context: SassContext
		private var cContext: OpaquePointer { context.cContext }
		
		fileprivate init(context: SassContext) {
			self.context = context
		}
		
		// MARK: - Configuration computed properties
		
		/// Maximum digits of precision (after the decimal point) for numbers
		///
		/// The default value is 10.
		///
		/// # Reference
		/// [Sass Documentation](https://sass-lang.com/documentation/values/numbers#precision)
		public var precision: Int32 {
			get {
				sass_option_get_precision(cContext)
			}
			set {
				sass_option_set_precision(cContext, newValue)
			}
		}
		
		/// Output formatting for the compiled CSS
		///
		/// The default value is `.nested`. For possible values, see `OutputStyle`.
		public var outputStyle: OutputStyle {
			get {
				// FIXME: This forced unwrap may be unsafe
				OutputStyle.init(rawValue: sass_option_get_output_style(cContext))!
			}
			set {
				sass_option_set_output_style(cContext, newValue.rawValue)
			}
		}
		
		/// If source comments should be included in the compiled CSS
		///
		/// Source comments indicate where every rule was defined in the Sass source. The default
		/// value is `false`.
		///
		/// # Reference
		/// [Sass Documentation](https://sass-lang.com/documentation/js-api#sourcecomments)
		public var sourceComments: Bool {
			get {
				sass_option_get_source_comments(cContext)
			}
			set {
				sass_option_set_source_comments(cContext, newValue)
			}
		}
		
		/// Selects between the newer SCSS syntax and the original indented syntax
		///
		/// The default value is `.scss`.
		public var syntaxType: SyntaxType {
			get {
				sass_option_get_is_indented_syntax_src(cContext) ? .indented : .scss
			}
			set {
				sass_option_set_is_indented_syntax_src(cContext, newValue == .indented)
			}
		}
		
		/// String to be used for indentation in the CSS output
		///
		/// The default value is two spaces (`"  "`). Has no effect with the "compressed" output style.
		public var indentation: String {
			get {
				String(cString: sass_option_get_indent(cContext))
			}
			set {
				sass_option_set_indent(cContext, sass_copy_c_string(newValue))
			}
		}
		
		/// String to be used for line feeds in the CSS output
		///
		/// The default value is the newline character (`"\n"`).
		public var lineFeed: String {
			get {
				String(cString: sass_option_get_linefeed(cContext))
			}
			set {
				sass_option_set_linefeed(cContext, sass_copy_c_string(newValue))
			}
		}
	}
	
}
