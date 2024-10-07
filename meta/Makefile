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
S += lib/$(MODULE).ini $(wildcard lib/*.s)

# cfg
CFLAGS += -O0 -ggdb -Iinc -Itmp

# all
.PHONY: all run
all: bin/$(MODULE) $(S)
run: bin/$(MODULE) $(S)
	$^

# format

# rule
bin/$(MODULE): $(C) $(H)
	$(CXX) $(CFLAGS) -o $@ $(C) $(L) && $(SIZE) $@

# install
