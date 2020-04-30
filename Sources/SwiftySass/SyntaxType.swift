extension SassContext.Options {
	
	public enum SyntaxType {
		/// The newer SCSS syntax (`.scss`)
		///
		/// [Sass Docs: Syntax](https://sass-lang.com/documentation/syntax#scss)
		case scss
		
		/// The original indented syntax (`.sass`)
		///
		/// [Sass Docs: Syntax](https://sass-lang.com/documentation/syntax#the-indented-syntax)
		case indented
	}
	
}
