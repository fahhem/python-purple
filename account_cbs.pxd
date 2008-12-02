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

cimport purple

cdef extern from *:
    ctypedef char const_char "const char"

account_cbs = {}

cdef void notify_added (account.PurpleAccount *account,
                        const_char *remote_user, const_char *id,
                        const_char *alias, const_char *message):
    debug.c_purple_debug_info("account", "%s", "notify-added\n")
    try:
        (<object>account_cbs["notify-added"])("notify-added: TODO")
    except KeyError:
        pass

cdef void status_changed (account.PurpleAccount *account,
                          status.PurpleStatus *status):
    debug.c_purple_debug_info("account", "%s", "status-changed\n")
    try:
        (<object>account_cbs["status-changed"])("status-changed: TODO")
    except KeyError:
        pass

cdef void request_add (account.PurpleAccount *account,
                       const_char *remote_user, const_char *id,
                       const_char *alias, const_char *message):
    debug.c_purple_debug_info("account", "%s", "request-add\n")
    try:
        (<object>account_cbs["request-add"])("request-add: TODO")
    except KeyError:
        pass

cdef void *request_authorize (account.PurpleAccount *account,
                              const_char *remote_user, const_char *id,
                              const_char *alias, const_char *message,
                              glib.gboolean on_list,
                              account.PurpleAccountRequestAuthorizationCb authorize_cb,
                              account.PurpleAccountRequestAuthorizationCb deny_cb,
                              void *user_data):
    debug.c_purple_debug_info("account", "%s", "request-authorize\n")
    try:
        (<object>account_cbs["request-authorize"])("request-authorize: TODO")
        return NULL
    except KeyError:
        pass

cdef void close_account_request (void *ui_handle):
    debug.c_purple_debug_info("account", "%s", "close-account-request\n")
    try:
        (<object>account_cbs["close-account-request"])("close-account-request: TODO")
    except KeyError:
        pass
