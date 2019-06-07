package;

import utest.Test;
import utest.Assert;
import jsoni18n.I18n;

class TrTestCase extends Test
{
    var i18n : I18n;

    public function setupClass() : Void
    {
        var json : String = '{
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
            "title": "jsoni18n tests"
        }';
        i18n = new I18n();
        i18n.loadFromString(json);
    }

    public function testBasic() : Void
    {
        Assert.equals("jsoni18n tests", i18n.tr("title"));
    }

    public function testUnknown() : Void
    {
        Assert.equals("brouzoufs", i18n.tr("brouzoufs"));
    }

    public function testDepth() : Void
    {
        Assert.equals("Hoy!", i18n.tr("welcome/hello"));
    }

    public function testWrongDepth() : Void
    {
        Assert.equals("title/lol", i18n.tr("title/lol"));
    }

    public function testWrongType() : Void
    {
        Assert.equals("welcome/content", i18n.tr("welcome/content"));
    }

    public function testVar() : Void
    {
        Assert.equals("Welcome, Nekith!", i18n.tr("welcome/subtitle", [ "name" => "Nekith" ]));
    }

    public function testPlur() : Void
    {
        Assert.equals("27 new items.", i18n.tr("news/list", [ "_" => 27 ]));
        Assert.equals("Nothing to display.", i18n.tr("news/list", [ "_" => 0 ]));
        Assert.equals("Only one new item.", i18n.tr("news/list", [ "_" => 1 ]));
    }

    public function testWrongTypePlur() : Void
    {
        Assert.equals("news/list", i18n.tr("news/list"));
    }

    public function testUtf() : Void
    {
        Assert.equals("Le contenu principal devrait être plus long, mais vous saisissez l\'idée.", i18n.tr("welcome/content/main"));
    }
}
