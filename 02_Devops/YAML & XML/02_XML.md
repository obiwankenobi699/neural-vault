---
title:
  "{ Title }":
tags:
  - DevOps
created:
  "{ date }":
updated:
  "{ date }":
---
# XML (Extensible Markup Language)

XML is a markup language designed to store and transport data in a format that is both human-readable and machine-readable. Unlike HTML, which focuses on displaying data, XML focuses on describing and structuring data.

## XML Structure and Syntax

```
┌─────────────────────────────────────────────────────────────┐
│                    XML DOCUMENT STRUCTURE                   │
└─────────────────────────────────────────────────────────────┘

    <?xml version="1.0" encoding="UTF-8"?>  ← XML Declaration
    
    <!-- Root Element (Required - only one) -->
    <bookstore>                              ← Opening Tag
        
        <!-- Child Elements -->
        <book category="fiction">            ← Attribute
            <title lang="en">                ← Nested Element
                The Great Gatsby
            </title>                         ← Closing Tag
            <author>F. Scott Fitzgerald</author>
            <year>1925</year>
            <price currency="USD">10.99</price>
        </book>
        
        <book category="science">
            <title>A Brief History of Time</title>
            <author>Stephen Hawking</author>
            <year>1988</year>
            <price currency="USD">15.99</price>
        </book>
        
    </bookstore>                             ← Root Closing Tag
```

## XML Tree Structure

```
                    bookstore (Root)
                         |
         ┌───────────────┴───────────────┐
         |                               |
       book                            book
    (category="fiction")           (category="science")
         |                               |
    ┌────┼────┬──────┬──────┐      ┌────┼────┬──────┬──────┐
    |    |    |      |      |      |    |    |      |      |
  title author year price  ...   title author year price  ...
```

## XML Syntax Rules

```
┌─────────────────────────────────────────────────────────────┐
│                  XML SYNTAX RULES                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✓ Must have a root element                                │
│  ✓ Tags must be properly closed                            │
│  ✓ Tags are case-sensitive                                 │
│  ✓ Elements must be properly nested                        │
│  ✓ Attribute values must be in quotes                      │
│  ✓ Special characters must be escaped                      │
│                                                             │
│  CORRECT                    INCORRECT                       │
│  ────────────────────────────────────────                  │
│  <name>John</name>          <name>John                     │
│  <Name>...</Name>           <name>...</Name>  (different)  │
│  <a><b></b></a>             <a><b></a></b>                 │
│  <item id="1"/>             <item id=1>                    │
│  &lt; &gt; &amp;            < > &                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Example XML Document:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<students>
    <student id="101">
        <name>Alice Johnson</name>
        <age>20</age>
        <major>Computer Science</major>
        <gpa>3.8</gpa>
    </student>
    <student id="102">
        <name>Bob Smith</name>
        <age>22</age>
        <major>Mathematics</major>
        <gpa>3.5</gpa>
    </student>
</students>
```

# DTD (Document Type Definition)

DTD defines the structure and legal elements of an XML document. It specifies what elements can appear, in what order, and what attributes they can have. DTD acts as a blueprint or contract for XML documents.

## DTD Structure

```
┌─────────────────────────────────────────────────────────────┐
│                    DTD COMPONENTS                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. ELEMENT DECLARATIONS                                    │
│     <!ELEMENT element-name (content-model)>                 │
│                                                             │
│  2. ATTRIBUTE DECLARATIONS                                  │
│     <!ATTLIST element-name attribute-name type default>     │
│                                                             │
│  3. ENTITY DECLARATIONS                                     │
│     <!ENTITY entity-name "entity-value">                    │
│                                                             │
│  4. NOTATION DECLARATIONS                                   │
│     <!NOTATION notation-name SYSTEM "URI">                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## DTD Declaration Types

```
INTERNAL DTD                      EXTERNAL DTD
────────────────                  ────────────────

<?xml version="1.0"?>            <?xml version="1.0"?>
<!DOCTYPE root [                 <!DOCTYPE root SYSTEM "file.dtd">
  <!ELEMENT root (child)>        <root>
  <!ELEMENT child (#PCDATA)>       <child>Text</child>
]>                               </root>
<root>
  <child>Text</child>            ┌──────────────────┐
</root>                          │   file.dtd       │
                                 ├──────────────────┤
   ↑                             │ <!ELEMENT root   │
   |                             │   (child)>       │
   └─ DTD inside XML             │ <!ELEMENT child  │
                                 │   (#PCDATA)>     │
                                 └──────────────────┘
                                         ↑
                                         |
                                         └─ DTD in separate file
```

## DTD Element Content Models

```
┌─────────────────────────────────────────────────────────────┐
│              DTD CONTENT MODELS                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Symbol  │  Meaning            │  Example                   │
│  ────────┼─────────────────────┼──────────────────────────  │
│  #PCDATA │  Text data          │  <!ELEMENT name (#PCDATA)> │
│  EMPTY   │  No content         │  <!ELEMENT br EMPTY>       │
│  ANY     │  Any content        │  <!ELEMENT div ANY>        │
│  ,       │  Sequence (order)   │  <!ELEMENT book            │
│          │                     │    (title,author,year)>    │
│  |       │  Choice (one of)    │  <!ELEMENT contact         │
│          │                     │    (email|phone)>          │
│  ?       │  Optional (0 or 1)  │  <!ELEMENT person          │
│          │                     │    (name,nickname?)>       │
│  *       │  Zero or more       │  <!ELEMENT list (item*)>   │
│  +       │  One or more        │  <!ELEMENT book            │
│          │                     │    (chapter+)>             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
## PCDATA in XML

**PCDATA** stands for **Parsed Character Data**. It refers to text content within an XML element that will be parsed by an XML parser. During parsing:

- The parser checks for markup (like nested tags).
    
- Entity references (e.g., `&lt;`, `&gt;`, `&amp;`) are expanded.
    
- Characters like `<`, `>`, and `&` must be escaped (as `&lt;`, `&gt;`, `&amp;`) to avoid being interpreted as markup.
    

PCDATA is used in **Document Type Definitions (DTDs)** to 
specify that an element contains text that should be parsed.

---


**Complete DTD Example:**

```dtd
<!-- bookstore.dtd -->
<!ELEMENT bookstore (book+)>
<!ELEMENT book (title, author, year, price)>
<!ELEMENT title (#PCDATA)>
<!ELEMENT author (#PCDATA)>
<!ELEMENT year (#PCDATA)>
<!ELEMENT price (#PCDATA)>

<!ATTLIST book 
    category CDATA #REQUIRED
    isbn CDATA #IMPLIED>
    
<!ATTLIST title 
    lang CDATA #FIXED "en">
    
<!ATTLIST price 
    currency CDATA #REQUIRED>
```

**XML using this DTD:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE bookstore SYSTEM "bookstore.dtd">
<bookstore>
    <book category="fiction" isbn="978-0-123456-78-9">
        <title lang="en">The Great Gatsby</title>
        <author>F. Scott Fitzgerald</author>
        <year>1925</year>
        <price currency="USD">10.99</price>
    </book>
</bookstore>
```

## DTD Attribute Types

```
┌─────────────────────────────────────────────────────────────┐
│                 DTD ATTRIBUTE TYPES                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Type        │  Description        │  Example               │
│  ────────────┼────────────────────┼────────────────────────│
│  CDATA       │  Character data    │  <!ATTLIST person      │
│              │                    │    name CDATA #REQUIRED>│
│  ID          │  Unique identifier │  <!ATTLIST student     │
│              │                    │    id ID #REQUIRED>    │
│  IDREF       │  Reference to ID   │  <!ATTLIST course      │
│              │                    │    instructor IDREF>   │
│  NMTOKEN     │  Name token        │  <!ATTLIST item        │
│              │                    │    code NMTOKEN>       │
│  Enumerated  │  Fixed set values  │  <!ATTLIST book        │
│              │                    │    type (fiction|      │
│              │                    │         non-fiction)>  │
│                                                             │
│  Default Values:                                            │
│  #REQUIRED   - Attribute must be provided                   │
│  #IMPLIED    - Attribute is optional                        │
│  #FIXED      - Attribute has fixed value                    │
│  "value"     - Default value if not specified               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

# XSD (XML Schema Definition)

XSD is a more powerful alternative to DTD for defining XML document structure. It uses XML syntax itself, supports data types, namespaces, and provides better validation capabilities.

## XSD vs DTD Comparison

```
┌─────────────────────────────────────────────────────────────┐
│                    XSD vs DTD                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Feature          │  DTD              │  XSD               │
│  ─────────────────┼───────────────────┼────────────────────│
│  Syntax           │  Special syntax   │  XML syntax        │
│  Data Types       │  Limited          │  Rich (50+ types)  │
│  Namespaces       │  Not supported    │  Full support      │
│  Extensibility    │  Limited          │  Highly extensible │
│  Complexity       │  Simple           │  More complex      │
│  Validation       │  Basic            │  Advanced          │
│                                                             │
└─────────────────────────────────────────────────────────────┘

        DTD                           XSD
    ───────────                   ───────────
    
    <!ELEMENT person              <xs:element name="person">
      (name,age)>                   <xs:complexType>
    <!ELEMENT name                    <xs:sequence>
      (#PCDATA)>                        <xs:element name="name"
    <!ELEMENT age                         type="xs:string"/>
      (#PCDATA)>                        <xs:element name="age"
                                          type="xs:integer"/>
                                      </xs:sequence>
         ↑                            </xs:complexType>
         |                          </xs:element>
    No data types                          ↑
                                           |
                                      Specific data types
```

## XSD Structure

```
┌─────────────────────────────────────────────────────────────┐
│                  XSD DOCUMENT STRUCTURE                     │
└─────────────────────────────────────────────────────────────┘

<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

    ┌──────────────────────────────────────┐
    │      Simple Type Elements            │
    │  (Text content only, no attributes)  │
    └──────────────────────────────────────┘
    <xs:element name="name" type="xs:string"/>
    <xs:element name="age" type="xs:integer"/>
    
    ┌──────────────────────────────────────┐
    │      Complex Type Elements           │
    │  (Contains other elements/attributes)│
    └──────────────────────────────────────┘
    <xs:element name="person">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="name" type="xs:string"/>
                <xs:element name="age" type="xs:integer"/>
            </xs:sequence>
            <xs:attribute name="id" type="xs:string"/>
        </xs:complexType>
    </xs:element>
    
</xs:schema>
```

## XSD Data Types

```
┌─────────────────────────────────────────────────────────────┐
│                    XSD DATA TYPES                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BUILT-IN SIMPLE TYPES                                      │
│                                                             │
│  String Types         Numeric Types        Date/Time        │
│  ─────────────        ──────────────       ────────────     │
│  xs:string            xs:integer           xs:date          │
│  xs:normalizedString  xs:decimal           xs:time          │
│  xs:token             xs:float             xs:dateTime      │
│                       xs:double            xs:duration      │
│                       xs:positiveInteger                    │
│                                                             │
│  Boolean              Binary               Other            │
│  ────────             ───────              ─────            │
│  xs:boolean           xs:hexBinary         xs:anyURI        │
│                       xs:base64Binary      xs:QName         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## XSD Occurrence Indicators

```
┌─────────────────────────────────────────────────────────────┐
│              XSD OCCURRENCE INDICATORS                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Indicator    │  Meaning                │  Example          │
│  ─────────────┼─────────────────────────┼──────────────────│
│  minOccurs="0"│  Optional (0 or more)   │  <xs:element     │
│  maxOccurs="1"│  Default: exactly once  │    name="email"  │
│               │                         │    minOccurs="0" │
│               │                         │    maxOccurs="1"/>│
│                                                             │
│  minOccurs="1"│  Required, at least one │  <xs:element     │
│  maxOccurs="∞"│  (unbounded)            │    name="phone"  │
│               │                         │    minOccurs="1" │
│               │                         │    maxOccurs=    │
│               │                         │    "unbounded"/> │
│                                                             │
│  minOccurs="0"│  Optional, multiple     │  <xs:element     │
│  maxOccurs="∞"│  allowed                │    name="hobby"  │
│               │                         │    minOccurs="0" │
│               │                         │    maxOccurs=    │
│               │                         │    "unbounded"/> │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Complete XSD Example:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <!-- Root element -->
    <xs:element name="bookstore">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="book" maxOccurs="unbounded">
                    <xs:complexType>
                        <xs:sequence>
                            <xs:element name="title" type="xs:string"/>
                            <xs:element name="author" type="xs:string"/>
                            <xs:element name="year" type="xs:integer"/>
                            <xs:element name="price" type="PriceType"/>
                        </xs:sequence>
                        <xs:attribute name="category" type="xs:string" use="required"/>
                        <xs:attribute name="isbn" type="xs:string" use="optional"/>
                    </xs:complexType>
                </xs:element>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
    
    <!-- Custom type for price -->
    <xs:complexType name="PriceType">
        <xs:simpleContent>
            <xs:extension base="xs:decimal">
                <xs:attribute name="currency" type="xs:string" use="required"/>
            </xs:extension>
        </xs:simpleContent>
    </xs:complexType>
    
    <!-- Restriction example -->
    <xs:simpleType name="YearType">
        <xs:restriction base="xs:integer">
            <xs:minInclusive value="1900"/>
            <xs:maxInclusive value="2100"/>
        </xs:restriction>
    </xs:simpleType>

</xs:schema>
```

**XML using this XSD:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bookstore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:noNamespaceSchemaLocation="bookstore.xsd">
    <book category="fiction" isbn="978-0-123456-78-9">
        <title>The Great Gatsby</title>
        <author>F. Scott Fitzgerald</author>
        <year>1925</year>
        <price currency="USD">10.99</price>
    </book>
</bookstore>
```

# SAX (Simple API for XML)

SAX is an event-driven, sequential access parser for XML documents. Unlike DOM (Document Object Model) which loads the entire document into memory, SAX reads XML sequentially and triggers events as it encounters different parts of the document.

## SAX vs DOM Comparison

```
┌─────────────────────────────────────────────────────────────┐
│                    SAX vs DOM                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Feature        │  SAX                │  DOM               │
│  ───────────────┼─────────────────────┼────────────────────│
│  Memory Usage   │  Low (streaming)    │  High (full tree)  │
│  Speed          │  Fast               │  Slower            │
│  Access         │  Sequential only    │  Random access     │
│  Modification   │  Read-only          │  Read/Write        │
│  Use Case       │  Large files        │  Small files       │
│  Complexity     │  More complex       │  Easier to use     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## How SAX Works

```
┌─────────────────────────────────────────────────────────────┐
│                  SAX PARSING FLOW                           │
└─────────────────────────────────────────────────────────────┘

XML Document                    SAX Parser Events
───────────────                 ─────────────────

<?xml version="1.0"?>    ───>   startDocument()
                                      │
<bookstore>              ───>   startElement("bookstore")
                                      │
  <book>                 ───>   startElement("book")
                                      │
    <title>              ───>   startElement("title")
                                      │
      Harry Potter       ───>   characters("Harry Potter")
                                      │
    </title>             ───>   endElement("title")
                                      │
    <author>             ───>   startElement("author")
                                      │
      J.K. Rowling       ───>   characters("J.K. Rowling")
                                      │
    </author>            ───>   endElement("author")
                                      │
  </book>                ───>   endElement("book")
                                      │
</bookstore>             ───>   endElement("bookstore")
                                      │
                         ───>   endDocument()


      Sequential Processing (One-way, No going back)
      ═══════════════════════════════════════════════>
```

## SAX Event Handlers

```
┌─────────────────────────────────────────────────────────────┐
│                  SAX EVENT METHODS                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Method              │  Triggered When                      │
│  ────────────────────┼──────────────────────────────────── │
│  startDocument()     │  Parsing begins                      │
│  endDocument()       │  Parsing ends                        │
│  startElement()      │  Opening tag encountered             │
│  endElement()        │  Closing tag encountered             │
│  characters()        │  Text content found                  │
│  ignorableWhitespace()│ Whitespace found                    │
│  processingInstruction()│ PI found (<?...?>)                │
│  warning()           │  Warning occurs                      │
│  error()             │  Recoverable error                   │
│  fatalError()        │  Non-recoverable error               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## SAX Parser Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              SAX PARSER ARCHITECTURE                        │
└─────────────────────────────────────────────────────────────┘

    XML File
       │
       ▼
┌─────────────────┐
│   SAX Parser    │  (Reads sequentially)
└────────┬────────┘
         │
         │ Fires Events
         │
         ▼
┌─────────────────────────────────────┐
│   Content Handler (Your Class)      │
│                                     │
│   • startElement()                  │
│   • endElement()                    │
│   • characters()                    │
│   • etc.                            │
│                                     │
│   Your custom logic processes       │
│   each event as it occurs           │
└─────────────────────────────────────┘
         │
         ▼
    Application Logic
    (Process data, store in DB, etc.)
```

**SAX Parser Example in Java:**

```java
import org.xml.sax.*;
import org.xml.sax.helpers.DefaultHandler;
import javax.xml.parsers.*;

// Custom Handler extending DefaultHandler
class BookHandler extends DefaultHandler {
    private String currentElement;
    private String title;
    private String author;
    
    // Called when document parsing starts
    @Override
    public void startDocument() throws SAXException {
        System.out.println("Start parsing document...");
    }
    
    // Called when an opening tag is encountered
    @Override
    public void startElement(String uri, String localName, 
                           String qName, Attributes attributes) 
                           throws SAXException {
        currentElement = qName;
        
        // Access attributes
        if (qName.equals("book")) {
            String category = attributes.getValue("category");
            System.out.println("Book Category: " + category);
        }
    }
    
    // Called when text content is encountered
    @Override
    public void characters(char[] ch, int start, int length) 
                          throws SAXException {
        String content = new String(ch, start, length).trim();
        
        if (content.length() > 0) {
            if (currentElement.equals("title")) {
                title = content;
            } else if (currentElement.equals("author")) {
                author = content;
            }
        }
    }
    
    // Called when a closing tag is encountered
    @Override
    public void endElement(String uri, String localName, String qName) 
                          throws SAXException {
        if (qName.equals("book")) {
            System.out.println("Title: " + title);
            System.out.println("Author: " + author);
            System.out.println("---");
        }
        currentElement = "";
    }
    
    // Called when document parsing ends
    @Override
    public void endDocument() throws SAXException {
        System.out.println("Finished parsing document.");
    }
}

// Main class to use the parser
public class SAXParserExample {
    public static void main(String[] args) {
        try {
            // Create SAX parser factory
            SAXParserFactory factory = SAXParserFactory.newInstance();
            SAXParser saxParser = factory.newSAXParser();
            
            // Create handler instance
            BookHandler handler = new BookHandler();
            
            // Parse the XML file
            saxParser.parse("books.xml", handler);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

## SAX Memory Usage Visualization

```
┌─────────────────────────────────────────────────────────────┐
│              MEMORY USAGE: SAX vs DOM                       │
└─────────────────────────────────────────────────────────────┘

SAX Parser (Event-driven, Streaming)
────────────────────────────────────

Memory: [█░░░░░░░░░] 10%  ← Minimal memory usage
         │
         └─> Processes one element at a time
             Discards data after processing
             

DOM Parser (Tree-based, In-memory)
──────────────────────────────────

Memory: [██████████] 100%  ← Entire document in memory
         │
         └─> Loads complete tree structure
             All data retained until processing complete


For a 100MB XML file:
─────────────────────
SAX:  ~5-10MB memory usage
DOM:  ~300-400MB memory usage (3-4x file size)
```

## When to Use SAX

```
┌─────────────────────────────────────────────────────────────┐
│                  WHEN TO USE SAX                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✓ USE SAX WHEN:                                            │
│    • Processing very large XML files (GBs)                  │
│    • Memory is limited                                      │
│    • You need fast, sequential processing                   │
│    • You only need to extract specific data                 │
│    • Reading data once (no need to revisit)                 │
│    • Streaming data from network                            │
│                                                             │
│  ✗ DON'T USE SAX WHEN:                                      │
│    • Need random access to XML elements                     │
│    • Need to modify XML structure                           │
│    • XML file is small and fits in memory                   │
│    • Complex navigation required                            │
│    • Need to access parent/sibling elements                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## SAX Error Handling Example

```java
class BookHandler extends DefaultHandler {
    
    @Override
    public void warning(SAXParseException e) throws SAXException {
        System.out.println("WARNING: " + e.getMessage());
    }
    
    @Override
    public void error(SAXParseException e) throws SAXException {
        System.out.println("ERROR: " + e.getMessage());
        throw e; // Can continue parsing
    }
    
    @Override
    public void fatalError(SAXParseException e) throws SAXException {
        System.out.println("FATAL ERROR: " + e.getMessage());
        throw e; // Cannot continue parsing
    }
}
```