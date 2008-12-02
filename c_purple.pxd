cdef extern from *:
    ctypedef char* const_char_ptr "const char *"

cdef extern from "c_purple.h":
     void init_libpurple()
