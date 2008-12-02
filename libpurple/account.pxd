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

# hack to avoid recursive loops by cython
cdef extern from "libpurple/blist.h":
    ctypedef struct PurpleBuddy
    ctypedef struct PurpleGroup

cdef extern from "libpurple/connection.h":
    ctypedef struct PurpleConnection
    ctypedef struct PurpleConnectionErrorInfo

cdef extern from "libpurple/log.h":
    ctypedef struct PurpleLog

cdef extern from "libpurple/proxy.h":
    ctypedef struct PurpleProxyInfo

cdef extern from "libpurple/status.h":
    ctypedef struct PurpleStatus
    ctypedef struct PurpleStatusType
    ctypedef struct PurpleStatusPrimitive
    ctypedef struct PurplePresence

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
        void (*notify_added) (PurpleAccount *account, char *remote_user, \
                char *id, char *alias, char *message)
        void (*status_changed) (PurpleAccount *account, PurpleStatus *status)
        void (*request_add) (PurpleAccount *account, char *remote_user, \
                char *id, char *alias, char *message)
        void *(*request_authorize) (PurpleAccount *account, \
                char *remote_user, char *id, char *alias, \
                char *message, glib.gboolean on_list, \
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

    # Account API
    PurpleAccount *purple_account_new(char *username, char *protocol_id)
    void purple_account_destroy(PurpleAccount *account)
    void purple_account_connect(PurpleAccount *account)
    void purple_account_set_register_callback(PurpleAccount *account, PurpleAccountRegistrationCb cb, void *user_data)
    void purple_account_register(PurpleAccount *account)
    void purple_account_unregister(PurpleAccount *account, PurpleAccountUnregistrationCb cb, void *user_data)
    void purple_account_disconnect(PurpleAccount *account)
    void purple_account_notify_added(PurpleAccount *account, \
            char *remote_user, char *id, char *alias, \
            char *message)
    void purple_account_request_add(PurpleAccount *account, \
            char *remote_user, char *id, char *alias, \
            char *message)
    void *purple_account_request_authorization(PurpleAccount *account, \
            char *remote_user, char *id, char *alias, \
            char *message, glib.gboolean on_list, \
            PurpleAccountRequestAuthorizationCb auth_cb, \
            PurpleAccountRequestAuthorizationCb deny_cb, void *user_data)
    void purple_account_request_close_with_account(PurpleAccount *account)
    void purple_account_request_close(void *ui_handle)
    void purple_account_request_password(PurpleAccount *account, \
            glib.GCallback ok_cb, glib.GCallback cancel_cb, void *user_data)
    void purple_account_request_change_password(PurpleAccount *account)
    void purple_account_request_change_user_info(PurpleAccount *account)
    void purple_account_set_username(PurpleAccount *account, char *username)
    void purple_account_set_password(PurpleAccount *account, char *password)
    void purple_account_set_alias(PurpleAccount *account, char *alias)
    void purple_account_set_user_info(PurpleAccount *account, char *user_info)
    void purple_account_set_buddy_icon_path(PurpleAccount *account, char *path)
    void purple_account_set_protocol_id(PurpleAccount *account, \
            char *protocol_id)
    void purple_account_set_connection(PurpleAccount *account, \
            PurpleConnection *gc)
    void purple_account_set_remember_password(PurpleAccount *account, \
            glib.gboolean value)
    void purple_account_set_check_mail(PurpleAccount *account, \
            glib.gboolean value)
    void purple_account_set_enabled(PurpleAccount *account, \
            char *ui, glib.gboolean value)
    void purple_account_set_proxy_info(PurpleAccount *account, \
            PurpleProxyInfo *info)
    void purple_account_set_status_types(PurpleAccount *account, \
            glib.GList *status_types)
    void purple_account_set_status_list(PurpleAccount *account, \
            char *status_id, glib.gboolean active, glib.GList *attrs)
    void purple_account_set_status(PurpleAccount *account, \
            char *status_id, glib.gboolean active, ...)
    void purple_account_set_status_list(PurpleAccount *account, \
            char *status_id, glib.gboolean active, glib.GList *attrs)
    void purple_account_clear_settings(PurpleAccount *account)
    void purple_account_set_int(PurpleAccount *account, char *name, \
            int value)
    void purple_account_set_string(PurpleAccount *account, char *name, \
            char *value)
    void purple_account_set_bool(PurpleAccount *account, char *name, \
            glib.gboolean value)
    void purple_account_set_ui_int(PurpleAccount *account, char *ui, \
            char *name, int value)
    void purple_account_set_ui_string(PurpleAccount *account, char *ui, \
            char *name, char *value)
    void purple_account_set_ui_bool(PurpleAccount *account, char *ui, \
            char *name, glib.gboolean value)
    glib.gboolean purple_account_is_connected(PurpleAccount *account)
    glib.gboolean purple_account_is_connecting(PurpleAccount *account)
    glib.gboolean purple_account_is_disconnected(PurpleAccount *account)
    char *purple_account_get_username(PurpleAccount *account)
    char *purple_account_get_password(PurpleAccount *account)
    char *purple_account_get_alias(PurpleAccount *account)
    char *purple_account_get_user_info(PurpleAccount *account)
    char *purple_account_get_buddy_icon_path(PurpleAccount *account)
    char *purple_account_get_protocol_id(PurpleAccount *account)
    char *purple_account_get_protocol_name(PurpleAccount *account)
    PurpleConnection *purple_account_get_connection(PurpleAccount *account)
    glib.gboolean purple_account_get_remember_password(PurpleAccount *account)
    glib.gboolean purple_account_get_check_mail(PurpleAccount *account)
    glib.gboolean purple_account_get_enabled(PurpleAccount *account, char *ui)
    PurpleProxyInfo *purple_account_get_proxy_info(PurpleAccount *account)
    PurpleStatus *purple_account_get_active_status(PurpleAccount *account)
    PurpleStatus *purple_account_get_status(PurpleAccount *account, \
            char *status_id)
    PurpleStatusType *purple_account_get_status_type(PurpleAccount *account, \
            char *id)
    PurpleStatusType *purple_account_get_status_type_with_primitive( \
            PurpleAccount *account, PurpleStatusPrimitive primitive)
    PurplePresence *purple_account_get_presence(PurpleAccount *account)
    glib.gboolean purple_account_is_status_active(PurpleAccount *account, \
            char *status_id)
    glib.GList *purple_account_get_status_types(PurpleAccount *account)
    int purple_account_get_int(PurpleAccount *account, char *name, \
            int default_value)
    char *purple_account_get_string(PurpleAccount *account, \
            char *name, char *default_value)
    glib.gboolean purple_account_get_bool(PurpleAccount *account, \
            char *name, glib.gboolean default_value)
    int purple_account_get_ui_int(PurpleAccount *account, \
            char *ui, char *name, int default_value)
    char *purple_account_get_ui_string(PurpleAccount *account, \
            char *ui, char *name, char *default_value)
    glib.gboolean purple_account_get_ui_bool(PurpleAccount *account, \
            char *ui, char *name, glib.gboolean default_value)
    PurpleLog *purple_account_get_log(PurpleAccount *account, \
            glib.gboolean create)
    void purple_account_destroy_log(PurpleAccount *account)
    void purple_account_add_buddy(PurpleAccount *account, PurpleBuddy *buddy)
    void purple_account_add_buddies(PurpleAccount *account, \
            glib.GList *buddies)
    void purple_account_remove_buddy(PurpleAccount *account, \
            PurpleBuddy *buddy, PurpleGroup *group)
    void purple_account_remove_buddies(PurpleAccount *account, \
            glib.GList *buddies, glib.GList *groups)
    void purple_account_remove_group(PurpleAccount *account, \
            PurpleGroup *group)
    void purple_account_change_password(PurpleAccount *account, \
            char *orig_pw, char *new_pw)
    glib.gboolean purple_account_supports_offline_message( \
            PurpleAccount *account, PurpleBuddy *buddy)
    PurpleConnectionErrorInfo *purple_account_get_current_error( \
            PurpleAccount *account)
    void purple_account_clear_current_error(PurpleAccount *account)

    # Accounts API
    void purple_accounts_add(PurpleAccount *account)
    void purple_accounts_remove(PurpleAccount *account)
    void purple_accounts_delete(PurpleAccount *account)
    void purple_accounts_reorder(PurpleAccount *account, glib.gint new_index)
    glib.GList *purple_accounts_get_all()
    glib.GList *purple_accounts_get_all_active()
    PurpleAccount *purple_accounts_find(char *name, char *protocol)
    void purple_accounts_restore_current_statuses()

    # UI Registration Functions
    void purple_accounts_set_ui_ops(PurpleAccountUiOps *ops)
    PurpleAccountUiOps *purple_accounts_get_ui_ops()

    # Accounts Subsystem
    void *purple_accounts_get_handle()
    void purple_accounts_init()
    void purple_accounts_uninit()
