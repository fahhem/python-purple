ctypedef enum gboolean:
    FALSE, TRUE

cdef extern from "libpurple/account.h":
    ctypedef struct PurpleAccount

    cdef PurpleAccount *purple_account_new(char *username, char *protocol_id)

    cdef void purple_account_set_password(PurpleAccount *account,
            char *password)

    cdef void purple_account_set_enabled(PurpleAccount *account, char *ui,
            gboolean value)

cdef extern from "libpurple/connection.h":
    ctypedef struct PurpleConnection

    cdef PurpleAccount *purple_connection_get_account(PurpleConnection *gc)



