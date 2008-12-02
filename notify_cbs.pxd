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

notify_cbs = {}

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef int size_t

cdef void *notify_message (notify.PurpleNotifyMsgType type, const_char *title,
                           const_char *primary, const_char *secondary):
    debug.c_purple_debug_info("notify", "%s", "notify-message\n")
    try:
        (<object>notify_cbs["notify-message"])("notify-message: TODO")
    except KeyError:
        pass

cdef void *notify_email (connection.PurpleConnection *gc, const_char *subject,
                         const_char *_from, const_char *to, const_char *url):
    debug.c_purple_debug_info("notify", "%s", "notify-email\n")
    try:
        (<object>notify_cbs["notify-email"])("notify-email: TODO")
    except KeyError:
        pass

cdef void *notify_emails (connection.PurpleConnection *gc, size_t count,
                          glib.gboolean detailed, const_char **subjects,
                          const_char **froms, const_char **tos,
                          const_char **urls):
    debug.c_purple_debug_info("notify", "%s", "notify-emails\n")
    try:
        (<object>notify_cbs["notify-emails"])("notify-emails: TODO")
    except KeyError:
        pass

cdef void *notify_formatted (const_char *title, const_char *primary,
                             const_char *secondary, const_char *text):
    debug.c_purple_debug_info("notify", "%s", "notify-formatted\n")
    try:
        (<object>notify_cbs["notify-formatted"])("notify-formatted: TODO")
    except KeyError:
        pass

cdef void *notify_searchresults (connection.PurpleConnection *gc,
                                 const_char *title, const_char *primary,
                                 const_char *secondary,
                                 notify.PurpleNotifySearchResults *results,
                                 glib.gpointer user_data):
    debug.c_purple_debug_info("notify", "%s", "notify-searchresults\n")
    try:
        (<object>notify_cbs["notify-searchresults"])("notify-searchresults: TODO")
    except KeyError:
        pass

cdef void notify_searchresults_new_rows (connection.PurpleConnection *gc,
                            notify.PurpleNotifySearchResults *results,
                            void *data):
    debug.c_purple_debug_info("notify", "%s", "notify-searchresults-new-rows\n")
    try:
        (<object>notify_cbs["notify-searchresults-new-rows"])("notify-searchresults-new-rows: TODO")
    except KeyError:
        pass

cdef void *notify_userinfo (connection.PurpleConnection *gc, const_char *who,
                            notify.PurpleNotifyUserInfo *user_info):
    debug.c_purple_debug_info("notify", "%s", "notify-userinfo\n")
    try:
        (<object>notify_cbs["notify-userinfo"])("notify-userinfo: TODO")
    except KeyError:
        pass

cdef void *notify_uri (const_char *uri):
    debug.c_purple_debug_info("notify", "%s", "notify-uri\n")
    try:
        (<object>notify_cbs["notify-uri"])("notify-uri: TODO")
    except KeyError:
        pass

cdef void close_notify (notify.PurpleNotifyType type, void *ui_handle):
    debug.c_purple_debug_info("notify", "%s", "close-notify\n")
    try:
        (<object>notify_cbs["close-notify"])("close-notify: TODO")
    except KeyError:
        pass
