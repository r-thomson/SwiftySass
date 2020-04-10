public struct SassCompilerError: Error {
	/// Expanded error message
	///
	/// Example value:
	/// ```
	/// Error: Undefined variable: "$notDefined".
	///         on line 2:9 of stdin
	/// >>  color: $notDefined;
	///
	///    --------^
	/// ```
	public let message: String
	
	/// Textual description of the error
	///
	/// Example value:
	/// ```
	/// Undefined variable: "$notDefined".
	/// ```
	public let description: String
	
	/// File where the error occurred
	public let filename: String
	
	/// Line position of the error in `filename`
	public let line: Int
	
	/// Column position of the error in `filename`
	public let column: Int
}
