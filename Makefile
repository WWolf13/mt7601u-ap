RT28xx_MODE = AP
TARGET = LINUX
CHIPSET = 7601U
MODULE = $(word 1, $(CHIPSET))

#OS ABL - YES or NO
OSABL = NO

SRC_DIR = $(shell pwd)
LINUX_VER = $(shell uname -r)
LINUX_SRC = /lib/modules/$(LINUX_VER)/build
LINUX_SRC_MODULE = /lib/modules/$(LINUX_VER)/kernel/drivers/net/wireless

include $(SRC_DIR)/os/linux/config.mk

RELEASE = DPA
MAKE = make

export OSABL SRC_DIR RT28xx_MODE LINUX_SRC CROSS_COMPILE CROSS_COMPILE_INCLUDE RELEASE CHIPSET MODULE LINUX_SRC_MODULE TARGET HAS_WOW_SUPPORT

PHONY = all build_tools release clean uninstall install

all: build_tools $(TARGET)

build_tools:
	@$(MAKE) -C tools
	@mkdir $(SRC_DIR)/include/mcu
	$(SRC_DIR)/tools/bin2h

LINUX:
	@cp os/linux/Makefile.6 $(SRC_DIR)/os/linux/Makefile
	$(MAKE) -C $(LINUX_SRC) M=$(SRC_DIR)/os/linux modules

release: build_tools
	$(MAKE) -C $(SRC_DIR)/striptool -f Makefile.release clean
	$(MAKE) -C $(SRC_DIR)/striptool -f Makefile.release
	striptool/striptool.out
ifeq ($(RELEASE), DPO)
	gcc -o striptool/banner striptool/banner.c
	striptool/banner -b striptool/copyright.gpl -s DPO/ -d DPO_GPL -R
	striptool/banner -b striptool/copyright.frm -s DPO_GPL/include/firmware.h
endif

clean:
	$(MAKE) -C $(SRC_DIR)/os/linux -f Makefile.6 clean

strip:
	@$(MAKE) -C $(SRC_DIR)/os/linux strip

uninstall:
	$(MAKE) -C $(SRC_DIR)/os/linux uninstall

install:
	$(MAKE) -C $(SRC_DIR)/os/linux install

.PHONY: $(PHONY)
