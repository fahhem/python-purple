cdef extern from "libpurple/plugin.h":
    cdef void purple_plugins_add_search_path(char *path)
    cdef void purple_plugins_load_saved(char *key)
