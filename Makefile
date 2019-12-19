.PHONY: all pack run
all:    
	alex Lexer.x
	happy Parser.y
	make main
ake main

pack:
	zip ZIP -r Main.hs Parser.y Grammar.hs Lexer.x Makefile

run:
	./Main

main:
	ghc Main.hs -O3 -o Main

