module Examples exposing (..)


cssExample : String
cssExample =
  """stock::before {
  display: block;
  content: "To scale, the lengths of materials in stock are:";
}
stock > * {
  display: block;
  width: attr(length em); /* default 0 */
  height: 1em;
  border: solid thin;
  margin: 0.5em;
}
.wood {
  background: orange url(wood.png);
}
.metal {
  background: #c0c0c0 url(metal.png);
}
"""


elmExample : String
elmExample =
  """module Main exposing (..)

import Html exposing (Html, text)

type Msg
  = Increment
  | Decrement

type alias Model =
  { count : Int
  , name : String
  }

-- Main function

main : Html a
main =
  text "Hello, World!"
"""


pythonExample : String
pythonExample =
  """from enum import Enum
from typing import *

# Comment
PI: float = 3.14
num: Optional[int] = None
nums: list[int] = [1, 2, 3]
flag: bool = True
iceCream: str = "chocolate" if flag else "vanilla"

if iceCream == 'chocolate':
    print(f'Yay, I love ${iceCream} ice cream!')
else:
    print('Awwww, but chocolate is my favorite...')


def multiply(num1: float, num2: float) -> float:
    result = num1 * num2 * 1.0
    return result


product: float = multiply(num, 10)


class Thing:
    pass


class Polygon(Thing):
    _name: str
    _height: float
    _width: float

    def __init__(self, height: float, width: float):
        super()
        self._name = 'Polygon'
        self._height = height
        self._width = width

    def get_name(self) -> str:
        print("hello")
        x = 1 * 2
        return self._name


def make_polygon(height: float) -> Polygon:
    return Polygon(height, product)


p: Polygon = make_polygon(1.4)
p.get_name()


class Direction(Enum):
    NORTH = "n"
    SOUTH = "s"
    EAST = "e"
    WEST = "w"


print(Direction.NORTH)
"""


typeScriptExample : String
typeScriptExample =
  """import { window } from "./exhaustive/exhaustive"

// Comment
const Pi: number = 3.14
nan: number = NaN
var num: number = 42
let flag: boolean = true
let iceCream: string = flag ? "chocolate" : "vanilla";

if (iceCream === 'chocolate') {
  alert(`Yay, I love ${iceCream} ice cream!`);
} else {
  alert('Awwww, but chocolate is my favorite...');
}

function multiply(num1: number, num2: number): number {
  const result = num1 * num2 * 1.0;
  return result;
}

let product: number = multiply(num, 10)

class Thing {}

export class Polygon extends Thing {
  private readonly name: string;
  private height: number;
  private width: number;

  constructor(height: number, width: number) {
    super();
    this.name = 'Polygon';
    this.height = height;
    this.width = width;
  }

  getName(): string {
    alert("hello");
    let x = 1 * 2
    return this.name;
  }
}
function rotatePolygon(input: Polygon): Polygon {
  return new Polygon(input.width, input.height);
}
let p: Polygon = makePolygon(1.4)
p.getName()

enum Direction {
  NORTH = "n",
  SOUTH = "s",
  EAST = "e",
  WEST = "w"
}
alert(Direction.NORTH)
"""


xmlExample : String
xmlExample =
  """<!-- Comment -->
<html>
  <head>
    <title>Elm Syntax Highlight</title>
  </head>
  <body id="main" number=42>
    <p class="hero">Hello World</p>
  </body>
</html>
"""
