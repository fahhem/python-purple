cdef extern from "libpurple/debug.h":
    cdef void purple_debug_set_enabled(gboolean debug_enabled)
