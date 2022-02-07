.PHONY: test clean

test: messageParts
	./messageParts >/tmp/t01-parts
	diff /tmp/t01-parts good/t01-parts
	@echo "All tests passed."

messageParts: src/messageParts.c
	cc -o $@ $<

clean:
	@rm messageParts
