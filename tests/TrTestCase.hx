package;

import utest.Test;
import utest.Assert;
import jsoni18n.I18n;

class TrTestCase extends Test {
	var i18n:I18n;

	public function setupClass():Void {
		var json:String = '{
            "welcome": {
                "hello": "Hoy!",
                "subtitle": "Welcome, :name!",
                "content": {
                    "main": "Le contenu principal devrait être plus long, mais vous saisissez l\'idée.",
                    "side": "Some useful side notes to shine in society."
                }
            },
            "news": {
                "list": { "0": "Nothing to display.", "1": "Only one new item.", "_": ":_ new items." }
            },
            "title": "jsoni18n tests",
            "person": {
                "f": "Female", "m": "Male", "$": "Person"
            },
            "persons": {
                "0": "No one",
                "1": {
                    "f": "1 woman",
                    "m": "1 man",
                    "$": "1 person"
                },
                "_": {
                    "f": ":_ women",
                    "m": ":_ men",
                    "$": ":_ persons"
                }
            },
            "segfault": {
                "0": "No one",
                "1": {
                    "f": "1 woman",
                    "m": "1 man",
                    "o": "1 person"
                },
                "_": {
                    "f": ":_ women",
                    "m": ":_ men",
                    "o": ":_ persons"
                }
            }
        }';
		i18n = new I18n();
		i18n.loadFromString(json);
	}

	public function testBasic():Void {
		Assert.equals("jsoni18n tests", i18n.tr("title"));
	}

	public function testUnknown():Void {
		Assert.equals("brouzoufs", i18n.tr("brouzoufs"));
		Assert.equals("brouzoufs/with/depth", i18n.tr("brouzoufs/with/depth"));
	}

	public function testDepth():Void {
		Assert.equals("Hoy!", i18n.tr("welcome/hello"));
	}

	public function testWrongDepth():Void {
		Assert.equals("title/lol", i18n.tr("title/lol"));
	}

	public function testWrongType():Void {
		Assert.equals("welcome/content", i18n.tr("welcome/content"));
	}

	public function testVar():Void {
		Assert.equals("Welcome, Nekith!", i18n.tr("welcome/subtitle", ["name" => "Nekith"]));
	}

	public function testPlur():Void {
		Assert.equals("27 new items.", i18n.tr("news/list", ["_" => 27]));
		Assert.equals("Nothing to display.", i18n.tr("news/list", ["_" => 0]));
		Assert.equals("Only one new item.", i18n.tr("news/list", ["_" => 1]));
	}

	public function testWrongTypePlur():Void {
		Assert.equals("news/list", i18n.tr("news/list"));
	}

	public function testConcord():Void {
		Assert.equals("Female", i18n.tr("person", ["$" => "f"]));
		Assert.equals("Male", i18n.tr("person", ["$" => "m"]));
		Assert.equals("Person", i18n.tr("person", ["$" => "o"]));
	}

	public function testWrongTypeConcord():Void {
		Assert.equals("person", i18n.tr("person"));
	}

	public function testPlurConcord():Void {
		Assert.equals("56 women", i18n.tr("persons", ["$" => "f", "_" => 56]));
		Assert.equals("1 man", i18n.tr("persons", ["$" => "m", "_" => 1]));
		Assert.equals("421 persons", i18n.tr("persons", ["$" => "o", "_" => 421]));
		Assert.equals("No one", i18n.tr("persons", ["$" => "m", "_" => 0]));
	}

	public function testMustNotSegfault():Void {
		Assert.equals("56 women", i18n.tr("persons", ["$" => "f", "_" => 56]));
	}

	public function testUtf():Void {
		Assert.equals("Le contenu principal devrait être plus long, mais vous saisissez l\'idée.", i18n.tr("welcome/content/main"));
	}
}
