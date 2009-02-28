cdef extern from "libpurple/prefs.h":
    cdef void purple_prefs_rename(char *oldname, char *newname)
    cdef char *purple_prefs_get_string(char *name)
    cdef gboolean purple_prefs_load()
