enum LexicalError {
  IllegalCharacter(Int)
  UnterminatedString
  UnterminatedStringInVariableInterploation
  UnterminatedBytes
  InterpInvalidMultilineString
  InterpInvalidComment
  InterpInvalidAttribute
  InterpMissingExpression
  InvalidEscapeSequence(String)
  NonAsciiInBytes(String)
  InvalidDotInt(String)
  InvalidByteLiteral(String)
}