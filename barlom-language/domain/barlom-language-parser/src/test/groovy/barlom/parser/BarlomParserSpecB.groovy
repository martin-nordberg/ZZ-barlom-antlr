package barlom.parser

import barlom.lexer.BarlomLexer
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream
import spock.lang.Specification

/**
 * Specification for parsing a compilation unit.
 */
class BarlomParserSpecB
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

    def "Sample files are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( fileName ) == parseResult

        where:
        fileName | parseResult
        "literals.barlom" | "Successful parse"
        "sample01.barlom" | "Successful parse"

    }

}