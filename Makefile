################################################################################
#   Copyright (c) 2010-2011 Bryce Lelbach
#
#   Distributed under the Boost Software License, Version 1.0.
#   Full text: http://www.boost.org/LICENSE_1_0.txt.
################################################################################

SHELL=/bin/sh

ifndef LINUXDIR
  RUNNING_REL := $(shell uname -r)

  LINUXDIR := $(shell if [ -e /lib/modules/$(RUNNING_REL)/source ]; then \
		 echo /lib/modules/$(RUNNING_REL)/source; \
		 else echo /lib/modules/$(RUNNING_REL)/build; fi)
endif

obj-m             += wl.o

wl-objs           := src/linux_osl.o src/wl_linux.o src/wl_iw.o

EXTRA_CFLAGS      := -I$(M)/include

ifeq ($(CONFIG_X86_64),y)
  EXTRA_LDFLAGS   := $(M)/bin/wlc_hybrid.x86_64.bin
else
  EXTRA_LDFLAGS   := $(M)/bin/wlc_hybrid.x86_32.bin
endif

all:
	KBUILD_NOPEDANTIC=1 make -C $(LINUXDIR) M=`pwd` O=$(O) modules

clean:
	KBUILD_NOPEDANTIC=1 make -C $(LINUXDIR) M=`pwd` O=$(O) clean

install:
	KBUILD_NOPEDANTIC=1 make -C $(LINUXDIR) M=`pwd` O=$(O) modules_install

