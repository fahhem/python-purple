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

cimport connection

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef int size_t

cdef extern from "libpurple/notify.h":
    ctypedef struct PurpleNotifyUserInfoEntry
    ctypedef struct PurpleNotifyUserInfo

    ctypedef void (*PurpleNotifyCloseCallback) (glib.gpointer user_data)

    ctypedef enum PurpleNotifyType:
        PURPLE_NOTIFY_MESSAGE = 0
        PURPLE_NOTIFY_EMAIL
        PURPLE_NOTIFY_EMAILS
        PURPLE_NOTIFY_FORMATTED
        PURPLE_NOTIFY_SEARCHRESULTS
        PURPLE_NOTIFY_USERINFO
        PURPLE_NOTIFY_URI

    ctypedef enum PurpleNotifyMsgType:
        PURPLE_NOTIFY_MSG_ERROR = 0
        PURPLE_NOTIFY_MSG_WARNING
        PURPLE_NOTIFY_MSG_INFO

    ctypedef enum PurpleNotifySearchButtonType:
        PURPLE_NOTIFY_BUTTON_LABELED = 0
        PURPLE_NOTIFY_BUTTON_CONTINUE = 1
        PURPLE_NOTIFY_BUTTON_ADD
        PURPLE_NOTIFY_BUTTON_INFO
        PURPLE_NOTIFY_BUTTON_IM
        PURPLE_NOTIFY_BUTTON_JOIN
        PURPLE_NOTIFY_BUTTON_INVITE

    ctypedef struct PurpleNotifySearchResults:
        glib.GList *columns
        glib.GList *rows
        glib.GList *buttons

    ctypedef struct PurpleNotifySearchColumn:
        char *title

    ctypedef void (*PurpleNotifySearchResultsCallback) (connection.PurpleConnection *c, glib.GList *row, glib.gpointer user_data)

    ctypedef struct purpleNotifySearchButton:
        PurpleNotifySearchButtonType type
        PurpleNotifySearchResultsCallback callback
        char *label

    ctypedef struct PurpleNotifyUiOps:
        void *(*notify_message) (PurpleNotifyMsgType type, const_char *title, \
                const_char *primary, const_char *secondary)
        void *(*notify_email) (connection.PurpleConnection *gc, \
                const_char *subject, const_char *sender, const_char *to, \
                const_char *url)
        void *(*notify_emails) (connection.PurpleConnection *gc,
                size_t count, glib.gboolean detailed, const_char **subjects, \
                const_char **senders, const_char **tos, const_char **urls)
        void *(*notify_formatted) (const_char *title, const_char *primary, \
                const_char *secondary, const_char *text)
        void *(*notify_searchresults) (connection.PurpleConnection *gc, \
                const_char *title, const_char *primary, \
                const_char *secondary, PurpleNotifySearchResults *results, \
                glib.gpointer user_data)
        void (*notify_searchresults_new_rows) \
                (connection.PurpleConnection *gc, \
                PurpleNotifySearchResults *results, void *data)
        void *(*notify_userinfo) (connection.PurpleConnection *gc, \
                const_char *who, PurpleNotifyUserInfo *user_info)
        void *(*notify_uri) (const_char *uri)
        void (*close_notify) (PurpleNotifyType type, void *ui_handle)

    void purple_notify_set_ui_ops(PurpleNotifyUiOps *ops)
