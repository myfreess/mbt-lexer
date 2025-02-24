struct Position {
  fname : String
  lnum : Int
  bol : Int
  cnum : Int
} derive(Show)

fn column(self : Position) -> Int {
  self.cnum - self.bol + 1
}


struct Loc {
  // pkg : String
  start : Position
  end : Position
} derive(Show)

typealias RPosition = Int

struct RLoc {
  start : RPosition
  end : RPosition
} derive(Show)