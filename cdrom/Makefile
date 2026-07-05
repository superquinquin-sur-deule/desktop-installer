SVGURL = https://www.superquinquin.fr/wp-content/themes/superquinquin/img/superquinquin_logo_deule.svg

$(CDROM)/isolinux/splash.png:
	magick -size 640x480 xc:white \( $(SVGURL) -resize 200x200 -trim \) \
	    -gravity Center -composite PNG8:$@

$(CDROM)/boot/grub/themes/splash.png:
	magick -size 320x320 xc:white \( $(SVGURL) -resize 320x320 -trim \) \
	    -gravity Center -composite PNG24:$@

$(CDROM)/boot/grub/themes/select.png:
	magick -size 1x1 xc:"#f6d443" PNG24:$@

# The selected entry background is rendered by GRUB using a **9-slice**
# mechanism: 9 PNG images of 1×1 pixel covering positions `c nw n ne w e sw s # se`.
# All tiles share the same gold color "#f6d443", producing a solid rectangle
# with no rounded corners.
GRUBTHEMEBG   = $(CDROM)/boot/grub/themes/bg
GRUBMAP       = c nw n ne w e sw s se
GRUBMAPFILES  = $(GRUBMAP:%=$(GRUBTHEMEBG)/select_%.png)
INSTALLFILES += $(GRUBMAPFILES)

.INTERMEDIATE: $(GRUBMAPFILES)
$(GRUBTHEMEBG)/select_%.png: $(CDROM)/boot/grub/themes/select.png
	@mkdir -p $(dir $@)
	cp $< $@
