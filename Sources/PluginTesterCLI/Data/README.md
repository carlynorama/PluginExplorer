#  About the Data Folder

If a Build Plugin (in-build or pre-build) generates code, 
it will put the the generated files in the build folder, 
not the source folder. This means the repo will be unbuildable
without the plugin. This could be problematic, especially 
if the plugin is pulled in from another package. 
 
Essentially it makes the repository not archival on its own. 

Please provide a description somewhere that will be on the 
record of how the files are processed.  
 
## Example Code Generated from MyInBuildPlugin

```
import Foundation
import ArgumentParser

let testVariable = "hello"


struct Banana:Fruit {
    let name:String
}

struct Citrus:Fruit {
    let name:String
}

struct Apple:Fruit {
    let name:String
}

var FruitStore:Dictionary<String,[any Fruit]> = [     
     "banana":[Banana(name:"Cavendish"),Banana(name:"Lady Finger"),Banana(name:"Apple"),Banana(name:"Red"),Banana(name:"Gros Michel"),Banana(name:"Mysore"),Banana(name:"Blue Java"),Banana(name:"Manzano"),Banana(name:"Baragan"),Banana(name:"Goldfinger"),Banana(name:"Plantain"),Banana(name:"Fe'i"),Banana(name:"Orinoco")],     
     "citrus":[Citrus(name:"Orange")],     
     "apple":[Apple(name:"Macintosh"),Apple(name:"Fuji"),Apple(name:"Granny Smith"),Apple(name:"Honey Crisp"),Apple(name:"Delicious"),Apple(name:"Golden Delicious"),Apple(name:"Rome"),Apple(name:"Cortland")],
]
```
 

