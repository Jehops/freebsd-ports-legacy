#-*- tab-width: 4; -*-
# $FreeBSD$
# Global options
#

##
# Set all the options available for the ports, beginning with the
# global ones and ending with the ones decided by the maintainer.
# Options global to the entire ports tree

OPTIONSFILE?=	${PORT_DBDIR}/${UNIQUENAME}/options

#ALL_OPTIONS=	DOCS \
#		NLS

# Set the default values for the global options, as defined by portmgr
PORT_OPTIONS+=	NLS \
		DOCS

# Append options set by the port Makefile
.for opt in ${OPTIONS_DEFINE}
ALL_OPTIONS+=	${opt}
.endfor

ALL_OPTIONS:=	${ALL_OPTIONS:O:u}

# Remove global options the port maintainer doesn't want
.for opt in ${OPTIONS_EXCLUDE}
ALL_OPTIONS:=	${ALL_OPTIONS:N${opt}}
.endfor

#XXX  to kill when old option framework won't be used anymore
.if defined(OPTIONS)
.  undef optname
.  for O in ${OPTIONS:S|\#|\\\#|g}
opt:=	${O}
.    if !defined(optname)
optname:=	${O}
ALL_OPTIONS+=	${O}
PORT_OPTIONS+=	${O}
.    elif !defined(optdesc)
optdesc:=	${opt}
${optname}_DESC:=	${opt}
.    else
.      if ${opt:L} == off
.        if defined(PORT_OPTIONS) && defined(optname)
NO_OPTIONS+=	${optname}
NO_OPTIONS:=	${NO_OPTIONS:O:u}
.        else
.        endif
.      endif
.      undef optname
.      undef optdesc
.    endif
.  endfor
.  if defined(NO_OPTIONS)
.    for O in ${NO_OPTIONS}
PORT_OPTIONS:=	 ${PORT_OPTIONS:N${O}}
.    endfor
.  endif
#.  undef NO_OPTIONS
.endif
#XXX end of compatibility

ALL_OPTIONS:=	${ALL_OPTIONS:O:u}

## Now create the list of activated options
.if defined(OPTIONS_OVERRIDE)
# Special case $OPTIONS_OVERRIDE; if it is defined forget about anything done
# before
PORT_OPTIONS:=	${OPTIONS_OVERRIDE}
.else

## Set default options defined by the port maintainer
.  for opt in ${OPTIONS_DEFAULT}
PORT_OPTIONS+=	${opt}
.  endfor
PORT_OPTIONS:=	${PORT_OPTIONS:O:u}

## Set system-wide defined options (set by user in make.conf)
.  for opt in ${OPTIONS_SET}
PORT_OPTIONS+=	${opt}
.  endfor
PORT_OPTIONS:=	${PORT_OPTIONS:O:u}

## Remove the options excluded system-wide (set by user in make.conf)
.  for opt in ${OPTIONS_UNSET}
PORT_OPTIONS:=	${PORT_OPTIONS:N${opt}}
.  endfor

## Set the options specified per-port (set by user in make.conf)
.  for opt in ${${UNIQUENAME:U}_SET}
PORT_OPTIONS+=	${opt}
.  endfor
PORT_OPTIONS:=	${PORT_OPTIONS:O:u}

## Unset the options excluded per-port (set by user in make.conf)
.  for opt in ${${UNIQUENAME:U}_UNSET}
PORT_OPTIONS:=	${PORT_OPTIONS:N${opt}}
.  endfor

## options files (from dialog)
.  if exists(${OPTIONSFILE}) && !make(rmconfig)
.  include "${OPTIONSFILE}"
.  endif
.  if exists(${OPTIONSFILE}.local)
.  include "${OPTIONSFILE}.local"
.  endif

# XXX(to be removed)
.  if defined(OPTIONS)
.    undef optname
.    for O in ${OPTIONS:C/".*"//g}
.      if defined(WITH_${O})
PORT_OPTIONS+=	${O}
PORT_OPTIONS:=	${PORT_OPTIONS:O:u}
.      endif
.      if defined(WITHOUT_${O})
PORT_OPTIONS:=	${PORT_OPTIONS:N${O}}
.      endif
.    endfor
.  endif
# XXX(end to be removed)

## Finish by using the options set by the port config dialog, if any
.  for opt in ${OPTIONS_FILE_SET}
PORT_OPTIONS+=	${opt}
.  endfor
PORT_OPTIONS:=	${PORT_OPTIONS:O:u}

.for opt in ${OPTIONS_FILE_UNSET}
PORT_OPTIONS:=	${PORT_OPTIONS:N${opt}}
.endfor
.undef opt

.endif

## Now some compatibility
.if empty(PORT_OPTIONS:MDOCS)
NOPORTDOCS=	yes
.endif

.if empty(PORT_OPTIONS:MNLS)
WITHOUT_NLS=	yes
.endif

### to be removed once old OPTIONS disappear
.if defined(OPTIONS)
# include OPTIONSFILE first if exists
.       if exists(${OPTIONSFILE}) && !make(rmconfig)
.       include "${OPTIONSFILE}"
.       endif
.       if exists(${OPTIONSFILE}.local)
.       include "${OPTIONSFILE}.local"
.       endif
WITHOUT:=
WITH:=
.       if defined(OPTIONS)
REALOPTIONS=${OPTIONS:C/".*"//g}
.       for O in ${REALOPTIONS}
RO:=${O}
.       if ${RO:L} == off
WITHOUT:=       ${WITHOUT} ${OPT}
.       endif
.       if ${RO:L} == on
WITH:=          ${WITH} ${OPT}
.       endif
OPT:=${RO}
.       endfor
.       endif
# define only if NO WITH/WITHOUT_${W} is defined
.       for W in ${WITH}
.   if !defined(WITH_${W}) && !defined(WITHOUT_${W})
WITH_${W}:=     true
.   endif
.       endfor
.       for W in ${WITHOUT}
.   if !defined(WITH_${W}) && !defined(WITHOUT_${W})
WITHOUT_${W}:=  true
.   endif
.       endfor
.       undef WITH
.       undef WITHOUT
.       undef RO
.       undef REALOPTIONS
.endif
###
