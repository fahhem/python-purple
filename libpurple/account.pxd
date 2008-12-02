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

cdef extern from *:
    ctypedef char const_char "const char"

# hack to avoid recursive loops by cython
cdef extern from "libpurple/connection.h":
    ctypedef struct PurpleConnection:
        pass

cdef extern from "libpurple/log.h":
    ctypedef struct PurpleLog:
        pass

cdef extern from "libpurple/proxy.h":
    ctypedef struct PurpleProxyInfo:
        pass

cdef extern from "libpurple/status.h":
    ctypedef struct PurpleStatus:
        pass

    ctypedef struct PurplePresence:
        pass

cdef extern from "libpurple/account.h":
    ctypedef struct PurpleAccountUiOps
    ctypedef struct PurpleAccount

    ctypedef glib.gboolean (*PurpleFilterAccountFunc) (PurpleAccount *account)
    ctypedef void (*PurpleAccountRequestAuthorizationCb) (void *)
    ctypedef void (*PurpleAccountRegistrationCb) (PurpleAccount *account, \
            glib.gboolean succeeded, void *user_data)
    ctypedef void (*PurpleAccountUnregistrationCb) (PurpleAccount *account, \
            glib.gboolean succeeded, void *user_data)

    ctypedef enum PurpleAccountRequestType:
        PURPLE_ACCOUNT_REQUEST_AUTHORIZATION = 0

    ctypedef struct PurpleAccountUiOps:
        void (*notify_added) (PurpleAccount *account, const_char *remote_user, \
                const_char *id, const_char *alias, const_char *message)
        void (*status_changed) (PurpleAccount *account, PurpleStatus *status)
        void (*request_add) (PurpleAccount *account, const_char *remote_user, \
                const_char *id, const_char *alias, const_char *message)
        void *(*request_authorize) (PurpleAccount *account, \
                const_char *remote_user, const_char *id, const_char *alias, \
                const_char *message, glib.gboolean on_list, \
                PurpleAccountRequestAuthorizationCb authorize_cb, \
                PurpleAccountRequestAuthorizationCb deny_cb, void *user_data)
        void (*close_account_request) (void *ui_handle)

    ctypedef struct PurpleAccount:
        char *username
        char *alias
        char *password
        char *user_info
        char *buddy_icon_path
        glib.gboolean remember_pass
        char *protocol_id
        PurpleConnection *gc
        glib.gboolean disconnecting
        glib.GHashTable *settings
        glib.GHashTable *ui_settings
        PurpleProxyInfo *proxy_info
        glib.GSList *permit
        glib.GSList *deny
        int perm_deny
        PurplePresence *presence
        PurpleLog *system_log
        void *ui_data
        PurpleAccountRegistrationCb registration_cb
        void *registration_cb_user_data
        glib.gpointer priv

    PurpleAccount *c_purple_account_new "purple_account_new" \
            (char *username, char *protocol_id)

    glib.gboolean c_purple_account_get_enabled "purple_account_get_enabled" \
            (PurpleAccount *account, char *ui)
    char *c_purple_account_get_username "purple_account_get_username" \
            (PurpleAccount *account)
    char *c_purple_account_get_password "purple_account_get_password" \
            (PurpleAccount *account)
    char *c_purple_account_get_alias "purple_account_get_alias" \
            (PurpleAccount *account)
    char *c_purple_account_get_user_info "purple_account_get_user_info" \
            (PurpleAccount *account)
    char *c_purple_account_get_protocol_id "purple_account_get_protocol_id" \
            (PurpleAccount *account)
    char *c_purple_account_get_protocol_name \
            "purple_account_get_protocol_name" (PurpleAccount *account)
    glib.gboolean c_purple_account_get_remember_password \
            "purple_account_get_remember_password" (PurpleAccount *account)

    void c_purple_account_set_enabled "purple_account_set_enabled" \
            (PurpleAccount *account, char *ui, glib.gboolean value)
    void c_purple_account_set_username "purple_account_set_username" \
            (PurpleAccount *account, char *username)
    void c_purple_account_set_password "purple_account_set_password" \
            (PurpleAccount *account, char *password)
    void c_purple_account_set_alias "purple_account_set_alias" \
            (PurpleAccount *account, char *alias)
    void c_purple_account_set_user_info "purple_account_set_user_info" \
            (PurpleAccount *account, char *user_info)
    void c_purple_account_set_protocol_id "purple_account_set_protocol_id" \
            (PurpleAccount *account, char *protocol_id)
    void c_purple_account_set_remember_password \
            "purple_account_set_remember_password" (PurpleAccount *account, \
                                                    glib.gboolean value)

    glib.GList *c_purple_accounts_get_all_active \
            "purple_accounts_get_all_active" ()
    void c_purple_accounts_set_ui_ops "purple_accounts_set_ui_ops" \
            (PurpleAccountUiOps *ops)
    void c_purple_account_connect "purple_account_connect" \
	    (PurpleAccount *account)
    void c_purple_account_disconnect "purple_account_disconnect" \
	    (PurpleAccount *account)
    glib.gboolean c_purple_account_is_connected "purple_account_is_connected" \
            (PurpleAccount *account)
    PurpleProxyInfo *c_purple_account_get_proxy_info \
            "purple_account_get_proxy_info" (PurpleAccount *account)
    void c_purple_account_set_proxy_info "purple_account_set_proxy_info" \
            (PurpleAccount *account, PurpleProxyInfo *info)
    char *c_purple_account_get_string "purple_account_get_string" \
            (PurpleAccount *account, char *name, char *default_value)
    int c_purple_account_get_int "purple_account_get_int" \
            (PurpleAccount *account, char *name, int default_value)
    glib.gboolean c_purple_account_get_bool "purple_account_get_bool" \
            (PurpleAccount *account, char *name, glib.gboolean default_value)
    void c_purple_account_clear_settings "purple_account_clear_settings" \
            (PurpleAccount *account)
    void c_purple_account_set_int "purple_account_set_int" \
            (PurpleAccount *account, char *name, int value)
    void c_purple_account_set_string "purple_account_set_string" \
            (PurpleAccount *account, char *name, char *value)
    void c_purple_account_set_bool "purple_account_set_bool" \
            (PurpleAccount *account, char *name, glib.gboolean value)
    PurpleAccount *c_purple_accounts_find "purple_accounts_find" \
            (char *name, char *protocol)
    glib.GList *c_purple_accounts_get_all "purple_accounts_get_all" ()
    void c_purple_accounts_add "purple_accounts_add" (PurpleAccount *account)
