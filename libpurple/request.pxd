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

cimport account
cimport conversation

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef int size_t
    ctypedef void* va_list

cdef extern from "libpurple/request.h":
    ctypedef enum PurpleRequestType:
        PURPLE_REQUEST_INPUT = 0
        PURPLE_REQUEST_CHOICE
        PURPLE_REQUEST_ACTION
        PURPLE_REQUEST_FIELDS
        PURPLE_REQUEST_FILE
        PURPLE_REQUEST_FOLDER

    ctypedef enum PurpleRequestFieldType:
        PURPLE_REQUEST_FIELD_NONE
        PURPLE_REQUEST_FIELD_STRING
        PURPLE_REQUEST_FIELD_INTEGER
        PURPLE_REQUEST_FIELD_BOOLEAN
        PURPLE_REQUEST_FIELD_CHOICE
        PURPLE_REQUEST_FIELD_LIST
        PURPLE_REQUEST_FIELD_LABEL
        PURPLE_REQUEST_FIELD_IMAGE
        PURPLE_REQUEST_FIELD_ACCOUNT

    ctypedef struct PurpleRequestFields:
        glib.GList *groups
        glib.GHashTable *fields
        glib.GList required_fields
        void *ui_data

    ctypedef struct PurpleRequestFieldGroup:
        PurpleRequestFields *fields_list
        char *title
        glib.GList *fields

    ctypedef struct PurpleRequestField:
        pass

    ctypedef void (*PurpleRequestActionCb)(void *, int)
    ctypedef void (*PurpleRequestChoiceCb)(void *, int)
    ctypedef void (*PurpleRequestFieldsCb)(void *, PurpleRequestFields *fields)
    ctypedef void (*PurpleRequestFileCb)(void *, char *filename)

    ctypedef struct PurpleRequestUiOps:
        void *(*request_input) (const_char *title, const_char *primary,
                                const_char *secondary,
                                const_char *default_value,
                                glib.gboolean multiline, glib.gboolean masked,
                                glib.gchar *hint, const_char *ok_text,
                                glib.GCallback ok_cb, const_char *cancel_text,
                                glib.GCallback cancel_cb,
                                account.PurpleAccount *account,
                                const_char *who,
                                conversation.PurpleConversation *conv,
                                void *user_data)
        void *(*request_choice) (const_char *title, const_char *primary,
                                 const_char *secondary, int default_value,
                                 const_char *ok_text, glib.GCallback ok_cb,
                                 const_char *cancel_text,
                                 glib.GCallback cancel_cb,
                                 account.PurpleAccount *account,
                                 const_char *who,
                                 conversation.PurpleConversation *conv,
                                 void *user_data, va_list choices)
        void *(*request_action) (const_char *title, const_char *primary,
                                 const_char *secondary, int default_action,
                                 account.PurpleAccount *account,
                                 const_char *who,
                                 conversation.PurpleConversation *conv,
                                 void *user_data, size_t action_count,
                                 va_list actions)
        void *(*request_fields) (const_char *title, const_char *primary,
                                 const_char *secondary,
                                 PurpleRequestFields *fields,
                                 const_char *ok_text, glib.GCallback ok_cb,
                                 const_char *cancel_text,
                                 glib.GCallback cancel_cb,
                                 account.PurpleAccount *account,
                                 const_char *who,
                                 conversation.PurpleConversation *conv,
                                 void *user_data)
        void *(*request_file) (const_char *title, const_char *filename,
                               glib.gboolean savedialog, glib.GCallback ok_cb,
                               glib.GCallback cancel_cb,
                               account.PurpleAccount *account,
                               const_char *who,
                               conversation.PurpleConversation *conv,
                               void *user_data)
        void (*close_request) (PurpleRequestType type, void *ui_handle)
        void *(*request_folder) (const_char *title, const_char *dirname,
                                 glib.GCallback ok_cb,
                                 glib.GCallback cancel_cb,
                                 account.PurpleAccount *account,
                                 const_char *who,
                                 conversation.PurpleConversation *conv,
                                 void *user_data)

    void purple_request_close(PurpleRequestType type, void *uihandle)
    void purple_request_set_ui_ops(PurpleRequestUiOps *ops)
