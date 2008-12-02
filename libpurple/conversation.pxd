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

cdef extern from "time.h":
    ctypedef long int time_t

cdef extern from "libpurple/conversation.h":
    ctypedef struct PurpleConversation:
        pass

    ctypedef struct PurpleConvIm:
        pass

    ctypedef enum PurpleMessageFlags:
        PURPLE_MESSAGE_SEND = 0x0001
        PURPLE_MESSAGE_RECV = 0x0002
        PURPLE_MESSAGE_SYSTEM = 0x0004
        PURPLE_MESSAGE_AUTO_RESP = 0x0008
        PURPLE_MESSAGE_ACTIVE_ONLY = 0x0010
        PURPLE_MESSAGE_NICK = 0x0020
        PURPLE_MESSAGE_NO_LOG = 0x0040
        PURPLE_MESSAGE_WHISPER = 0x0080
        PURPLE_MESSAGE_ERROR = 0x0200
        PURPLE_MESSAGE_DELAYED = 0x0400
        PURPLE_MESSAGE_RAW = 0x0800
        PURPLE_MESSAGE_IMAGES = 0x1000
        PURPLE_MESSAGE_NOTIFY = 0x2000
        PURPLE_MESSAGE_NO_LINKIFY = 0x4000
        PURPLE_MESSAGE_INVISIBLE = 0x8000

    ctypedef struct PurpleConversationUiOps:
        void (*create_conversation) (PurpleConversation *conv)
        void (*destroy_conversation) (PurpleConversation *conv)
        void (*write_chat) (PurpleConversation *conv, char *who, char *message, PurpleMessageFlags flags, time_t mtime)
        void (*write_im) (PurpleConversation *conv, char *who, char *message, PurpleMessageFlags flags, time_t mtime)
        void (*write_conv) (PurpleConversation *conv, char *name, char *alias, char *message, PurpleMessageFlags flags, time_t mtime)
        void (*chat_add_users) (PurpleConversation *conv, glib.GList *cbuddies, glib.gboolean new_arrivals)
        void (*chat_rename_user) (PurpleConversation *conv, char *old_name, char *new_name, char *new_alias)
        void (*chat_remove_users) (PurpleConversation *conv, glib.GList *users)
        void (*chat_update_user) (PurpleConversation *conv, char *user)
        void (*present) (PurpleConversation *conv)
        glib.gboolean (*has_focus) (PurpleConversation *conv)
        glib.gboolean (*custom_smiley_add) (PurpleConversation *conv, char *smile, glib.gboolean remote)
        void (*custom_smiley_write) (PurpleConversation *conv, char *smile, glib.guchar *data, glib.gsize size)
        void (*custom_smiley_close) (PurpleConversation *conv, char *smile)
        void (*send_confirm) (PurpleConversation *conv, char *message)

    void c_purple_conversations_init "purple_conversations_init" ()
    void *c_purple_conversations_get_handle "purple_conversations_get_handle" ()
    PurpleConversation *c_purple_conversation_new "purple_conversation_new" (int type, account.PurpleAccount *account, char *name)
    void c_purple_conversation_set_ui_ops "purple_conversation_set_ui_ops" (PurpleConversation *conv, PurpleConversationUiOps *ops)
    void c_purple_conversations_set_ui_ops "purple_conversations_set_ui_ops" (PurpleConversationUiOps *ops)
    PurpleConvIm *c_purple_conversation_get_im_data "purple_conversation_get_im_data" (PurpleConversation *conv)
    void c_purple_conv_im_send "purple_conv_im_send" (PurpleConvIm *im, char *message)
    void c_purple_conversation_destroy "purple_conversation_destroy" (PurpleConversation *conv)
