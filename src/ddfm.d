module ddfm;

import std.stdio;
import core.stdc.stdio : printf;
import ddcon;
import std.path;
import std.file;
import std.format : format;
import utils;

//TODO: search
//TODO: Folder first (buffer for file/links types)

/// Start ddfm
void Start()
{
    InitConsole;
    SetColor(defaultColor);
    Clear;

    TopUpdate;
    Update;
    BottomUpdate;

    while (1)
    {
        const KeyInfo k = ReadKey;

        switch (k.keyCode)
        {
            case Key.DownArrow:
                if (userSelection + 1 < cdTotal) {
                    ++userSelection;
                    Update;
                } else {
                    userSelection = 0;
                    Update;
                }
                break;
            case Key.UpArrow:
                if (userSelection - 1 >= 0) {
                    --userSelection;
                } else {
                    userSelection = cdTotal - 1;
                }
                Update;
                break;
            
            case Key.Home:
                userSelection = 0;
                Update;
                break;
            case Key.End:
                userSelection = cdTotal - 1;
                Update;
                break;
            
            case Key.Enter: {
                DirEntry entry;
                if (getEntry(&entry)) {
                    if (entry.isDir) {
                        try {
                            chdir(entry.name);
                        } catch (Exception) {
                            //TODO: Message Bottom "Cannot access directory"
                        }
                        userSelection = 0;
                        SetColor(defaultColor);
                        Clear;
                        TopUpdate;
                        Update;
                        BottomUpdate;
                        break;
                    } else {
                        //TODO: Proper start system
                    }
                }
            }
                break;
            
            case Key.Backspace:
                chdir("..");
                userSelection = 0;
                SetColor(defaultColor);
                Clear;
                TopUpdate;
                Update;
                BottomUpdate;
                break;

            case Key.Q:
                ResetColor;
                Clear;
                return;

            default:
        }
    }
}

bool getEntry(DirEntry* e)
{
    int s;
    foreach (DirEntry entry; dirEntries(null, SpanMode.shallow)) {
        if (s == userSelection) {
            *e = entry;
            return true;
        }
        ++s;
    }
    return false;
}

/*
 * Coloring
 */

// DEFAULT
enum defaultColor = FgColor.LightCyan | BgColor.Blue; /// Default color
// FILE
enum fileColor = FgColor.LightCyan | BgColor.Blue; /// File color
enum fileSelectColor = FgColor.Black | BgColor.Cyan; /// Selected file color
// FOLDER
enum dirColor = FgColor.LightGreen | BgColor.Blue; /// Directory color
enum dirSelectColor = FgColor.Black | BgColor.Green; /// Selected directory color
// SYMLINK
enum linkColor = FgColor.LightPurple | BgColor.Blue; /// Symlink color
enum linkSelectColor = FgColor.Black | BgColor.Purple; /// Select symlink color


/*
 * Main display
 */

void Refresh()
{

}

private int userSelection;
private int cdTotal;
private long totalSize;
void Update()
{
    int h = WindowHeight - 2;
    int w = WindowWidth  - 1;
    SetPos(0, 1);
    int s;
    cdTotal = totalSize = 0;
    foreach (DirEntry entry; dirEntries(null, SpanMode.shallow))
    {
        if (--h >= 0)
        {
            with (entry) {
                //TODO: Use getAttributes instead?
                if (s == userSelection) { // SELECTION
                    if (isSymlink)
                        SetColor(linkSelectColor);
                    else if (isFile) {
                        SetColor(fileSelectColor);
                        totalSize += size;
                    } else
                        SetColor(dirSelectColor);
                } else if (isSymlink) { // SOFT LINK
                    SetColor(defaultColor);
                } else if (isFile) { // FILE
                    SetColor(defaultColor);
                    totalSize += size;
                } else { // DIRECTORY
                    SetColor(dirColor);
                }


                char* p = cast(char*)&name[0];
                size_t l = name.length;
                if (l > w) {
                    p[w] = '\0';
                    printf(" %-*s", w, p);
                } else {
                    p[l] = '\0';
                    printf(" %-*s\n", w, p);
                }
            }
            ++s;
        }
        ++cdTotal;
    }
}

/*
 * Top panel
 */

/*void TopRefresh()
{
    import core.stdc.stdio : printf;
    import core.stdc.stdlib : malloc, free;
    import core.stdc.string : memset;
    SetPos(0, 0);
    int h = WindowWidth - 1;
    char* b = cast(char*)malloc(h);
    memset(b, ' ', h);
    free(b);

    TopUpdate;
}*/

void TopUpdate()
{
    SetPos(0, 0);
    SetColor(defaultColor);
    writef("[%-*s]", WindowWidth - 2, getcwd);
}

/*
 * Bottom panel
 */

void BottomRefresh()
{

}

void BottomUpdate()
{
    SetPos(0, WindowHeight - 1);
    SetColor(defaultColor);
    writef("  %d element(s)", cdTotal);
}