PKGNAME ?= timeshift-autosnap-apt

.PHONY: install

install:
	@install -Dm644 -t "$(DESTDIR)/etc/apt/apt.conf.d/" 99-timeshift-autosnap
	@install -Dm755 -t "$(DESTDIR)/usr/bin/" timeshift-autosnap
	@install -Dm644 -t "$(LIB_DIR)/etc/" timeshift-autosnap.conf

uninstall:
	rm -f $(DESTDIR)/etc/apt/apt.conf.d/80-timeshift-autosnap
	rm -f $(DESTDIR)/usr/bin/timeshift-autosnap
	rm -f $(LIB_DIR)/etc/timeshift-autosnap.conf
