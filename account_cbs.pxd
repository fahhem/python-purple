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

cdef void notify_added(account.PurpleAccount *account, \
        const_char *remote_user, const_char *id, const_char *alias, \
        const_char *message):
    """
    A buddy who is already on this account's buddy list added this account to
    their buddy list.
    """
    debug.purple_debug_info("account", "%s", "notify-added\n")
    if account_cbs.has_key("notify-added"):
        (<object> account_cbs["notify-added"])("notify-added: TODO")

cdef void status_changed(account.PurpleAccount *account, \
        status.PurpleStatus *status):
    """
    This account's status changed.
    """
    debug.purple_debug_info("account", "%s", "status-changed\n")
    if account_cbs.has_key("status-changed"):
        (<object> account_cbs["status-changed"])("status-changed: TODO")

cdef void request_add(account.PurpleAccount *account, \
        const_char *remote_user, const_char *id, const_char *alias, \
        const_char *message):
    """
    Someone we don't have on our list added us; prompt to add them.
    """
    debug.purple_debug_info("account", "%s", "request-add\n")
    if account_cbs.has_key("request-add"):
        (<object> account_cbs["request-add"])("request-add: TODO")

cdef void *request_authorize(account.PurpleAccount *account, \
        const_char *remote_user, const_char *id, const_char *alias, \
        const_char *message, glib.gboolean on_list, \
        account.PurpleAccountRequestAuthorizationCb authorize_cb, \
        account.PurpleAccountRequestAuthorizationCb deny_cb, \
        void *user_data):
    """
    Prompt for authorization when someone adds this account to their buddy
    list. To authorize them to see this account's presence, call
    authorize_cb(user_data) otherwise call deny_cb(user_data).
    @return a UI-specific handle, as passed to #close_account_request.
    """
    debug.purple_debug_info("account", "%s", "request-authorize\n")
    if account_cbs.has_key("request-authorize"):
        (<object> account_cbs["request-authorize"])("request-authorize: TODO")

cdef void close_account_request (void *ui_handle):
    """
    Close a pending request for authorization. ui_handle is a handle as
    returned by request_authorize.
    """
    debug.purple_debug_info("account", "%s", "close-account-request\n")
    if account_cbs.has_key("close-account-request"):
        (<object> account_cbs["close-account-request"])("close-account-request: TODO")
