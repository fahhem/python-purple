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

cimport proxy
cimport status

cdef extern from *:
    ctypedef char const_char "const char"

cdef extern from "libpurple/account.h":
    ctypedef void (*PurpleAccountRequestAuthorizationCb) (void *)

    ctypedef struct PurpleAccount:
        char *username
        char *alias
        char *password
        char *user_info
        char *buddy_icon_path
        glib.gboolean remember_pass
        char *protocol_id

    ctypedef struct PurpleAccountUiOps:
        void (*notify_added) (PurpleAccount *account, const_char *remote_user, \
                const_char *id, const_char *alias, const_char *message)
        void (*status_changed) (PurpleAccount *account, \
                status.PurpleStatus *status)
        void (*request_add) (PurpleAccount *account, const_char *remote_user, \
                const_char *id, const_char *alias, const_char *message)
        void *(*request_authorize) (PurpleAccount *account, \
                const_char *remote_user, const_char *id, const_char *alias, \
                const_char *message, glib.gboolean on_list, \
                PurpleAccountRequestAuthorizationCb authorize_cb, \
                PurpleAccountRequestAuthorizationCb deny_cb, void *user_data)
        void (*close_account_request) (void *ui_handle)

    PurpleAccount *c_purple_account_new "purple_account_new" \
            (char *username, char *protocol_id)
    void c_purple_account_set_password "purple_account_set_password" \
            (PurpleAccount *account, char *password)
    char *c_purple_account_get_password "purple_account_get_password" \
            (PurpleAccount *account)
    void c_purple_account_set_enabled "purple_account_set_enabled" \
            (PurpleAccount *account, char *ui, glib.gboolean value)
    char *c_purple_account_get_username "purple_account_get_username" \
            (PurpleAccount *account)
    glib.GList *c_purple_accounts_get_all_active \
            "purple_accounts_get_all_active" ()
    void c_purple_accounts_set_ui_ops "purple_accounts_set_ui_ops" \
            (PurpleAccountUiOps *ops)
    glib.gboolean c_purple_account_is_connected "purple_account_is_connected" \
            (PurpleAccount *account)
    proxy.PurpleProxyInfo *c_purple_account_get_proxy_info \
            "purple_account_get_proxy_info" (PurpleAccount *account)
    void c_purple_account_set_proxy_info "purple_account_set_proxy_info" \
            (PurpleAccount *account, proxy.PurpleProxyInfo *info)

