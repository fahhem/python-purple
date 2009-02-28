cdef extern from "libpurple/blist.h":
    ctypedef struct PurpleBuddyList

    cdef void purple_set_blist(PurpleBuddyList *list)
    cdef void purple_blist_load()
    cdef PurpleBuddyList *purple_blist_new()
