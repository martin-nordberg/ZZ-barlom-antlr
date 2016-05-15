
package example.stuff;

import barlom.lang.BarlomLexer;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;

/**
 * Created by mnordberg on 5/15/16.
 */
public class ExampleMain {

    public static void main( String[] args ) {

        ANTLRInputStream in = new ANTLRInputStream("function g();");
        BarlomLexer lexer = new BarlomLexer(in);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        ExampleParser parser = new ExampleParser(tokens);
        parser.function();


    }
}
