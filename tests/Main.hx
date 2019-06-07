package;

import utest.Runner;
import utest.ui.Report;

class Main
{
    static function main() : Void
    {
        var runner : Runner = new Runner();
        runner.addCase(new TrTestCase());
        runner.addCase(new ConfigTestCase());
        Report.create(runner);
        runner.run();
    }
}
