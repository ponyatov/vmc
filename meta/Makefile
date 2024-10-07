# var
MODULE ?= meta

# dir
CWD = $(CURDIR)

# tool
CURL = curl -L -o
CF   = clang-format -style=file -i

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)
S += lib/$(MODULE).ini $(wildcard lib/*.s)

# cfg
CFLAGS += -O0 -ggdb -Iinc -Itmp

# all
.PHONY: all run
all: bin/$(MODULE) $(S)
run: bin/$(MODULE) $(S)
	$^

# format
.PHONY: format
format: tmp/format_cpp
tmp/format_cpp: $(C) $(H)
	$(CF) $^ && touch $@

# rule
bin/$(MODULE): $(C) $(H)
	$(CXX) $(CFLAGS) -o $@ $(C) $(L)

# doc
.PHONY: doc
doc:

.PHONY: doxy
doxy: .doxygen doc/DoxygenLayout.xml doc/logo.png
	rm -rf docs ; doxygen $< 2>/dev/null

doc/DoxygenLayout.xml:
	doxygen -l $@ && git add $@
doc/logo.png:
	cp ~/icons/triangle.png $@ && git add $@

# install
.PHONY: install update ref gz
install: doc ref gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
ref:
gz:
