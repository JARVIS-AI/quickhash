# Makefile for x64 Linux

PREFIX ?= /usr
BIN = quickhash
QHARCH ?= x64
LIBEWF = libewf-Linux-$(QHARCH).so

LAZARUSDIR ?= /usr/share/lazarus/2.0.12/
LAZBUILD := $(LAZARUSDIR)lazbuild
LAZRES := $(LAZARUSDIR)tools/lazres

RESFILES = dbases_sqlite.lrs frmaboutunit.lrs udisplaygrid.lrs unit2.lrs udisplaygrid3.lrs uenvironmentchecker.lrs

PACKAGES := HashLib4Pascal/src/Packages/FPC/HashLib4PascalPackage.lpk \
 DateTimePicker/zvdatetimectrls.lpk \
 $(LAZARUSDIR)components/dbexport/lazdbexport.lpk

# use a local temporary config directory to not register
# the used package(s) permanently and globally
OPTIONS ?= --pcp=lazarus_cfg --lazarusdir=$(LAZARUSDIR)

define \n


endef


all: $(BIN)

clean:
	rm -rf lazarus_cfg/ DateTimePicker/lib/ HashLib4Pascal/HashLib/src/Packages/FPC/lib/
	rm -f $(BIN) quickhash_linux.ico *.o *.or *.ppu *.res *.compiled
	rm -f DateTimePicker/zvdatetimectrls.pas HashLib4Pascal/HashLib/src/Packages/FPC/HashLib4PascalPackage.pas
	$(foreach FILE,$(RESFILES),\
	  test ! -f $(FILE).backup || mv -f $(FILE).backup $(FILE) ; ${\n})

distclean: clean

$(BIN):
	$(foreach FILE,$(RESFILES),\
	  test -f $(FILE).backup || cp $(FILE) $(FILE).backup ; ${\n}\
	  $(LAZRES) $(FILE) $(FILE:.lrs=.lfm) ; ${\n})
	cp -f quickhash.ico quickhash_linux.ico
	$(LAZBUILD) $(OPTIONS) $(PACKAGES) quickhash_linux.lpi

install:
	install -d -m 755 $(DESTDIR)$(PREFIX)/lib/quickhash/libs/$(QHARCH)
	install -m 644 libs/$(QHARCH)/$(LIBEWF) $(DESTDIR)$(PREFIX)/lib/quickhash/libs/$(QHARCH)
	install -m 755 $(BIN) $(DESTDIR)$(PREFIX)/lib/quickhash
	install -d -m 755 $(DESTDIR)$(PREFIX)/bin
	ln -s ../lib/quickhash/$(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)
	install -d -m 755 $(DESTDIR)$(PREFIX)/share/applications
	install -m 644 misc/quickhash.desktop $(DESTDIR)$(PREFIX)/share/applications
	$(foreach SIZE,16 24 32 48 64 96 128,\
	  install -d -m 755 $(DESTDIR)$(PREFIX)/share/icons/hicolor/$(SIZE)x$(SIZE)/apps ; ${\n}\
	  install -m 644 misc/quickhash_$(SIZE).png $(DESTDIR)$(PREFIX)/share/icons/hicolor/$(SIZE)x$(SIZE)/apps/quickhash.png ; ${\n})


