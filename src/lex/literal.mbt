struct CharLiteral {
  val : UInt
  repr : String
} derive (Show)

struct StringLiteral {
  val : String
  repr : String
} derive (Show)

struct ByteLiteral {
  val : Byte
  repr : String
} derive (Show)

struct BytesLiteral {
  val : Bytes
  repr : String
} derive (Show)

struct InterpSource {
  source : String
  loc : Loc
} derive (Show)

enum InterpElem {
  InterpLit(c~:String, repr~:String, loc~:Loc)
  InterpSource(InterpSource)
} derive (Show)

typealias InterpLiteral = Array[InterpElem]