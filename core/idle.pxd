cdef extern from "libpurple/idle.h":
    ctypedef struct PurpleIdleUiOps

    cdef void purple_idle_set_ui_ops(PurpleIdleUiOps *ops)
