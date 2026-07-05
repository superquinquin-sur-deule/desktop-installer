INITRDFILES  = $(shell find $(INITRD) -type f -not -name Makefile -not -name "*.gz")

.INTERMEDIATE: $(INITRD)/initrd.orig.gz
$(INITRD)/initrd.orig.gz: $(ISOBASEFILE)
	osirrox -indev $< -extract /install.amd/gtk/initrd.gz $@

.INTERMEDIATE: $(INITRD)/initrd.patch.gz
$(INITRD)/initrd.patch.gz: $(INITRDFILES)
	cd $(INITRD) && \
	    printf '%s\n' $(patsubst $(INITRD)/%,%,$^) \
	    | cpio -H newc -o | gzip -9 > $(CURDIR)/$@

.INTERMEDIATE: $(INITRD)/initrd.gz
$(INITRD)/initrd.gz: $(INITRD)/initrd.orig.gz $(INITRD)/initrd.patch.gz
	cat $^ > $@
