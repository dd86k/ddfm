/*
 * main.d : Main entry point.
 */

module main;

import core.stdc.stdio;
import std.stdio : writeln, writefln;
import std.file, std.getopt;
import ddfm;

enum PROJECT_VERSION = "0.0.0-0", /// Project version.
     PROJECT_NAME = "ddfm";       /// Project name, usually executable name.

debug { } else
{ // --DRT-gcopt  related
    private extern(C) __gshared bool
        rt_envvars_enabled = false, /// Disables runtime environment variables
        rt_cmdline_enabled = false; /// Disables runtime CLI
}

private int main(string[] args)
{
    GetoptResult r;
	try {
		r = getopt(args,
            "v|version", "Print version information.", &PrintVersion
        );
	} catch (GetOptException ex) {
		stderr.writeln("Error: ", ex.msg);
        return 1;
	}

    if (r.helpWanted) {
        PrintHelp;
        printf("\nOption             Description\n");
        foreach (it; r.options) { // "custom" defaultGetoptPrinter
            writefln("%*s, %-*s%s%s",
                4,  it.optShort,
                12, it.optLong,
                it.required ? "Required: " : " ",
                it.help);
        }
        return 0;
	}
	
	Start;

    return 0;
}

/// Print description and synopsis.
void PrintHelp()
{
    printf("Browse and manage your files.\n");
    printf("  Usage: ddfm [options]\n");
    printf("         ddfm {-h|--help|-v|--version}\n");
}

/// Print program version and exit.
void PrintVersion()
{
    import core.stdc.stdlib : exit;
    printf("ddfm %s (%s)\n",
        &PROJECT_VERSION[0], &__TIMESTAMP__[0]);
    printf("Compiled %s with %s v%d\n\n",
        &__FILE__[0], &__VENDOR__[0], __VERSION__);
    printf("MIT License: Copyright (c) 2017 dd86k\n");
    printf("Project page: <https://github.com/dd86k/ddfm>\n");
    exit(0); // getopt hack
}