package;

import haxe.unit.TestCase;
import jsoni18n.I18n;

class TrTestCase extends TestCase
{
    var json : String;

    override public function setup() : Void
    {
        json = '{
            "welcome": {
                "hello": "Hoy!",
                "subtitle": "Welcome, :name!",
                "content": {
                    "main": "Le contenu principal devrait être plus long, mais vous saisissez l\'idée.",
                    "side": "Some useful side notes to shine in society."
                }
            },
            "title": "jsoni18n tests"
        }';
        I18n.depthDelimiter = "/";
        I18n.varPrefix = ":";
        I18n.loadFromString(json);
    }

    public function testBasic() : Void
    {
        assertEquals("jsoni18n tests", I18n.tr("title"));
    }

    public function testUnknown() : Void
    {
        assertEquals("brouzoufs", I18n.tr("brouzoufs"));
    }

    public function testWrongDepth() : Void
    {
        assertEquals("title/lol", I18n.tr("title/lol"));
    }

    public function testDepth() : Void
    {
        assertEquals("Hoy!", I18n.tr("welcome/hello"));
    }

    public function testVar() : Void
    {
        assertEquals("Welcome, Nekith!", I18n.tr("welcome/subtitle", [ "name" => "Nekith" ]));
    }

    public function testUtf() : Void
    {
        assertEquals("Le contenu principal devrait être plus long, mais vous saisissez l\'idée.", I18n.tr("welcome/content/main"));
    }
}
