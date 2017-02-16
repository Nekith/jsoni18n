# jsoni18n

A flexible internationalization library working with JSON files in Haxe.

[![Build Status](https://travis-ci.org/Nekith/jsoni18n.svg?branch=master)](https://travis-ci.org/Nekith/jsoni18n)

## Installation

Haxelib:

```
haxelib install jsoni18n
```

OpenFL project XML file:

```xml
<haxelib name="jsoni18n" />
```

OpenFL project HXP file:

```haxe
haxelibs.push(new Haxelib("jsoni18n"));
```

Haxe command line arguments:

```
haxe -lib jsoni18n ...
```

## Usage

### JSON files

It's JSON, objects and strings:

```json
{
    "welcome": {
        "hello": "Hoy!",
        "subtitle": "Welcome, :name!",
        "content": {
            "main": "Main content should be longer but you get the idea.",
            "side": "Some useful side notes to shine in society."
        }
    },
    "news": {
        "list": { "0": "Nothing to display.", "1": "Only one new item.", "_": ":_ new items." }
    },
    "secret": {
        "intro": "It's a secret page! Do you have authorization?"
    }
}
```

### Basics

There's only one import:

```haxe
import jsoni18n.I18n;
```

Initialization:

```haxe
var i18n : I18n = new I18n();
```

For the following examples, we assume you do something like this:

```haxe
// it could be Reg.lang, context.userLang, App.instance.settings["currentLanguage"] or ...
var lang : String = myGetCurrentLanguage();
```

Then you load data:

```haxe
var jsonFileContent : String = myLangFileLoader();
// or if you use OpenFL:
// var jsonFileContent : String = Assets.getText(filename);
i18n.loadFromString(jsonFileContent);
```

Now, to translate something:

```haxe
var hello : String = i18n.tr("welcome/hello");
```

### Prefix

You can add prefixes to keys from all data fetched by loadFromString() like this:

```haxe
i18n.loadFromString(data, "ui/");
i18n.tr("ui/welcome/hello"); // Hoy!
```

### Variables

You can pass variables to strings returned by tr() like this:

```haxe
i18n.tr("welcome/subtitle", [ "name" => "Nekith" ]); // Welcome, Nekith!
```

### Pluralization

It also handles pluralization for your convenience.

```haxe
i18n.tr("news/list", [ "_" => 0 ]); // Nothing to display.
i18n.tr("news/list", [ "_" => 12 ]); // 12 new items.
```

### Configuration

```haxe
i18n.depthDelimiter    =  ".";  // default: "/"
i18n.varPrefix         =  "@";  // default: ":"
i18n.pluralizationVar  =  "n";  // default: "_"
```

## License

3-clause BSD. See LICENSE file.

## Development

Github issues are open if you have suggestions or bugs to report.

### Tests

```
haxelib dev jsoni18n .
cd tests
haxe -main Main -lib jsoni18n -cpp build
cd build
./Main
```
