#	from: @(#)bsd.subdir.mk	5.9 (Berkeley) 2/1/91
# $FreeBSD$
#
# The include file <bsd.port.subdir.mk> contains the default targets
# for building ports subdirectories. 
#
#
# +++ variables +++
#
# STRIP		The flag passed to the install program to cause the binary
#		to be stripped.  This is to be used when building your
#		own install script so that the entire system can be made
#		stripped/not-stripped using a single knob. [-s]
#
# ECHO_MSG	Used to print all the '===>' style prompts - override this
#		to turn them off [echo].
#
# OPSYS		Get the operating system type [`uname -s`]
#
# SUBDIR	A list of subdirectories that should be built as well.
#		Each of the targets will execute the same target in the
#		subdirectories.
#
#
# +++ targets +++
#
#	README.html:
#		Creating README.html for package.
#
#	afterinstall, all, beforeinstall, build, checksum, clean,
#	clean-for-cdrom, clean-restricted,
#	clean-for-cdrom-list, clean-restricted-list,
#	configure, deinstall,
#	depend, depends, describe, extract, fetch, fetch-list, ignorelist,
#	install, package, readmes, realinstall, reinstall, tags
#
#	search:
#		Search for ports using either 'make search key=<keyword>'
#		or 'make search name=<keyword>'.


.MAIN: all

.if !defined(DEBUG_FLAGS)
STRIP?=	-s
.endif

.if !defined(NOPRECIOUSMAKEVARS)
.if !defined(ARCH)
ARCH!=	/usr/bin/uname -m
.endif
.if !defined(OSREL)
OSREL!=	/usr/bin/uname -r | sed -e 's/[-(].*//'
.endif
.if !defined(OSVERSION)
.if exists(/sbin/sysctl)
OSVERSION!= /sbin/sysctl -n kern.osreldate
.else
OSVERSION!= /usr/sbin/sysctl -n kern.osreldate
.endif
.endif
.if !defined(PORTOBJFORMAT)
PORTOBJFORMAT!= test -x /usr/bin/objformat && /usr/bin/objformat || echo aout
.endif
.endif

.if !defined(OPSYS)
OPSYS!=	/usr/bin/uname -s
.endif

ECHO_MSG?=	echo

TARGETS+=	all
TARGETS+=	build
TARGETS+=	checksum
TARGETS+=	clean
TARGETS+=	clean-for-cdrom
TARGETS+=	clean-for-cdrom-list
TARGETS+=	clean-restricted
TARGETS+=	clean-restricted-list
TARGETS+=	configure
TARGETS+=	deinstall
TARGETS+=	depend
TARGETS+=	depends
TARGETS+=	describe
TARGETS+=	distclean
TARGETS+=	extract
TARGETS+=	fetch
TARGETS+=	fetch-list
TARGETS+=	ignorelist
TARGETS+=	package
TARGETS+=	realinstall
TARGETS+=	reinstall
TARGETS+=	tags

.for __target in ${TARGETS}
.if !target(${__target})
${__target}: ${SUBDIR:S/$/.${__target}/}
.endif
.endfor

.for __target in ${TARGETS} checksubdirs readmes
${SUBDIR:S/$/.${__target}/}: _SUBDIRUSE
.endfor

_SUBDIRUSE: .USE
	@OK=""; sub=${.TARGET:R}; \
	for dud in $$DUDS; do \
		if [ $${dud} = $$sub ]; then \
			OK="false"; \
			${ECHO_MSG} "===> ${DIRPRFX}$$sub skipped"; \
		fi; \
	done; \
	if test -d ${.CURDIR}/${.TARGET:R}.${MACHINE}; then \
		edir=$${sub}.${MACHINE}; \
	elif test -d ${.CURDIR}/$${sub}; then \
		edir=$${sub}; \
	else \
		OK="false"; \
		${ECHO_MSG} "===> ${DIRPRFX}$${sub} non-existent"; \
	fi; \
	if [ "$$OK" = "" ]; then \
		${ECHO_MSG} "===> ${DIRPRFX}$${edir}"; \
		cd ${.CURDIR}/$${edir}; \
		${MAKE} -B ${.TARGET:E:realinstall=install} \
			DIRPRFX=${DIRPRFX}$$edir/; \
	fi

${SUBDIR}:: ${SUBDIR:S/$/.all/}

.if !target(install)
.if !target(beforeinstall)
beforeinstall:
.endif
.if !target(afterinstall)
afterinstall:
.endif
install: afterinstall
afterinstall: realinstall
realinstall: beforeinstall ${SUBDIR:S/$/.realinstall/}
.endif

IGNOREDIR=	CVS Mk Templates Tools distfiles packages pkg

.if !target(checksubdirs)
.if defined(PORTSTOP)
checksubdirs: checksubdir ${SUBDIR:S/$/.checksubdirs/}
.else
checksubdirs: checksubdir
.endif
.endif

.if !target(checksubdir)
checksubdir:
	@for d in *; do \
	  if [ -d "$$d" ]; then \
	    found=0; \
	    for s in ${SUBDIR} ${IGNOREDIR}; do \
	      if [ "x$$s" = "x$$d" ]; then \
	        found=1; \
	        break; \
	      fi; \
	    done; \
	    if [ $$found = 0 ]; then \
	      ${ECHO} "Warning: directory $$d not in SUBDIR"; \
	    fi; \
	  fi; \
	done
	@for s in ${SUBDIR}; do \
	  if ! [ -d ${.CURDIR}/$$s ]; then \
	    ${ECHO} "Warning: directory $$s in SUBDIR does not exist"; \
	  fi \
	done
.endif

.if !target(readmes)
readmes: readme ${SUBDIR:S/$/.readmes/}
.endif

.if !target(readme)
readme:
	@rm -f README.html
	@make README.html
.endif

.if (${OPSYS} == "NetBSD")
PORTSDIR ?= /usr/opt
.else
PORTSDIR ?= /usr/ports
.endif
TEMPLATES ?= ${PORTSDIR}/Templates
.if defined(PORTSTOP)
README=	${TEMPLATES}/README.top
.else
README=	${TEMPLATES}/README.category
.endif

HTMLIFY=	sed -e 's/&/\&amp;/g' -e 's/>/\&gt;/g' -e 's/</\&lt;/g'

package-name:
	@echo ${.CURDIR} | sed -e 's^.*/^^'

README.html:
	@echo "===>  Creating README.html"
	@> $@.tmp
.for entry in ${SUBDIR}
.if defined(PORTSTOP)
	@echo -n '<a href="'${entry}/README.html'">'"`echo ${entry} | ${HTMLIFY}`"'</a>: ' >> $@.tmp
.else
	@echo -n '<a href="'${entry}/README.html'">'"`cd ${entry}; make package-name | ${HTMLIFY}`</a>: " >> $@.tmp
.endif
.if exists(${entry}/pkg/COMMENT)
	@${HTMLIFY} ${entry}/pkg/COMMENT >> $@.tmp
.else
	@echo "(no description)" >> $@.tmp
.endif
.endfor
	@sort -t '>' +1 -2 $@.tmp > $@.tmp2
.if exists(${.CURDIR}/pkg/DESCR)
	@${HTMLIFY} ${.CURDIR}/pkg/DESCR > $@.tmp3
.else
	@> $@.tmp3
.endif
	@cat ${README} | \
		sed -e 's/%%CATEGORY%%/'"`basename ${.CURDIR}`"'/g' \
			-e '/%%DESCR%%/r$@.tmp3' \
			-e '/%%DESCR%%/d' \
			-e '/%%SUBDIR%%/r$@.tmp2' \
			-e '/%%SUBDIR%%/d' \
		> $@
	@rm -f $@.tmp $@.tmp2 $@.tmp3

.if !defined(NOPRECIOUSMAKEVARS)
.MAKEFLAGS: \
	ARCH="${ARCH:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}" \
	OPSYS="${OPSYS:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}" \
	OSREL="${OSREL:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}" \
	OSVERSION="${OSVERSION:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}" \
	PORTOBJFORMAT="${PORTOBJFORMAT:S/"/"'"'"/g:S/\$/\$\$/g:S/\\/\\\\/g}"
.endif



search: ${PORTSDIR}/INDEX
	@here=`pwd`; \
	cd ${PORTSDIR}; \
	top=`pwd`; \
	there=`echo "$$here/" | sed s%$$top%${PORTSDIR}%`; \
	if [ $$key ]; then \
	  grep $$there ${PORTSDIR}/INDEX | grep -i "${key}" | awk -F\| '{ printf("Port:\t%s\nPath:\t%s\nInfo:\t%s\nMaint:\t%s\nIndex:\t%s\nB-deps:\t%s\nR-deps:\t%s\n\n", $$1, $$2, $$4, $$6, $$7, $$8, $$9); }'; \
	elif [ $$name ]; then \
	  grep $$there ${PORTSDIR}/INDEX | grep -i "^[^|]*${name}[^|]*|" | awk -F\| '{ printf("Port:\t%s\nPath:\t%s\nInfo:\t%s\nMaint:\t%s\nIndex:\t%s\nB-deps:\t%s\nR-deps:\t%s\n\n", $$1, $$2, $$4, $$6, $$7, $$8, $$9); }'; \
	else \
	  echo "The search target requires a keyword parameter or name parameter,"; \
	  echo "e.g.: \"make search key=somekeyword\""; \
	  echo "or    \"make search name=somekeyword\""; \
	fi;
