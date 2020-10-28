RTS =
TARGET =
GPRBUILD  = gprbuild
GPRCLEAN = gprclean
GPRINSTALL = gprinstall

INSTALL:=$(shell exec=`which gprbuild`;if [ ! -x "$$exec" ]; then unset exec;fi;echo $$exec | sed -e 's/\/bin\/$(GPRBUILD).*//')

ifeq ($(RTS),)
   RTS=full
   RTS_CONF =
else
   RTS_CONF = --RTS=$(RTS)
endif

ifeq ($(TARGET),)
   TARGET=native
   TARGET_CONF =
else
   TARGET_CONF = --target=$(TARGET)
endif

MODE = Install

CONF_ARGS = $(TARGET_CONF) $(RTS_CONF)

GPROPTS = $(CONF_ARGS) -XAUNIT_BUILD_MODE=$(MODE) -XAUNIT_RUNTIME=$(RTS) \
		-XAUNIT_PLATFORM=$(TARGET)

.PHONY: all clean targets install_clean install examples

all:
	$(GPRBUILD) -p $(GPROPTS) lib/gnat/aunit.gpr

examples:
	$(GPRBUILD) -p $(GPROPTS) examples/liskov/tested_lib/testlib.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/liskov/harness.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/test_fixture/tested_lib/testlib.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/test_fixture/harness.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/test_caller/tested_lib/testlib.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/test_caller/harness/harness.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/failures/tested_lib/testlib.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/failures/harness.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/calculator/tested_lib/testlib.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/calculator/harness.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/simple_test/tested_lib/testlib.gpr
	$(GPRBUILD) -p $(GPROPTS) examples/simple_test/harness.gpr

clean-lib:
	$(RM) -fr lib/aunit lib/aunit-obj

clean: clean-lib
	-${MAKE} -C docs clean

install-clean-legacy:
ifneq (,$(wildcard $(INSTALL)/lib/gnat/manifests/aunit))
	-$(GPRINSTALL) $(GPROPTS) --uninstall --prefix=$(INSTALL) \
		--project-subdir=lib/gnat aunit
endif

install-clean: install-clean-legacy
ifneq (,$(wildcard $(INSTALL)/share/gpr/manifests/aunit))
	-$(GPRINSTALL) $(GPROPTS) --uninstall --prefix=$(INSTALL) aunit
endif

install: install-clean
	$(GPRINSTALL) $(GPROPTS) -p -f --prefix=$(INSTALL) \
		--no-build-var lib/gnat/aunit.gpr

.PHONY: doc
doc:
	${MAKE} -C doc

RM	= rm
