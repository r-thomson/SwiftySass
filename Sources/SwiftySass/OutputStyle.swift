import CLibSass

extension SassContext.Options {
	
	public enum OutputStyle: Sass_Output_Style.RawValue {
		/// Indents the CSS to mirror the nesting of the Sass source
		///
		/// ```
		/// body {
		///   font-size: 18px; }
		///   body p {
		///     line-height: 1.6; }
		/// ```
		case nested
		
		/// Places each CSS selector and declaration on its own line
		///
		/// ```
		/// body {
		///   font-size: 18px;
		/// }
		///
		/// body p {
		///   line-height: 1.6;
		/// }
		/// ```
		case expanded
		
		/// Writes each CSS ruleset on a single line
		///
		/// ```
		/// body { font-size: 18px; }
		///
		/// body p { line-height: 1.6; }
		/// ```
		case compact
		
		/// Minimizes the length of the output by removing unnecessary characters
		///
		/// ```
		/// body{font-size:18px}body p{line-height:1.6}
		/// ```
		case compressed
		
		public init?(rawValue: Sass_Output_Style) {
			switch rawValue {
			case SASS_STYLE_NESTED:
				self = .nested
			case SASS_STYLE_EXPANDED:
				self = .expanded
			case SASS_STYLE_COMPACT:
				self = .compact
			case SASS_STYLE_COMPRESSED:
				self = .compressed
			default:
				return nil
			}
		}
		
		public var rawValue: Sass_Output_Style {
			switch self {
			case .nested:
				return SASS_STYLE_NESTED
			case .expanded:
				return SASS_STYLE_EXPANDED
			case .compact:
				return SASS_STYLE_COMPACT
			case .compressed:
				return SASS_STYLE_COMPRESSED
			}
		}
	}
	
}
