# $Id: Makefile,v 1.29 1997/03/06 05:52:26 asami Exp $
#

SUBDIR += archivers
SUBDIR += astro
SUBDIR += audio
SUBDIR += benchmarks
SUBDIR += cad
SUBDIR += chinese
SUBDIR += comms
SUBDIR += databases
SUBDIR += devel
SUBDIR += editors
SUBDIR += emulators
SUBDIR += games
SUBDIR += graphics
SUBDIR += japanese
SUBDIR += korean
SUBDIR += lang
SUBDIR += mail
SUBDIR += math
SUBDIR += mbone
SUBDIR += misc
SUBDIR += net
SUBDIR += news
SUBDIR += plan9
SUBDIR += print
SUBDIR += russian
SUBDIR += shells
SUBDIR += security
SUBDIR += sysutils
SUBDIR += vietnamese
SUBDIR += www
SUBDIR += x11

PORTSTOP=	yes

.include <bsd.port.subdir.mk>

index:
	@rm -f ${.CURDIR}/INDEX
	@make ${.CURDIR}/INDEX

${.CURDIR}/INDEX:
	@echo -n "Generating INDEX - please wait.."
	@make describe ECHO_MSG="echo > /dev/null" > ${.CURDIR}/INDEX
	@echo " Done."

print-index:	${.CURDIR}/INDEX
	@awk -F\| '{ printf("Port:\t%s\nPath:\t%s\nInfo:\t%s\nMaint:\t%s\nIndex:\t%s\nB-deps:\t%s\nR-deps:\t%s\n\n", $$1, $$2, $$4, $$6, $$7, $$8, $$9); }' < ${.CURDIR}/INDEX

search:	${.CURDIR}/INDEX
.if !defined(key)
	@echo "The search target requires a keyword parameter,"
	@echo "e.g.: \"make search key=somekeyword\""
.else
	@grep ${key} ${.CURDIR}/INDEX | awk -F\| '{ printf("Port:\t%s\nPath:\t%s\nInfo:\t%s\nMaint:\t%s\nIndex:\t%s\nB-deps:\t%s\nR-deps:\t%s\n\n", $$1, $$2, $$4, $$6, $$7, $$8, $$9); }'
.endif
