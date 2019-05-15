ANTLR_PATH=/usr/local/lib/antlr-4.7.2-complete.jar
ANTLR_TEST=org.antlr.v4.gui.TestRig
ANTLR_OPTION=-visitor -no-listener
PROG=Kotlin
ROOT=prog

all:
	java -jar $(ANTLR_PATH) $(PROG).g4 $(ANTLR_OPTION)
	javac $(PROG)*.java
	java $(PROG)Recognizer

grammer:
	java -jar $(ANTLR_PATH) $(PROG).g4 $(ANTLR_OPTION)

$(ROOT):
	javac $(PROG)*.java
	java $(PROG)Recognizer

grun:
	java -jar $(ANTLR_PATH) $(PROG).g4 $(ANTLR_OPTION)
	javac $(PROG)*.java
	java $(ANTLR_TEST) $(PROG) $(ROOT) -gui

clean:
	rm -rf .antlr
	rm -f *.interp *.tokens *.class
	rm -f $(PROG)BaseVisitor.java $(PROG)Lexer.java $(PROG)Visitor.java $(PROG)Parser.java
