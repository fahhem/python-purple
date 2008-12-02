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
    ctypedef int size_t
    ctypedef void* va_list

request_cbs = {}

cdef void *request_input(const_char *title, const_char *primary, \
        const_char *secondary, const_char *default_value, \
        glib.gboolean multiline, glib.gboolean masked, glib.gchar *hint, \
        const_char *ok_text, glib.GCallback ok_cb, const_char *cancel_text, \
        glib.GCallback cancel_cb, \
        account.PurpleAccount *account, const_char *who, \
        conversation.PurpleConversation *conv, void *user_data):
    """
    @see purple_request_input().
    """
    debug.c_purple_debug_info("request", "%s", "request-input\n")
    if request_cbs.has_key("request-input"):
        (<object> request_cbs["request-input"])("request-input: TODO")

cdef void *request_choice(const_char *title, const_char *primary, \
        const_char *secondary, int default_value, const_char *ok_text, \
        glib.GCallback ok_cb, const_char *cancel_text, \
        glib.GCallback cancel_cb, account.PurpleAccount *account, \
        const_char *who, conversation.PurpleConversation *conv, \
        void *user_data, va_list choices):
    """
    @see purple_request_choice_varg().
    """
    debug.c_purple_debug_info("request", "%s", "request-choice\n")
    if request_cbs.has_key("request-choice"):
        (<object> request_cbs["request-choice"])("request-choice: TODO")

cdef void *request_action(const_char *title, const_char *primary, \
        const_char *secondary, int default_action, \
        account.PurpleAccount *account, const_char *who, \
        conversation.PurpleConversation *conv, void *user_data, \
        size_t action_count, va_list actions):
    """
    @see purple_request_action_varg().
    """
    debug.c_purple_debug_info("request", "%s", "request-action\n")
    if request_cbs.has_key("request-action"):
        (<object> request_cbs["request-action"])("request-action: TODo")

cdef void *request_fields(const_char *title, const_char *primary, \
        const_char *secondary, request.PurpleRequestFields *fields, \
        const_char *ok_text, glib.GCallback ok_cb, const_char *cancel_text, \
        glib.GCallback cancel_cb, account.PurpleAccount *account, \
        const_char *who, conversation.PurpleConversation *conv, \
        void *user_data):
    """
    @see purple_request_fields().
    """
    debug.c_purple_debug_info("request", "%s", "request-fields\n")
    if request_cbs.has_key("request-fields"):
        (<object> request_cbs["request-fields"])("request-fields: TODO")

cdef void *request_file(const_char *title, const_char *filename, \
        glib.gboolean savedialog, glib.GCallback ok_cb, \
        glib.GCallback cancel_cb, account.PurpleAccount *account, \
        const_char *who, conversation.PurpleConversation *conv, \
        void *user_data):
    """
    @see purple_request_file().
    """
    debug.c_purple_debug_info("request", "%s", "request-file\n")
    if request_cbs.has_key("request-file"):
        (<object> request_cbs["request-file"])("request-file: TODO")

cdef void close_request(request.PurpleRequestType type, void *ui_handle):
    """
    TODO
    """
    debug.c_purple_debug_info("request", "%s", "close-request\n")
    if request_cbs.has_key("close-request"):
        (<object> request_cbs["close-request"])("close-request: TODO")

cdef void *request_folder(const_char *title, const_char *dirname, \
        glib.GCallback ok_cb, glib.GCallback cancel_cb, \
        account.PurpleAccount *account, const_char *who, \
        conversation.PurpleConversation *conv, void *user_data):
    """
    @see purple_request_folder().
    """
    debug.c_purple_debug_info("request", "%s", "request-folder\n")
    if request_cbs.has_key("request-folder"):
        (<object> request_cbs["request-folder"])("request-folder: TODO")
