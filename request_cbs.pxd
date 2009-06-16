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

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef int size_t
    ctypedef void* va_list
    char* charptr "char *"
    glib.GCallback glibcb "GCallback"
    void* va_arg(void *action, void *type)

request_cbs = {}

cdef request.PurpleRequestActionCb req_actions_cb[10]
cdef object req_actions_list = []
cdef void *req_action_user_data = NULL

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
    debug.purple_debug_info("request", "%s", "request-input\n")
    if "request-input" in request_cbs:
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
    debug.purple_debug_info("request", "%s", "request-choice\n")
    if "request-choice" in request_cbs:
        (<object> request_cbs["request-choice"])("request-choice: TODO")

cdef void __call_action(int i):
    global req_actions_cb
    global req_actions_list
    global req_action_user_data

    cdef request.PurpleRequestActionCb cb 

    if req_actions_list and len(req_actions_list) > i:
        cb = req_actions_cb[i]
        cb(req_action_user_data, i)

cdef void *request_action(const_char *title, const_char *primary, \
        const_char *secondary, int default_action, \
        account.PurpleAccount *account, const_char *who, \
        conversation.PurpleConversation *conv, void *user_data, \
        size_t action_count, va_list actions):
    """
    @see purple_request_action_varg().
    """
    global req_actions_cb
    global req_actions_list
    global req_action_user_data
    cdef int i
    cdef char *btn_txt
    cdef void *cb

    i = 0

    req_action_user_data = user_data
    req_actions_list = []

    #FIXME: i < 10 max size to req_actions_cb
    while i < action_count and i < 10:
        btn_txt = <char *> va_arg(actions, charptr)
        req_actions_cb[i] = <request.PurpleRequestActionCb> va_arg(actions, glibcb)
        req_actions_list.append(btn_txt)
        i = i + 1

    debug.purple_debug_info("request", "%s", "request-action\n")
    if "request-action" in request_cbs:
        (<object> request_cbs["request-action"]) \
            (<char *> title, <char *> primary, <char *> secondary, \
            default_action, req_actions_list)

cdef void *request_fields(const_char *title, const_char *primary, \
        const_char *secondary, request.PurpleRequestFields *fields, \
        const_char *ok_text, glib.GCallback ok_cb, const_char *cancel_text, \
        glib.GCallback cancel_cb, account.PurpleAccount *account, \
        const_char *who, conversation.PurpleConversation *conv, \
        void *user_data):
    """
    @see purple_request_fields().
    """
    debug.purple_debug_info("request", "%s", "request-fields\n")
    if "request-fields" in request_cbs:
        (<object> request_cbs["request-fields"])("request-fields: TODO")

cdef void *request_file(const_char *title, const_char *filename, \
        glib.gboolean savedialog, glib.GCallback ok_cb, \
        glib.GCallback cancel_cb, account.PurpleAccount *account, \
        const_char *who, conversation.PurpleConversation *conv, \
        void *user_data):
    """
    @see purple_request_file().
    """
    debug.purple_debug_info("request", "%s", "request-file\n")
    if "request-file" in request_cbs:
        (<object> request_cbs["request-file"])("request-file: TODO")

cdef void close_request(request.PurpleRequestType type, void *ui_handle):
    """
    TODO
    """
    debug.purple_debug_info("request", "%s", "close-request\n")
    if "close-request" in request_cbs:
        (<object> request_cbs["close-request"])("close-request: TODO")

cdef void *request_folder(const_char *title, const_char *dirname, \
        glib.GCallback ok_cb, glib.GCallback cancel_cb, \
        account.PurpleAccount *account, const_char *who, \
        conversation.PurpleConversation *conv, void *user_data):
    """
    @see purple_request_folder().
    """
    debug.purple_debug_info("request", "%s", "request-folder\n")
    if "request-folder" in request_cbs:
        (<object> request_cbs["request-folder"])("request-folder: TODO")
