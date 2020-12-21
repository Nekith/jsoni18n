# jsoni18n

A flexible internationalization library working with JSON files in Haxe.

* Does not assume the task of handling the origin/source of the translations (e.g. opening files).
* Has nothing about date localization.
* Has been made with coded strings (`welcome/hello`) as translation key in mind, not sentences in a source language (`Hello!`).

## Installation

Install with Haxelib:

```
haxelib install jsoni18n
```

Then, Haxe command line arguments or in a HXML file:

```
-lib jsoni18n
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

Import:

```haxe
import jsoni18n.I18n;
```

Initialization:

```haxe
var i18n : I18n = new I18n();
```

Load data:

```haxe
var jsonFileContent : String = myLangFileLoader();
i18n.loadFromString(jsonFileContent);
```

Now, to translate something:

```haxe
var hello : String = i18n.tr("welcome/hello"); // Hoy!
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
i18n.pluralizationVar  =  "*";  // default: "_"
```

## License

3-clause BSD. See LICENSE file.

## Development

Github issues are open if you have suggestions or bugs to report.

### Tests

```
haxelib install utest
haxelib dev jsoni18n .
cd tests
haxe -main Main -lib jsoni18n -lib utest -hl build.hl
hl build.hl
```

Tested against:

* 4.1.4