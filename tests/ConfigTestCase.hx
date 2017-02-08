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
            "secret": {
                "intro": "It\'s a secret page! Do you have authorization?"
            },
            "title": "jsoni18n tests"
        }';
        I18n.depthDelimiter = "|";
        I18n.varPrefix = "@";
        I18n.loadFromString(json);
    }

    public function testDepthDelimiter() : Void
    {
        assertEquals(I18n.tr("welcome|hello"), "Hoy!");
    }

    public function testVarPrefix() : Void
    {
        assertEquals(I18n.tr("welcome|subtitle", [ "name" => "Nekith" ]), "Welcome, Nekith!");
    }
}
