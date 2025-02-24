///|
typealias CharLiteral = String

///|
typealias StringLiteral = String

///|
typealias ByteLiteral = String

///|
typealias BytesLiteral = String

///|
struct InterpSource {
  source : String
  loc : Loc
} derive(Show)

///|
enum InterpElem {
  InterpLit(repr~ : String, loc~ : Loc)
  InterpSource(InterpSource)
} derive(Show)

///|
typealias InterpLiteral = Array[InterpElem]
