package;

import haxe.unit.TestCase;
import jsoni18n.I18n;

class ConfigTestCase extends TestCase
{
    var json : String;

    override public function setup() : Void
    {
        json = '{
            "welcome": {
                "hello": "Hoy!",
                "subtitle": "Welcome, @name!",
                "content": {
                    "main": "Le contenu principal devrait être plus long, mais vous saisissez l\'idée.",
                    "side": "Some useful side notes to shine in society."
                }
            },
            "tweets": {
                "list": { "0": "Nothing to display.", "1": "Only one new item.", "n": "@n new items." }
            },
            "secret": {
                "intro": "It\'s a secret page! Do you have authorization?"
            },
            "title": "jsoni18n tests"
        }';
        I18n.depthDelimiter = "|";
        I18n.varPrefix = "@";
        I18n.pluralizationVar = "n";
        I18n.loadFromString(json);
    }

    public function testDepthDelimiter() : Void
    {
        assertEquals("Hoy!", I18n.tr("welcome|hello"));
    }

    public function testVarPrefix() : Void
    {
        assertEquals("Welcome, Nekith!", I18n.tr("welcome|subtitle", [ "name" => "Nekith" ]));
    }

    public function testPluralizationVar() : Void
    {
        assertEquals("7 new items.", I18n.tr("tweets|list", [ "n" => 7 ]));
    }
}
