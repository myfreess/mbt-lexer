///|
enum LexicalError {
  IllegalCharacter(Char)
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
