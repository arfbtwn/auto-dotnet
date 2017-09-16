# ================================================
#
# SYNOPSIS
#
#   NUGET_INIT()
#
#   $1 := Tool install root    (default: .nuget)
#   $2 := Tool version         (default: latest)
#   $3 := Package install root (default: packages)
#
# DESCRIPTION
#
#   Initialises NuGet related configury, requires
#   mono.m4 and wget if the nuget.exe can't be
#   found at the tool install root.
#
# ================================================
AC_DEFUN([NUGET_INIT],
[
    AC_REQUIRE([MONO_INIT])
    AC_PROVIDE([$0])

    _NUGET_ROOT([m4_default_quoted([$1],[.nuget])])
    _NUGET_EXE([m4_default_quoted([$2],[latest])])

    _NUGET_ROOT_P([m4_default_quoted([$3],[packages])])
    AC_ARG_VAR([NUGET_OPTS],[Default options to pass to NuGet])
    AC_SUBST([NUGET_OPTS],["-NonInteractive -Verbosity quiet"])

    AC_SUBST([NUGET_DIR],["\$(top_builddir)/${NUGET_ROOT_P}/"])
])

AC_DEFUN([NUGET_HINT_LIB],
[
    AC_REQUIRE([MONO_FRAMEWORK])
    AC_PROVIDE([$0])

    m4_define(nuget_hint,NUGET_HINT)

    AS_CASE([${FRAMEWORK}],
    [4],   [nuget_hint=lib/net40],
    [4.5], [nuget_hint=lib/net45],
           [nuget_hint=lib])

    AC_SUBST(nuget_hint)
])

AC_DEFUN([_NUGET_DIR],
[
    AC_REQUIRE([AC_PROG_MKDIR_P])

    AS_IF([test ! -d $2],
    [
        ${MKDIR_P} $2
    ])

    AC_SUBST([$1],[$2])
])

AC_DEFUN([_NUGET_ROOT],
[
    _NUGET_DIR([NUGET_ROOT],[$1])
])

AC_DEFUN([_NUGET_ROOT_P],
[
    _NUGET_DIR([NUGET_ROOT_P],[$1])
])

AC_DEFUN([_NUGET_EXE],
[
    AS_IF([test ! -f ${NUGET_ROOT}/nuget.exe],
    [
        AC_PATH_PROG([WGET],[wget])

        uri=https://dist.nuget.org/win-x86-commandline/$1/nuget.exe
        result=`${WGET} -O ${NUGET_ROOT}/nuget.exe ${uri} 2>&1`

        AS_IF([test 0 -ne $?],
        [
            rm -f ${NUGET_ROOT}/nuget.exe

            AC_MSG_ERROR([Unable to download nuget.exe: ${result}])
        ])
    ])

    chmod +x ${NUGET_ROOT}/nuget.exe

    AC_PATH_PROG([NUGET_EXE],[nuget.exe],,[${NUGET_ROOT}])
    AC_SUBST([NUGET],["${MONO} \$(top_builddir)/${NUGET_EXE}"])
])

# ================================================
#
# SYNOPSIS
#
#   NUGET_INSTALL()
#
#   $1 := PACKAGE
#   $2 := VERSION
#   $3 := [ACTION-IF-FOUND]
#   $4 := [ACTION-IF-NOT-FOUND]
#
# DESCRIPTION
#
#   Installs a NuGet package
#
# ================================================
AC_DEFUN([NUGET_INSTALL],
[
    AC_REQUIRE([NUGET_INIT])

    m4_if([$1],,[AC_MSG_ERROR([Requires a package name])])
    m4_if([$2],,[AC_MSG_ERROR([Requires a package version])])

    AC_MSG_CHECKING([for $1])
    result=`${MONO} ${NUGET_EXE} install ${NUGET_OPTS} -OutputDirectory ${NUGET_ROOT_P} $1 -Version $2 2>&1`

    AS_IF([test 0 -eq $?],
    [
        AC_MSG_RESULT([yes])

        $3
    ],
    [
        AC_MSG_RESULT([no])

        m4_if([$4],,
        [
            AC_MSG_ERROR([NuGet package requirements ($1) were not met: ${result}])
        ],
        [
            $4
        ])
    ])
])

# ================================================
#
# SYNOPSIS
#
#   NUGET_CHECK_MODULE()
#
#   $1 := VARIABLE
#   $2 := PACKAGE
#   $3 := VERSION
#   $4 := [ACTION-IF-FOUND]
#   $5 := [ACTION-IF-NOT-FOUND]
#   $6 := [HINT-PATH] (default: $NUGET_HINT)
#
# DESCRIPTION
#
#   Installs a NuGet package and probes for
#   downloaded assemblies, performing an
#   AC_SUBST() using $1 as prefix.
#
# ================================================
AC_DEFUN([NUGET_CHECK_MODULE],
[
    AC_REQUIRE([NUGET_INIT])
    AC_REQUIRE([NUGET_HINT_LIB])

    m4_if([$1],,[AC_MSG_ERROR([Requires a variable name])])

    hint="m4_default_quoted([$6],[${NUGET_HINT}])"

    NUGET_INSTALL([$2],[$3],
    [
        m4_define([$1_libs],[$1_LIBS])
        m4_define([$1_collect],[$1_COLLECT])

        $1_prefix=${NUGET_ROOT_P}/$2.$3/${hint}
        $1_probe=`find ${$1_prefix} -iname *.dll`
        $1_dir=${NUGET_DIR}$2.$3/${hint}
        $1_collect=${$1_probe/${$1_prefix}/${$1_dir}}
        $1_libs="-lib:${$1_dir} ${$1_probe/${$1_prefix}\//-r:}"

        AC_SUBST($1_libs)
        AC_SUBST($1_collect)

        $4
    ],
    [
        $5
    ])
])

# ================================================
#
# SYNOPSIS
#
#   NUGET_RESTORE()
#
#   $1 := Solution.sln
#
# ================================================
AC_DEFUN([NUGET_RESTORE],
[
    AC_REQUIRE([NUGET_INIT])

    AC_MSG_CHECKING([for NuGet packages to restore])
    AS_IF([test -f $1],
    [
        AC_MSG_RESULT([$1])
        result=`${MONO} ${NUGET_EXE} restore ${NUGET_OPTS} $1 2>&1`
        AS_IF([test 0 -ne $?],
        [
            AC_MSG_ERROR([restore failed: ${result}])
        ])
    ],
    [
        AC_MSG_RESULT([none])
    ])
])
