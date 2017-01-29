# jsoni18n

A flexible internationalization library working with JSON files in Haxe.

* Translations files don't need to be in a specific location.
* They don't even need to be files.
* It can work with or without OpenFL.

## Installation

Haxelib:

```
haxelib install jsoni18n
```

OpenFL XML file (Project.xml):

```
<haxelib name="jsoni18n" />
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

For the following examples, we assume you do something like this:

```haxe
// it could be Reg.lang, context.userLang, App.instance.settings["currentLanguage"] or ...
var lang : String = myGetCurrentLanguage();
```

If you use OpenFL, you can load a file:

```haxe
I18n.loadFromFile("assets/data/i18n_" + lang + ".json");
```

Or directly from a string:

```haxe
var jsonFileContent : String = myLangFileLoader();
I18n.loadFromString(jsonFileContent);
```

Now, to translate something:

```haxe
var hello : String = I18n.tr("welcome/hello");
```

### Prefix

You can add prefixes to keys from all data fetched by a loadFromFile() or loadFromString() like this:

```haxe
I18n.loadFromString(data, "ui/");
I18n.tr("ui/welcome/hello"); // Hoy!
```

### Variables

You can pass variables to strings returned by tr() like this:

```haxe
I18n.tr("welcome/subtitle", [ "name" => "Nekith" ]); // Welcome, Nekith!
```

### Configuration

```haxe
I18n.depthDelimiter  =  "_";  // default: "/"
I18n.varPrefix       =  "@";  // default: ":"
```

## License

3-clause BSD. See LICENSE file.
