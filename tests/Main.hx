package;

import haxe.unit.TestRunner;

class Main
{
    static function main() : Void
    {
        var runner : TestRunner = new TestRunner();
        runner.add(new TrTestCase());
        runner.add(new ConfigTestCase());
        var success = runner.run();
#if sys
        Sys.exit(success ? 0 : 1);
#end
    }
}
