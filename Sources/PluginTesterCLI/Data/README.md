#  About the Data Folder

If you use Build Plugins (in-build or pre-build) to generate
code from data/resources file you will have magic code in your 
project that no one looking at your repo will be able inspect.

Especially if the plugin is pulled in from another package. 
 
That's anti-helpful to anyone looking at your public code and 
not archival. Please provide a description somewhere of how the 
data files are processed.  
 
## Example Code Gen from MyInBuildPlugin

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
 

