ISOBASEFILE  = debian-13.5.0-amd64-netinst.iso
ISOPRESEED   = preseed-$(ISOBASEFILE)
ISOLABEL     = DESKTOP
TESTVMDISK   = test-disk.qcow2
CDROM        = cdrom
INITRD       = initrd
INSTALLFILES = $(shell find $(CDROM) -type f -not -name Makefile -not -name .gitignore)

build: $(ISOPRESEED)
include $(shell find . -mindepth 2 -name Makefile)

.INTERMEDIATE: .xorrisorc
.xorrisorc: $(INITRD)/initrd.gz $(INSTALLFILES)
	@echo "-indev $(ISOBASEFILE)" > $@
	@echo "-outdev $(ISOPRESEED)" >> $@
	@echo "-map $< /install.amd/gtk/initrd.gz" >> $@
	@$(foreach l, $(filter-out $<, $^), \
	    echo "-map $(l) $(patsubst $(CDROM)/%,/%,$(l))" >> $@;)
	@echo "-volid $(ISOLABEL)" >> $@
	@echo "-boot_image any replay" >> $@
	@echo "-compliance no_emul_toc" >> $@

$(ISOPRESEED): .xorrisorc
	rm -f $(ISOPRESEED)
	xorriso -no_rc -options_from_file $<

.PHONY: usb
usb:
	@test -n "$(DEVICE)" || (echo "Error: DEVICE is undefined. Usage: make DEVICE=/dev/sdX usb"; exit 1)
	@sudo lsblk $(DEVICE)
	@echo
	@echo -n "Are you sure you want to wipe $(DEVICE)? [y/N] " && read ans && [ $${ans:-N} = y ] || [ $${ans:-N} = Y ]
	@sudo dd if=$(ISOPRESEED) of=$(DEVICE) bs=4M status=progress oflag=sync

$(TESTVMDISK):
	qemu-img create -f qcow2 $@ 20G

.PHONY: test-boot
test-boot: OUTPUT ?= 1
test-boot: $(TESTVMDISK)
	qemu-system-x86_64 \
	    -enable-kvm -cpu host -smp 4 -m 1G \
	    -device virtio-net-pci,netdev=net0 \
	    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
	    -cdrom $(ISOPRESEED) \
	    -drive file=$(TESTVMDISK),format=qcow2,if=virtio,cache=unsafe
