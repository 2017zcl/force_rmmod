# ------------------------------------------------------------------------------
#
# Makefile for the LDD-LinuxDeviceDrivers.
#
# Author: gatieme
# Create: 2016-07-29 15:50:46
# Last modified: 2016-07-29 16:10:29
# Description:
# 	This program is loaded as a kernel(v2.6.18 or later) module.
# 	Use "make install" to load it into kernel.
# 	Use "make remove" to remove the module out of kernel.
#
# ------------------------------------------------------------------------------


ROOT=..
#PLATFORM=$(shell $(ROOT)/systype.sh)
#include $(ROOT)/Make.defines.$(PLATFORM)

#	my driver description
DRIVER_VERSION := "1.0.0"
DRIVER_AUTHOR  := "Gatieme @ AderStep Inc..."
DRIVER_DESC    := "Linux input module for Elo MultiTouch(MT) devices"
DRIVER_LICENSE := "Dual BSD/GPL"


MODULE_NAME := force_rmmod
#MODCFLAGS:=-O2 -Wall -DMODULE -D__KERNEL__ -DLINUX -std=c99
#EXTRA_CFLAGS  += $(MODULE_FLAGS) $(CFG_INC) $(CFG_INC)
EXTRA_CFLAGS  += -g -std=gnu99  -Wfatal-errors 



ifneq ($(KERNELRELEASE),) 	# kernelspace

obj-m := $(MODULE_NAME).o

else						# userspace


CURRENT_PATH ?= $(shell pwd)
LINUX_KERNEL ?= $(shell uname -r)
LINUX_KERNEL_PATH ?= /lib/modules/$(LINUX_KERNEL)/build

CURRENT_PATH := $(shell pwd)

modules:
	make -C $(LINUX_KERNEL_PATH) M=$(CURRENT_PATH) modules

modules_install:
	make -C $(LINUX_KERNEL_PATH) M=$(CURRENT_PATH) modules_install



insmod:
	sudo insmod $(MODULE_NAME).ko

reinsmod:
	sudo rmmod $(MODULE_NAME)
	sudo insmod $(MODULE_NAME).ko

github:
	cd $(ROOT) && make github

rmmod:
	sudo rmmod $(MODULE_NAME)

test :
	sudo ../injector/memInjector -l stack -m random -t word_0 --time 1 --timeout 3 -p 1

clean:
	make -C $(LINUX_KERNEL_PATH) M=$(CURRENT_PATH) clean
	rm -f modules.order Module.symvers Module.markers

.PHNOY:
	modules modules_install clean



endif
