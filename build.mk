# MIT License
#
# Copyright (c) 2020 rysiof@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

include make/utils.mk
include make/defs.mk

.PHONY: clean_%
clean_%:
	@echo Removing $(TARGET:clean_%=%) binary files.
	@rm -rf bin/$(TARGET:clean_%=%)/$(PLATFORM)/$(CFG)
	@rm -rf bin/$(TARGET:clean_%=%)/$(PLATFORM)
	@-rmdir bin/$(TARGET:clean_%=%) --ignore-fail-on-non-empty

-include make/platform/$(PLATFORM).mk

ifeq ($(QUIET),)
C := $(G_CC)
CPP := $(G_CPP)
CXX := $(G_CPP)
CC := $(G_CPP)
SRCDIRS = $(TOP)src/$(TARGET)
LD := $(G_LD)
else
C := @$(G_CC)
CC := @$(G_CPP)
CPP := @$(G_CPP)
CXX := @$(G_CPP)
LD := @$(G_LD)
endif

INCDIRS = $(foreach T,$(INCLUDE_DIRS), -I$(T))

COMPILE.c = $(C) $(CFLAGS) $(INCDIRS) -c
COMPILE.cc = $(CC) $(CCFLAGS) $(INCDIRS) -c
COMPILE.cpp = $(CPP) $(CPPFLAGS) $(INCDIRS) -c
COMPILE.cxx = $(CXX) $(CXXFLAGS) $(INCDIRS) -c

## This way we are scanning source tree once and then we are applying filters
## Effects noticable with huge source tree
SRC = $(call rwildcard, src/$(TARGET),$(COMPILE_FILES))

CC_SRC = $(filter %.cc,$(SRC))
CXX_SRC = $(filter %.cxx,$(SRC))
CPP_SRC = $(filter %.cpp,$(SRC))
C_SRC  = $(filter %.c,$(SRC))

CC_OBJ = $(CC_SRC:src/$(TARGET)/%.cc=$(OUTPUT_PATH)/%.o)
CXX_OBJ = $(CXX_SRC:src/$(TARGET)/%.cxx=$(OUTPUT_PATH)/%.o)
CPP_OBJ = $(CPP_SRC:src/$(TARGET)/%.cpp=$(OUTPUT_PATH)/%.o)
C_OBJ  = $(C_SRC:src/$(TARGET)/%.c=$(OUTPUT_PATH)/%.o)

OBJ    = $(C_OBJ) $(CC_OBJ) $(CXX_OBJ) $(CPP_OBJ)
DEPS  := $(OBJ:.o=.d)

print_program_info:
	@echo Building target [$(TARGET)] for [$(PLATFORM)] using [$(CFG)] config.

$(OUTPUT_PATH)/%.o: src/$(TARGET)/%.cc
	@-mkdir -p $(dir $@)
	$(COMPILE.cc) $< -o $@ -MD -MF $(@:%.o=%.d)

$(OUTPUT_PATH)/%.o: src/$(TARGET)/%.cxx
	@-mkdir -p $(dir $@)
	$(COMPILE.cxx) $< -o $@ -MD -MF $(@:%.o=%.d)

$(OUTPUT_PATH)/%.o: src/$(TARGET)/%.cpp
	@-mkdir -p $(dir $@)
	$(COMPILE.cpp) $< -o $@ -MD -MF $(@:%.o=%.d)

$(OUTPUT_PATH)/%.o: src/$(TARGET)/%.c
	@-mkdir -p $(dir $@)
	$(COMPILE.c) $< -o $@ -MD -MF $(@:%.o=%.d)

include make/target/$(TARGET).mk
-include $(DEPS)
