package barlom.parser

import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream
import spock.lang.Specification

/**
 * Specification for parsing a compilation unit.
 */
class BarlomParserSpec
    extends Specification {

    def static String parse( String fileName ) {

        InputStream inFile = this.getClass().getResourceAsStream( "/barlom/parser/" + fileName );
        ANTLRInputStream inStream = new ANTLRInputStream( inFile );
        BarlomLexer lexer = new BarlomLexer(inStream);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        BarlomParser parser = new BarlomParser(tokens);
        parser.parse();

        if ( parser.getNumberOfSyntaxErrors() != 0 ) {
            return "Parse errors occurred in " + fileName;
        }

        return "Successful parse";
    }

    def "Literals are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "literals/" + fileName ) == parseResult

        where:
        fileName                   | parseResult
        "array-literals.barlom"    | "Successful parse"
        "boolean-literals.barlom"  | "Successful parse"
        "datetime-literals.barlom" | "Successful parse"
        "graph-literals.barlom"    | "Successful parse"
        "integer-literals.barlom"  | "Successful parse"
        "map-literals.barlom"      | "Successful parse"
        "nothing-literal.barlom"   | "Successful parse"
        "number-literals.barlom"   | "Successful parse"
        "record-literals.barlom"   | "Successful parse"
        "regex-literals.barlom"    | "Successful parse"
        "set-literals.barlom"      | "Successful parse"
        "symbol-literals.barlom"   | "Successful parse"
        "text-literals.barlom"     | "Successful parse"
        "tuple-literals.barlom"    | "Successful parse"

    }

}