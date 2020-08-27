import CLibSass
import Foundation

public struct SassOptions {
	private unowned var context: SassContext
	private var cContext: OpaquePointer { context.cContext }
	
	init(context: SassContext) {
		self.context = context
	}
	
	// MARK: - Configuration properties
	
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
	
	/// File paths that are used when resolving `@import` rules in Sass
	///
	/// This property is *read-only*. To add load paths, use the `addLoadPaths` function.
	public var loadPaths: [URL] {
		get {
			Array(0..<sass_option_get_include_path_size(cContext))
				.map { sass_option_get_include_path(cContext, $0) }
				.map { URL(fileURLWithPath: String(cString: $0)) }
		}
	}
	
	/// Adds additional paths to use when resolving `@import` rules in Sass
	///
	/// Note that load paths cannot be removed once added.
	///
	/// - Parameter urls: URL(s) to add
	///
	/// # Reference
	/// [Sass Documentation](https://sass-lang.com/documentation/at-rules/import#load-paths)
	public func addLoadPaths(_ urls: URL...) {
		urls.forEach {
			assert($0.isFileURL, "URLs passed to \(#function) must be file paths")
			
			sass_option_push_include_path(cContext, sass_copy_c_string($0.path))
		}
	}
}
