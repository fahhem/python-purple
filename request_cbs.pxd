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

cdef void *request_input (const_char *title, const_char *primary,
                          const_char *secondary, const_char *default_value,
                          glib.gboolean multiline, glib.gboolean masked,
                          glib.gchar *hint, const_char *ok_text,
                          glib.GCallback ok_cb, const_char *cancel_text,
                          glib.GCallback cancel_cb,
                          account.PurpleAccount *account, const_char *who,
                          conversation.PurpleConversation *conv,
                          void *user_data):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "request", "request_input\n")
    try:
        (<object>request_cbs["request_input"])("request_input")
    except KeyError:
        pass

cdef void *request_choice (const_char *title, const_char *primary,
                           const_char *secondary, int default_value,
                           const_char *ok_text, glib.GCallback ok_cb,
                           const_char *cancel_text,
                           glib.GCallback cancel_cb,
                           account.PurpleAccount *account, const_char *who,
                           conversation.PurpleConversation *conv,
                           void *user_data, va_list choices):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "request",
                         "request_choice\n")
    try:
        (<object>request_cbs["request_choice"])("request_choice")
    except KeyError:
        pass

cdef void *request_action (const_char *title, const_char *primary,
                           const_char *secondary, int default_action,
                           account.PurpleAccount *account, const_char *who,
                           conversation.PurpleConversation *conv,
                           void *user_data, size_t action_count,
                           va_list actions):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "request",
                         "request_action\n")
    try:
        (<object>request_cbs["request_action"])("request_action")
    except KeyError:
        pass

cdef void *request_fields (const_char *title, const_char *primary,
                           const_char *secondary,
                           request.PurpleRequestFields *fields,
                           const_char *ok_text, glib.GCallback ok_cb,
                           const_char *cancel_text, glib.GCallback cancel_cb,
                           account.PurpleAccount *account, const_char *who,
                           conversation.PurpleConversation *conv,
                           void *user_data):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "request",
                         "request_fields\n")
    try:
        (<object>request_cbs["request_fields"])("request_fields")
    except KeyError:
        pass

cdef void *request_file (const_char *title, const_char *filename,
                         glib.gboolean savedialog, glib.GCallback ok_cb,
                         glib.GCallback cancel_cb,
                         account.PurpleAccount *account, const_char *who,
                         conversation.PurpleConversation *conv,
                         void *user_data):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "request", "request_file\n")
    try:
        (<object>request_cbs["request_file"])("request_file")
    except KeyError:
        pass

cdef void close_request (request.PurpleRequestType type, void *ui_handle):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "request", "close_request\n")
    try:
        (<object>request_cbs["close_request"])("close_request")
    except KeyError:
        pass

cdef void *request_folder (const_char *title, const_char *dirname,
                           glib.GCallback ok_cb,
                           glib.GCallback cancel_cb,
                           account.PurpleAccount *account,
                           const_char *who,
                           conversation.PurpleConversation *conv,
                           void *user_data):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "request",
                         "request_folder\n")
    try:
        (<object>request_cbs["request_folder"])("request_folder")
    except KeyError:
        pass
