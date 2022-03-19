module Examples exposing (..)


elmExample : String
elmExample =
  """module Main exposing (..)

import Html exposing (Html, text)

-- Main function

main : Html a
main =
  text "Hello, World!"
"""


typeScriptExample : String
typeScriptExample =
  """import { window } from "./exhaustive/exhaustive"

// Comment
const Pi: number = 3.14
const nan: number = NaN
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
function makePolygon(height: number): Polygon {
  return new Polygon(height, product);
}
let p: Polygon = makePolygon(1.4)
p.getName()
"""


xmlExample : String
xmlExample =
  """<html>
<head>
  <title>Elm Syntax Highlight</title>
</head>
<body id="main">
  <p class="hero">Hello World</p>
</body>
</html>
"""


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


pythonExample : String
pythonExample =
  """ice_cream = 'chocolate'
if ice_cream == 'chocolate':
  print('Yay, I love chocolate ice cream!')
else:
  print('Awwww, but chocolate is my favorite...');

# Multiply two numbers
def multiply(a, b):
  return a * b

class Animal:
  def __init__(self):
    pass

class Dog(Animal):
  kind = 'canine'

  def __init__(self, name):
    self.name = name

d = Dog('Fido')
"""
