package parsers

import barlom.lexer.BarlomLexer
import barlom.parsers.CompilationUnitParser
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream
import spock.lang.Specification
/**
 * Specification for parsing a compilation unit.
 */
class CompilationUnitParserSpec
    extends Specification {

    def static String parse( String code, expectedChildCount ) {

        ANTLRInputStream inStream = new ANTLRInputStream(code);
        BarlomLexer lexer = new BarlomLexer(inStream);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        CompilationUnitParser parser = new CompilationUnitParser(tokens);
        CompilationUnitParser.ParseContext context = parser.parse();

        if ( parser.getNumberOfSyntaxErrors() != 0 ) {
            return "Parse errors occurred";
        }

        if ( context.getChild(0).getChildCount() != expectedChildCount ) {
            return "Actual child count: " + context.getChild(0).getChildCount();
        }

        return "Successful parse";
    }

    def "A compilation unit parser parses a constant."() {

        given:
        def code = '''
        package p1.p2;

        import p1.p3.Example;

        let x = "a string";
    ''';

        expect:
        parse( code, 3 ) == "Successful parse";
    }

    def "A compilation unit parser parses a constant and a function."() {

        given:
        def code = '''
        package p1.p2;

        import p1.p3.Example;

        let x = "a string";

        function doNothing() {
        }
    ''';

        expect:
        parse( code, 3 ) == "Successful parse";
    }

    def "A compilation unit parser parses a simple empty function."() {

        given:
        def code = '''
        package p1.p2;

        import p1.p3.Example;

        function doNothing() {
        }
    ''';

        expect:
        parse( code, 3 ) == "Successful parse";
    }


}