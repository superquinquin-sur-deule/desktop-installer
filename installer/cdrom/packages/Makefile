PKGDIR = $(INSTALLDIR)/cdrom/packages
SRC    = $(wildcard $(PKGDIR)/*.deb.src)
PKG    = $(SRC:.deb.src=.deb)

INSTALLFILES += $(PKG)
INSTALLFILES += $(PKGDIR)/Packages.gz $(PKGDIR)/Release

.INTERMEDIATE: $(PKG)
$(PKGDIR)/%.deb: $(PKGDIR)/%.deb.src
	cat $< | wget -i - -qO $@

.INTERMEDIATE: $(PKGDIR)/Packages.gz
$(PKGDIR)/Packages.gz: $(PKG)
	apt-ftparchive packages $(dir $@) | gzip -c9 > $@

.INTERMEDIATE: $(PKGDIR)/Release
$(PKGDIR)/Release: $(PKGDIR)/Packages.gz
	apt-ftparchive release $(dir $@) > $@
