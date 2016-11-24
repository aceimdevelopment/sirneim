
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
topdir = /home/aceimdiplomados/.rvm/rubies/ruby-1.8.7-p358/lib/ruby/1.8/x86_64-linux
hdrdir = $(topdir)
VPATH = $(srcdir):$(topdir):$(hdrdir)
exec_prefix = $(prefix)
prefix = $(DESTDIR)/home/aceimdiplomados/.rvm/rubies/ruby-1.8.7-p358
sitelibdir = $(sitedir)/$(ruby_version)
includedir = $(prefix)/include
sharedstatedir = $(prefix)/com
localedir = $(datarootdir)/locale
sbindir = $(exec_prefix)/sbin
dvidir = $(docdir)
sysconfdir = $(prefix)/etc
infodir = $(datarootdir)/info
rubylibdir = $(libdir)/ruby/$(ruby_version)
oldincludedir = $(DESTDIR)/usr/include
docdir = $(datarootdir)/doc/$(PACKAGE)
sitearchdir = $(sitelibdir)/$(sitearch)
htmldir = $(docdir)
archdir = $(rubylibdir)/$(arch)
vendordir = $(libdir)/ruby/vendor_ruby
pdfdir = $(docdir)
mandir = $(datarootdir)/man
localstatedir = $(prefix)/var
libdir = $(exec_prefix)/lib
sitedir = $(libdir)/ruby/site_ruby
libexecdir = $(exec_prefix)/libexec
datadir = $(datarootdir)
datarootdir = $(prefix)/share
vendorarchdir = $(vendorlibdir)/$(sitearch)
psdir = $(docdir)
bindir = $(exec_prefix)/bin
vendorlibdir = $(vendordir)/$(ruby_version)

CC = gcc
LIBRUBY = $(LIBRUBY_SO)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -Wl,-R -Wl,$(libdir) -L$(libdir) -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)-static

RUBY_EXTCONF_H = 
CFLAGS   =  -fPIC -g -O2  -fPIC $(cflags) 
INCFLAGS = -I. -I/home/aceimdiplomados/aceim_diplomados/vendor/bundle/ruby/1.8/gems/libv8-3.11.8.17-x86_64-linux/vendor/v8/include -I. -I/home/aceimdiplomados/.rvm/rubies/ruby-1.8.7-p358/lib/ruby/1.8/x86_64-linux -I.
DEFS     = 
CPPFLAGS =     -Wall -g -rdynamic
CXXFLAGS = $(CFLAGS) 
ldflags  = /home/aceimdiplomados/aceim_diplomados/vendor/bundle/ruby/1.8/gems/libv8-3.11.8.17-x86_64-linux/vendor/v8/out/x64.release/obj.target/tools/gyp/libv8_base.a /home/aceimdiplomados/aceim_diplomados/vendor/bundle/ruby/1.8/gems/libv8-3.11.8.17-x86_64-linux/vendor/v8/out/x64.release/obj.target/tools/gyp/libv8_snapshot.a -L.  -rdynamic -Wl,-export-dynamic
dldflags = 
archflag = 
DLDFLAGS = $(ldflags) $(dldflags) $(archflag)
LDSHARED = $(CXX) -shared
AR = ar
EXEEXT = 

RUBY_INSTALL_NAME = ruby
RUBY_SO_NAME = ruby
arch = x86_64-linux
sitearch = x86_64-linux
ruby_version = 1.8
ruby = /home/aceimdiplomados/.rvm/rubies/ruby-1.8.7-p358/bin/ruby
RUBY = $(ruby)
RM = rm -f
MAKEDIRS = mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp

#### End of system configuration section. ####

preload = 

libpath = . $(libdir)
LIBPATH =  -L. -L$(libdir) -Wl,-R$(libdir)
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 

extout = 
extout_prefix = 
target_prefix = /v8
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED) -lpthread  -lrt -ldl -lcrypt -lm   -lc
SRCS = date.cc script.cc array.cc stack.cc init.cc backref.cc rr.cc template.cc handles.cc invocation.cc v8.cc accessor.cc signature.cc string.cc locker.cc value.cc exception.cc constants.cc function.cc primitive.cc context.cc heap.cc message.cc gc.cc constraints.cc trycatch.cc external.cc object.cc
OBJS = date.o script.o array.o stack.o init.o backref.o rr.o template.o handles.o invocation.o v8.o accessor.o signature.o string.o locker.o value.o exception.o constants.o function.o primitive.o context.o heap.o message.o gc.o constraints.o trycatch.o external.o object.o
TARGET = init
DLLIB = $(TARGET).so
EXTSTATIC = 
STATIC_LIB = 

BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR = /home/aceimdiplomados/aceim_diplomados/vendor/bundle/ruby/1.8/gems/therubyracer-0.11.4/lib$(target_prefix)
RUBYARCHDIR = /home/aceimdiplomados/aceim_diplomados/vendor/bundle/ruby/1.8/gems/therubyracer-0.11.4/lib$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).so $(TARGET).il? $(TARGET).tds $(TARGET).map
CLEANOBJS     = *.o *.a *.s[ol] *.pdb *.exp *.bak

all:		$(DLLIB)
static:		$(STATIC_LIB)

clean:
		@-$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES)

distclean:	clean
		@-$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		@-$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)

realclean:	distclean
install: install-so install-rb

install-so: $(RUBYARCHDIR)
install-so: $(RUBYARCHDIR)/$(DLLIB)
$(RUBYARCHDIR)/$(DLLIB): $(DLLIB)
	$(INSTALL_PROG) $(DLLIB) $(RUBYARCHDIR)
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
$(RUBYARCHDIR):
	$(MAKEDIRS) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .cxx .cpp .C .o

.cc.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.cxx.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.cpp.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.C.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $<

.c.o:
	$(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) -c $<

$(DLLIB): $(OBJS) Makefile
	@-$(RM) $@
	$(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)



$(OBJS): ruby.h defines.h
