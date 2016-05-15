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
        CompilationUnitParser.CompilationUnitContext context = parser.compilationUnit();

        if ( context.getChildCount() != expectedChildCount ) {
            return "Actual child count: " + context.getChildCount();
        }

        if ( parser.getNumberOfSyntaxErrors() != 0 ) {
            return "Parse errors occurred";
        }

        return "Successful parse";
    }

    def "A compilation unit parser parses a simple empty function."() {

        given:
        def code = '''
        package p1.p2;

        function doNothing() {
        }
    ''';

        expect:
        parse( code, 2 ) == "Successful parse";
    }


}