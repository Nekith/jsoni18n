package;

import utest.Test;
import utest.Assert;
import jsoni18n.I18n;

class ConfigTestCase extends Test {
	var i18n:I18n;

	public function setupClass():Void {
		var json:String = '{
            "welcome": {
                "hello": "Hoy!",
                "subtitle": "Welcome, @name!",
                "content": {
                    "main": "Le contenu principal devrait être plus long, mais vous saisissez l\'idée.",
                    "side": "Some useful side notes to shine in society."
                }
            },
            "news": {
                "list": { "0": "Nothing to display.", "1": "Only one new item.", "*": "@* new items." }
            },
            "person": {
                "f": "Female", "m": "Male", "^": "Person"
            },
            "secret": {
                "intro": "It\'s a secret page! Do you have authorization?"
            },
            "title": "jsoni18n tests"
        }';
		i18n = new I18n();
		i18n.depthDelimiter = ".";
		i18n.varPrefix = "@";
		i18n.pluralizationVar = "*";
		i18n.concordVar = '^';
		i18n.loadFromString(json);
	}

	public function testDepthDelimiter():Void {
		Assert.equals("Hoy!", i18n.tr("welcome.hello"));
	}

	public function testVarPrefix():Void {
		Assert.equals("Welcome, Nekith!", i18n.tr("welcome.subtitle", ["name" => "Nekith"]));
	}

	public function testPluralizationVar():Void {
		Assert.equals("7 new items.", i18n.tr("news.list", ["*" => 7]));
	}

	public function testConcordVar():Void {
		Assert.equals("Female", i18n.tr("person", ["^" => 'f']));
	}
}
