AC_INIT([Makefiles], [0.0.1])
AC_PREREQ(2.13)
AM_INIT_AUTOMAKE([1.9 dist-bzip2 tar-ustar dist-zip -Wno-portability])
AC_CONFIG_MACRO_DIRS([m4])

AC_PROG_LN_S
AC_PROG_MKDIR_P

NUGET_INIT
NUGET_RESTORE([Solution.sln])
NUGET_INSTALL([NUnit.ConsoleRunner],[3.7.0])
NUGET_INSTALL([NUnit.Extension.NUnitV2Driver],[3.7.0])

NUGET_CHECK_MODULE([NUNIT],[NUnit],[2.6.4],,,[lib])
NUGET_CHECK_MODULE([NEWTONSOFT],[Newtonsoft.Json],[6.0.8])

MONO_PROG([NUNIT],[${NUGET_DIR}NUnit.ConsoleRunner.3.7.0/tools/nunit3-console.exe])

AC_ARG_ENABLE([release], AS_HELP_STRING([--enable-release], [Enable RELEASE mode]))

AM_CONDITIONAL([ENABLE_RELEASE], [test x$enable_release = xyes])

AC_OUTPUT([
Makefile
build/Makefile
src/Makefile
src/Library/Makefile
src/Library2/Makefile
src/Program/Makefile
src/Program/Program.exe.config
])
