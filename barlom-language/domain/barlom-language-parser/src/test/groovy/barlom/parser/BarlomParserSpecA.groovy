package barlom.parser

import barlom.lexer.BarlomLexer
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream
import spock.lang.Specification

/**
 * Specification for parsing a compilation unit.
 */
class BarlomParserSpecA
    extends Specification {

    def static String parse( String code, int expectedPackagedElementCount ) {

        ANTLRInputStream inStream = new ANTLRInputStream(code);
        BarlomLexer lexer = new BarlomLexer(inStream);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        BarlomParser parser = new BarlomParser(tokens);
        BarlomParser.ParseContext context = parser.parse();

        if ( parser.getNumberOfSyntaxErrors() != 0 ) {
            return "Parse errors occurred";
        }

        if ( context.getChild(0).getChildCount() != 4 ) {
            return "Actual child count: " + context.getChild(0).getChildCount();
        }

        if ( context.getChild(0).getChild(2).getChildCount() != expectedPackagedElementCount ) {
            return "Actual packaged element count: " + context.getChild(0).getChild(2).getChildCount();
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
        parse( code, 1 ) == "Successful parse";
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
        parse( code, 2 ) == "Successful parse";
    }

    def "A compilation unit parser parses a simple empty function."() {

        given:
        def code = '''
        package p1.p2;

        function doNothing() {
        }
    ''';

        expect:
        parse( code, 1 ) == "Successful parse";
    }


}