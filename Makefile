# Makefile for webscratch.
#
# Unfortunately there is a step in the build process that requires a human
# being to click on something. See README.txt.

BUILD_DIR=build

JS ?= js
PYTHON ?= python
SQUEAK ?= /Applications/Scratch 1.4/Scratch.app/Contents/MacOS/Scratch

ANY_SCRATCH_PLUGIN_SRC_FILE = $(BUILD_DIR)/sources/ScratchPluginSrc1.4/CameraPlugin-linux/build.sh
ANY_SCRATCH_SOURCE_FILE = $(BUILD_DIR)/sources/ScratchSource1.4/License.txt
ANY_SCRATCH_SKIN_FILE = $(BUILD_DIR)/sources/ScratchSkin/pen.gif

CLASSES_RAW = $(BUILD_DIR)/sources/ScratchSource1.4/ScratchSources.st
HEAP_RAW = $(BUILD_DIR)/sources/ScratchSource1.4/objectdump.txt

CLASSES_UTF8 = $(BUILD_DIR)/sources/ScratchSource1.4/ScratchSources.st.utf8
HEAP_UTF8 = $(BUILD_DIR)/sources/ScratchSource1.4/objectdump.txt.utf8

COMPILER_SOURCES = \
  js/BigInt.js \
  js/ast.js \
  js/bind.js \
  js/compile.js \
  js/deadcode.js \
  js/main.js \
  js/parse.js \
  js/smalltalk.js \
  $(NULL)

.PHONY: all
all: $(BUILD_DIR)/ScratchSources.js check

$(ANY_SCRATCH_PLUGIN_SRC_FILE): original-sources/ScratchPluginSrc1.4.zip
	mkdir -p $(BUILD_DIR)/sources
	cd $(BUILD_DIR)/sources && rm -rf ScratchPluginSrc1.4
	cd $(BUILD_DIR)/sources && unzip ../../original-sources/ScratchPluginSrc1.4.zip

$(ANY_SCRATCH_SOURCE_FILE): original-sources/ScratchSource1.4.zip
	mkdir -p $(BUILD_DIR)/sources
	cd $(BUILD_DIR)/sources && rm -rf ScratchSource1.4
	cd $(BUILD_DIR)/sources && unzip ../../original-sources/ScratchSource1.4.zip

$(ANY_SCRATCH_SKIN_FILE): original-sources/ScratchSkin1.4.zip
	mkdir -p $(BUILD_DIR)/sources
	cd $(BUILD_DIR)/sources && rm -rf ScratchSkin
	cd $(BUILD_DIR)/sources && unzip ../../original-sources/ScratchSkin1.4.zip

$(CLASSES_RAW) $(HEAP_RAW): $(ANY_SCRATCH_SOURCE_FILE)
	@if [ "$(GO)" == "" ]; then \
	    echo "*** ERROR: You must say the magic word. See the README."; exit 1; fi
	rm -f $^
	cd $(BUILD_DIR)/sources/ScratchSource1.4 && \
	    "$(SQUEAK)" $(abspath $(BUILD_DIR)/sources/ScratchSource1.4/ScratchSourceCode1.4.image)
	@if [ ! -f $(CLASSES_RAW) -o ! -f $(HEAP_RAW) ]; then \
	    echo "*** ERROR: The files were not created. See the README."; exit 1; fi

# Mozilla's JS engine can only read UTF-8 files, not binary. But Squeak
# Smalltalk source files are really 8-bit; they may contain strings with
# non-ASCII bytes which should be retained.
#
# Solution: a horrible horrible hack. Treat the 8-bit binary data as if it
# were Latin-1 data. Then UTF-8-encode it.
#
# Queasymaking. Just ignore it. It works.
#
$(CLASSES_UTF8): $(CLASSES_RAW)
	$(PYTHON) recode.py $^ $@

$(HEAP_UTF8): $(HEAP_RAW)
	$(PYTHON) recode.py $^ $@

$(BUILD_DIR)/ScratchSources.js: $(COMPILER_SOURCES) $(CLASSES_UTF8) $(HEAP_UTF8)
	cd js && $(JS) main.js ../$(CLASSES_UTF8) ../$(HEAP_UTF8) > ../$(BUILD_DIR)/ScratchSources.js

.PHONY: distclean
distclean:
	rm -rf $(BUILD_DIR)

.PHONY: check check-unit check-slow
check: check-unit check-slow

check-unit:
	cd js/tests && $(JS) unit.js

check-slow:
	cd js/tests && $(JS) handmade-test.js

# Technically, `make repl` should depend on $(BUILD_DIR)/ScratchSources.js, but
# it is too cumbersome in practice.
.PHONY: repl
repl:
	cd js/tests && $(JS) repl.js

