# compiler
CXX	:= clang++
CC	:= clang

CBASEFLAGS	:= -MMD -MP -O2
CBASEFLAGS	+= -Wall -Wshadow -Werror
CBASEFLAGS	+= -Iinclude -I./deps/scl/libscl/include

CFLAGS := $(CBASEFLAGS)

CXXFLAGS := -std=c++23
CXXFLAGS += $(CBASEFLAGS)
CXXFLAGS += -Wnull-dereference

#LDFLAGS	:= -lfreeimage -lz
LDFLAGS := -L./deps/scl/libscl/bin
LDFLAGS	+= -lz -ltinyxml -lscl
LIBSCL_A := ./deps/scl/libscl/bin/libscl.a

# output --------------------------------------------------------------------@/
OBJ_DIR := build
SRC_DIR := source
OUTPUT  := bin/aya.exe

SRCS_CPP	:= $(shell find $(SRC_DIR) -name *.cpp)
SRCS_C		:= $(shell find $(SRC_DIR) -name *.c)

OBJS := $(subst $(SRC_DIR),$(OBJ_DIR),$(SRCS_CPP:.cpp=.o))
OBJS += $(subst $(SRC_DIR),$(OBJ_DIR),$(SRCS_C:.c=.o))
DEPS := $(OBJS:.o=.d)

-include $(DEPS)

all: $(LIBSCL_A) .WAIT $(OUTPUT)

# building ------------------------------------------------------------------@/
$(OUTPUT): $(OBJS)
	$(CXX) $^ -o $@ $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	ccache $(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	ccache $(CXX) $(CXXFLAGS) -c $< -o $@

$(LIBSCL_A):
	make -C deps/scl

clean:
	rm -rf build/*.o build/*.d $(OUTPUT)
clean_bin:
	rm -rf $(OUTPUT)

rebuild: clean .WAIT all
soft_rebuild: clean_bin .WAIT all

