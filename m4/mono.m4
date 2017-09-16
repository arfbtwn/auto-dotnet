# ================================================
#
# SYNOPSIS
#
#   MONO_INIT()
#
#   $1 := Mono package check
#
# ================================================
AC_DEFUN([MONO_INIT],
[
    AC_PROVIDE([$0])

    PKG_CHECK_MODULES([MONO],[m4_default_quoted([$1],[mono])])

    AC_PATH_PROG([MONO],   [mono])
    AC_PATH_PROG([MCS],    [mcs])
    AC_PATH_PROG([GACUTIL],[gacutil])
])

# ================================================
#
# SYNOPSIS
#
#   MONO_FRAMEWORK()
#
#   $1 := SDK Version (default: 4.5)
#
# ================================================
AC_DEFUN([MONO_FRAMEWORK],
[
    AC_REQUIRE([MONO_INIT])

    m4_define(framework,FRAMEWORK)

    framework="m4_default_quoted([$1],[4.5])"

    AC_SUBST(framework)
])

# ================================================
#
# SYNOPSIS
#
#   MONO_PROG()
#
#   $1 := VARIABLE
#   $2 := PROGRAM
#
# ================================================
AC_DEFUN([MONO_PROG],
[
    AC_REQUIRE([MONO_INIT])

    AC_SUBST($1,["${MONO} $2"])
])
