struct Comment {
  content : String
  kind : Kind
  consumed_by_docstring : Ref[Bool]
} derive (Show)

enum Kind {
  Inline_trailing
  Ownline(leading_blank_line~ : Bool, trailing_blank_line~ : Bool)
} derive (Show)