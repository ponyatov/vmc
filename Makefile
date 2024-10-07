# var
MODULE = $(notdir $(CURDIR))

# tool
CURL = curl -L -o

# src
M += $(wildcard src/*.ml)
D += $(wildcard dune*) $(wildcard src/dune*)
S += lib/$(MODULE).ini $(wildcard lib/*.c)
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)

# cfg
CFLAGS += -O0 -ggdb -Iinc -Itmp

# all
.PHONY: all run
all: $(M) $(D) $(S)
	dune build src/$(MODULE).exe
run: $(M) $(D) $(S)
	dune exec src/$(MODULE).exe $(S)

.PHONY: utop
utop: $(M) $(D) $(S)
	dune $@

.PHONY: cpp
cpp: bin/$(MODULE) $(S)
	$^

# test
.PHONY: test
test: $(M) $(D) $(S)
	dune $@

# format
.PHONY: format
format: tmp/format_ml
tmp/format_ml: $(M) $(D) .ocamlformat
	dune fmt ; touch $@

.ocamlformat:
	echo "version=`ocamlformat --version`" > $@
	echo "profile=default"                >> $@
	echo "margin=80"                      >> $@
	echo "line-endings=lf"                >> $@
	echo "break-cases=all"                >> $@
	echo "wrap-comments=true"             >> $@

# rule
bin/$(MODULE): $(C) $(H) Makefile
	$(CXX) $(CFLAGS) -o $@ $(C) $(L)

# install
.PHONY: install update
install: doc ref gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
	opam update
	opam install -y . --deps-only
ref:
gz:
