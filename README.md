## .NET Makefiles

Since auto-tools support for .NET is generally quite terrible.

There are two versions:

- `mcs.mk`, uses `mcs` to fully control the build and;
- `xbuild.mk`, delegates to `xbuild`.

Both support _Release_ and _Debug_ switching via the `CONFIG` `make`
variable, e.g:

```bash
$ make CONFIG=Release # One off build in Release mode
```

See the header of each file for configuration instructions, the repository
shows a simple solution with three projects; Library, Library2 and a Program
that references the two libraries.
