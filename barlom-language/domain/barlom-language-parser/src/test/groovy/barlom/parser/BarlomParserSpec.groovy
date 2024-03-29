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
        fileName                      | parseResult
        "anonymous-literal.barlom"    | "Successful parse"
        "array-literals.barlom"       | "Successful parse"
        "boolean-literals.barlom"     | "Successful parse"
        "code-literals.barlom"        | "Successful parse"
        "datetime-literals.barlom"    | "Successful parse"
        "function-literals.barlom"    | "Successful parse"
        "graph-literals.barlom"       | "Successful parse"
        "integer-literals.barlom"     | "Successful parse"
        "list-literals.barlom"        | "Successful parse"
        "map-literals.barlom"         | "Successful parse"
        "number-literals.barlom"      | "Successful parse"
        "range-literals.barlom"       | "Successful parse"
        "regex-literals.barlom"       | "Successful parse"
        "self-literal.barlom"         | "Successful parse"
        "set-literals.barlom"         | "Successful parse"
        "structure-literals.barlom"   | "Successful parse"
        "template-literals.barlom"    | "Successful parse"
        "text-literals.barlom"        | "Successful parse"
        "tuple-literals.barlom"       | "Successful parse"
        "undefined-literal.barlom"    | "Successful parse"

    }

    def "Module definitions are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "modules/" + fileName ) == parseResult

        where:
        fileName          | parseResult
        "module01.barlom" | "Successful parse"
        "module02.barlom" | "Successful parse"
        "module03.barlom" | "Successful parse"
        "module04.barlom" | "Successful parse"

    }

    def "Package definitions are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "packages/" + fileName ) == parseResult

        where:
        fileName           | parseResult
        "package01.barlom" | "Successful parse"

    }

    def "Function definitions are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "functions/" + fileName ) == parseResult

        where:
        fileName                     | parseResult
        "functions-check.barlom"     | "Successful parse"
        "functions-forloop.barlom"   | "Successful parse"
        "functions-if.barlom"        | "Successful parse"
        "functions-match.barlom"     | "Successful parse"
        "functions-unless.barlom"    | "Successful parse"
        "functions-untilloop.barlom" | "Successful parse"
        "functions-whileloop.barlom" | "Successful parse"

    }

    def "Enumeration types are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "enumerations/" + fileName ) == parseResult

        where:
        fileName               | parseResult
        "enumeration01.barlom" | "Successful parse"
        "enumeration02.barlom" | "Successful parse"

    }

    def "Variant types are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "varianttypes/" + fileName ) == parseResult

        where:
        fileName                | parseResult
        "varianttypes01.barlom" | "Successful parse"
        "varianttypes02.barlom" | "Successful parse"

    }

    def "Structure types are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "structuretypes/" + fileName ) == parseResult

        where:
        fileName                     | parseResult
        "structureinstance01.barlom" | "Successful parse"
        "structuretype01.barlom"     | "Successful parse"

    }

    def "Object types are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "objecttypes/" + fileName ) == parseResult

        where:
        fileName                   | parseResult
        "objectinstance01.barlom"  | "Successful parse"
        "objectinterface01.barlom" | "Successful parse"
        "objecttype01.barlom"      | "Successful parse"

    }

    def "Specifications are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "specifications/" + fileName ) == parseResult

        where:
        fileName                 | parseResult
        "specification01.barlom" | "Successful parse"

    }

    def "Graph types are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "graphs/" + fileName ) == parseResult

        where:
        fileName         | parseResult
        "graph01.barlom" | "Successful parse"

    }

    def "Annotation types are parsed successfully."( String fileName, String parseResult ) {

        expect:
        parse( "annotations/" + fileName ) == parseResult

        where:
        fileName         | parseResult
        "annotation01.barlom" | "Successful parse"

    }

}
