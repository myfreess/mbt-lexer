struct LexEnv {
  errors : Array[(Position, Position, String)]
  docstrings : Array[(Loc, Comment)]
  comment : Bool
  name : String
  arr : Array[(Token, Position, Position)]
  current_line : Int
  current_bol : Int
  last_unhandled_comment : Ref[(Comment, Int)?]
  asi_context : ASIContext
  start_cnum : Int
  is_interpolation : Bool
}

fn LexEnv::new() -> LexEnv {
  LexEnv::{
    errors : [],
    docstrings : [],
    comment : false,
    name : "",
    arr : [],
    current_line : 1,
    current_bol : 0,
    start_cnum : 0,
    last_unhandled_comment : @ref.new(None),
    asi_context : ASIContext::new(),
    is_interpolation : false
  }
}

fn add_lexing_error(self : LexEnv, loc_start~ : Int, loc_end~ : Int, err : LexicalError) -> Unit {
  let loc_start = self.make_position(loc_start)
  let loc_end = self.make_position(loc_end)
  let message =
    match err {
      InvalidDotInt(s) => "invalid byte literal: \{s}"
      NonAsciiInBytes(s) => "non-ASCII character is not allowed in bytes literal. If you meant to use the UTF-8 encoding of '\{s}', use escape sequence instead."
      InvalidEscapeSequence(seq) => "invalid escape sequence: \{seq}"
      InterpMissingExpression => "missing expression in string interpolation"
      InterpInvalidAttribute => "invalid attribute in string interpolation"
      InterpInvalidComment => "invalid comment in string interpolation"
      InterpInvalidMultilineString => "invalid multiline string in string interpolation"
      UnterminatedBytes => "(unterminated bytes literal)"
      UnterminatedStringInVariableInterploation => "(unterminated string in variable interpolation)"
      UnterminatedString => "(unterminated string)"
      IllegalCharacter(c) => "unrecognized character u32: \{c}"
      InvalidByteLiteral(s) => "invalid byte literal: \{s}"
    }
  self.errors.push((loc_start, loc_end, message))
}

fn make_position(self : LexEnv, cnum : Int) -> Position {
  Position::{ fname : self.name, lnum : self.current_line, cnum : self.start_cnum + cnum, bol : self.current_bol }
}