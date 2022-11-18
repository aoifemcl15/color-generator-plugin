# ColorGeneratorPlugin

A Swift Package Plugin which colour generation from a palette, which can be used both in Xcode project targets as well as Swift Packages. 

The package takes two JSON input files, a Palette.json and a Semantic.json. The package will then use these JSON files to produce two outputs, a GeneratedColors.xcassets and a Colors.swift. 

The GeneratedColors.xcassets catalogue will contain all of the colours referenced in the Semantic.json. 

The Colors.swift is a file with `Colors` enum which you can use to access the colours in code, like so: `Colors.Namespace.colourName`

## Installation 

### Xcode Project

You can integrate ColorGeneratorPlugin into your Xcode project as an Xcode Build Tool Plug-in if you're working with a project in Xcode. 

Add ColorGeneratorPlugin as a package dependency to your project. 
<img width="540" alt="Screenshot 2022-11-18 at 16 11 27" src="https://user-images.githubusercontent.com/53755195/202750271-29e8395f-1ae2-496d-aff3-c15a1d90510c.png">

Select the target you want to add the colour generation to and open and open the `Build Phases` inspector. 
Open `Run Build Tool Plug-ins` and select the `+` button. Select `ColorGeneratorPlugin` from the list and add it to the project. 
<img width="540" alt="Screenshot 2022-11-18 at 16 11 40" src="https://user-images.githubusercontent.com/53755195/202750299-5ec29d4a-b758-4aa9-a8b4-d3fec01db2b6.png">


### Swift Package 

You can integrate ColorGeneratorPlugin as a Swift Package Manager Plug-in if you're working with a Swift Package with a `Package.swift` manifest. 

Add ColorGeneratorPlugin as a package dependency to your `Package.swift` file. 
Add ColorGeneratorPlugin to a target using the `plugins` parameter. 

## Usage 

### Requirements 

This ColorGeneratorPlugin requires that the target you are using it with contains two JSON files. 
1. Semantic.json 
2. Palette.json 
 


