/*
 * utils.d : Utilities
 */

module utils;

/**
 * Get a byte-formatted size.
 * Params:
 *   size = Size to format.
 *   base10 = decimal base
 * Returns: Formatted string.
 */
string formatsize(ulong size, bool base10 = false)
{
    import std.format : format;

    enum : double {
        KB = 1024,
        MB = KB * 1024,
        GB = MB * 1024,
        TB = GB * 1024,
        KiB = 1000,
        MiB = KiB * 1000,
        GiB = MiB * 1000,
        TiB = GiB * 1000
    }

      const double s = size;

      if (base10) {
            if (size > TiB)
                return format("%0.2f TiB", s / TiB);
            else if (size > GiB)
                return format("%0.2f GiB", s / GiB);
            else if (size > MiB)
                return format("%0.2f MiB", s / MiB);
            else if (size > KiB)
                return format("%0.2f KiB", s / KiB);
            else
                return format("%d B", size);
      } else {
            if (size > TB)
                return format("%0.2f TB", s / TB);
            else if (size > GB)
                return format("%0.2f GB", s / GB);
            else if (size > MB)
                return format("%0.2f MB", s / MB);
            else if (size > KB)
                return format("%0.2f KB", s / KB);
            else
                return format("%d B", size);
      }
}