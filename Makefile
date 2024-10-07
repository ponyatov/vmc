# var
MODULE = $(notdir $(CURDIR))

# tool
CURL = curl -L -o
CF   = clang-format -style=file -i

# src
C += $(wildcard meta/src/*.c*)
H += $(wildcard meta/inc/*.h*)
S += lib/$(MODULE).ini $(wildcard lib/*.s)
M += $(wildcard src/lib/*.ml) $(wildcard src/bin/*.ml)
D += $(wildcard dune*) $(wildcard src/lib/dune*) $(wildcard src/bin/dune*)

# cfg
CFLAGS += -O0 -ggdb -Iinc -Itmp

# all
.PHONY: all run
all: $(M) $(D) $(S)
	dune build src/bin/$(MODULE).exe
run: $(M) $(D) $(S)
	dune exec src/bin/cpp.exe $(S)

.PHONY: utop
utop: $(M) $(D) $(S)
	dune $@

.PHONY: cpp
cpp:
	$(MAKE) -C meta run

# test
.PHONY: test
test: $(M) $(D) $(S)
	dune $@

# format
.PHONY: format
format: tmp/format_ml tmp/format_cpp
tmp/format_ml: $(M) $(D) .ocamlformat
	dune fmt ; touch $@
tmp/format_cpp: $(C) $(H)
	$(CF) $^ && touch $@

.ocamlformat:
	echo "version=`ocamlformat --version`" > $@
	echo "profile=default"                >> $@
	echo "margin=80"                      >> $@
	echo "line-endings=lf"                >> $@
	echo "break-cases=all"                >> $@
	echo "wrap-comments=true"             >> $@

# rule
bin/$(MODULE): $(C) $(H)
	$(CXX) $(CFLAGS) -o $@ $(C) $(L)

# doc
.PHONY: doc
doc:

# install
.PHONY: install update ref gz
install: doc ref gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
	opam update
	opam install -y . --deps-only
ref:
gz:
