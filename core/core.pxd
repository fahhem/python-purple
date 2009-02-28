cdef extern from "libpurple/core.h":
    ctypedef struct PurpleCoreUiOps

    cdef gboolean purple_core_init(char *ui)
    cdef gboolean purple_core_migrate()
    cdef void purple_core_set_ui_ops(PurpleCoreUiOps *ops)
