# var
MODULE ?= meta

# dir
CWD = $(CURDIR)

# tool
CURL = curl -L -o
CF   = clang-format -type=file -i

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)

# cfg
CFLAGS += -O0 -ggdb -Iinc -Itmp

# all
.PHONY: all run
all: bin/$(MODULE) inc/$(MODULE).ini
run: bin/$(MODULE) inc/$(MODULE).ini
	$^

# format

# rule
bin/$(MODULE): $(C) $(H)
	$(CXX) $(CFLAGS) -o $@ $(C) $(L) && $(SIZE) $@

# install
