cdef extern from "libpurple/eventloop.h":
    ctypedef struct PurpleEventLoopUiOps

    cdef void purple_eventloop_set_ui_ops(PurpleEventLoopUiOps *ops)
