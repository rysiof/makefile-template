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

# Autodetect available targets
AVAILABLE_TARGETS_MAKEFILES = $(call rwildcard,make/target,*.mk)
AVAILABLE_TARGETS = $(foreach T, $(AVAILABLE_TARGETS_MAKEFILES),$(T:make/target/%.mk=%))
TARGET_LIST =$(foreach T, $(AVAILABLE_TARGETS),$(T) clean_$(T) run_$(T))


# Autodetect available platforms
AVAILABLE_PLATFORMS_MAKEFILES = $(call rwildcard,make/platform,*.mk)
PLATFORM_LIST = $(foreach T, $(AVAILABLE_PLATFORMS_MAKEFILES),$(T:make/platform/%.mk=%))

CFG_LIST = release debug
COMPILE_FILES = *.cc *.c *.cpp *.S *.s *.cxx

TOP = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

CFG ?= release
PLATFORM ?= x86

ifeq ($(CFG_LIST),$(filter-out $(CFG), $(CFG_LIST)))
$(error Config *$(CFG)* does not match.                                        \
	    Expected one of *$(CFG_LIST)*)
endif
ifeq ($(TARGET_LIST),$(filter-out $(MAKECMDGOALS), $(TARGET_LIST)))
$(error Target *$(MAKECMDGOALS)* does not match.                               \
  	    Expected one of *$(TARGET_LIST)*)
endif
ifeq ($(PLATFORM_LIST),$(filter-out $(PLATFORM), $(PLATFORM_LIST)))
$(error Platform *$(PLATFORM)* does not match.                               \
  	    Expected one of *$(PLATFORM_LIST)*)
endif

TARGET := $(MAKECMDGOALS)

OUTPUT_PATH = bin/$(TARGET)/$(PLATFORM)/$(CFG)
