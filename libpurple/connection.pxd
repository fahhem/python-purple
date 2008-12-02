#
#  Copyright (c) 2008 INdT - Instituto Nokia de Tecnologia
#
#  This file is part of python-purple.
#
#  python-purple is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  python-purple is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

cimport glib

cimport account
cimport plugin

cdef extern from *:
    ctypedef int size_t
    ctypedef long int time_t

cdef extern from "libpurple/connection.h":
    ctypedef struct PurpleConnection

    ctypedef enum PurpleConnectionFlags:
        PURPLE_CONNECTION_HTML = 0x0001
        PURPLE_CONNECTION_NO_BGCOLOR = 0x0002
        PURPLE_CONNECTION_AUTO_RESP = 0x0004
        PURPLE_CONNECTION_FORMATTING_WBFO = 0x0008
        PURPLE_CONNECTION_NO_NEWLINES = 0x0010
        PURPLE_CONNECTION_NO_FONTSIZE = 0x0020
        PURPLE_CONNECTION_NO_URLDESC = 0x0040
        PURPLE_CONNECTION_NO_IMAGES = 0x0080
        PURPLE_CONNECTION_ALLOW_CUSTOM_SMILEY = 0x0100

    ctypedef enum PurpleConnectionState:
        PURPLE_DISCONNECTED = 0
        PURPLE_CONNECTED
        PURPLE_CONNECTING

    ctypedef enum PurpleConnectionError:
        PURPLE_CONNECTION_ERROR_NETWORK_ERROR = 0
        PURPLE_CONNECTION_ERROR_INVALID_USERNAME = 1
        PURPLE_CONNECTION_ERROR_AUTHENTICATION_FAILED = 2
        PURPLE_CONNECTION_ERROR_AUTHENTICATION_IMPOSSIBLE = 3
        PURPLE_CONNECTION_ERROR_NO_SSL_SUPPORT = 4
        PURPLE_CONNECTION_ERROR_ENCRYPTION_ERROR = 5
        PURPLE_CONNECTION_ERROR_NAME_IN_USE = 6
        PURPLE_CONNECTION_ERROR_INVALID_SETTINGS = 7
        PURPLE_CONNECTION_ERROR_CERT_NOT_PROVIDED = 8
        PURPLE_CONNECTION_ERROR_CERT_UNTRUSTED = 9
        PURPLE_CONNECTION_ERROR_CERT_EXPIRED = 10
        PURPLE_CONNECTION_ERROR_CERT_NOT_ACTIVATED = 11
        PURPLE_CONNECTION_ERROR_CERT_HOSTNAME_MISMATCH = 12
        PURPLE_CONNECTION_ERROR_CERT_FINGERPRINT_MISMATCH = 13
        PURPLE_CONNECTION_ERROR_CERT_SELF_SIGNED = 14
        PURPLE_CONNECTION_ERROR_CERT_OTHER_ERROR = 15
        PURPLE_CONNECTION_ERROR_OTHER_ERROR = 16

    ctypedef struct PurpleConnectionErrorInfo:
        PurpleConnectionError type
        char *description

    ctypedef struct PurpleConnectionUiOps:
        void (*connect_progress) (PurpleConnection *gc, char *text, size_t step, size_t step_count)
        void (*connected) (PurpleConnection *gc)
        void (*disconnected) (PurpleConnection *gc)
        void (*notice) (PurpleConnection *gc, char *text)
        void (*report_disconnect) (PurpleConnection *gc, char *text)
        void (*network_connected) ()
        void (*network_disconnected) ()
        void (*report_disconnect_reason) (PurpleConnection *gc, PurpleConnectionError reason, char *text)

    ctypedef struct PurpleConnection:
        plugin.PurplePlugin *prpl
        PurpleConnectionFlags flags
        PurpleConnectionState state
        account.PurpleAccount *account
        char *password
        int inpa
        glib.GSList *buddy_chats
        void *proto_data
        char *display_name
        glib.guint keepalive
        glib.gboolean wants_to_die
        glib.guint disconnect_timeout
        time_t last_received

    # Connection API FIXME
    void purple_connection_set_state(PurpleConnection *gc, \
            PurpleConnectionState state)
    void purple_connection_set_account(PurpleConnection *gc, \
            account.PurpleAccount *account)
    void purple_connection_set_display_name(PurpleConnection *gc, char *name)
    PurpleConnectionState purple_connection_get_state(PurpleConnection *gc)
    account.PurpleAccount *purple_connection_get_account(PurpleConnection *gc)
    plugin.PurplePlugin * purple_connection_get_prpl(PurpleConnection *gc)
    char *purple_connection_get_password(PurpleConnection *gc)
    char *purple_connection_get_display_name(PurpleConnection *gc)
    void purple_connection_update_progress(PurpleConnection *gc, char *text, \
            size_t step, size_t count)
    void purple_connection_notice(PurpleConnection *gc, char *text)
    void purple_connection_error(PurpleConnection *gc, char *reason)
    void purple_connection_error_reason (PurpleConnection *gc, \
            PurpleConnectionError reason, char *description)
    #void purple_connection_ssl_error (PurpleConnection *gc, \
            #PurpleSslErrorType ssl_error)
    glib.gboolean purple_connection_error_is_fatal ( \
            PurpleConnectionError reason)

    # Connections API
    void purple_connections_disconnect_all()
    glib.GList *purple_connections_get_all()
    glib.GList *purple_connections_get_connecting()

    # UI Registration Functions
    void purple_connections_set_ui_ops(PurpleConnectionUiOps *ops)
    PurpleConnectionUiOps *purple_connections_get_ui_ops()

    # Connections Subsystem
    void purple_connections_init()
    void purple_connections_uninit()
    void *purple_connections_get_handle()
