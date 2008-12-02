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
        void (*write_chat) (PurpleConversation *conv, const_char_ptr who, const_char_ptr message, PurpleMessageFlags flags, time_t mtime)
        void (*write_im) (PurpleConversation *conv, const_char_ptr who, const_char_ptr message, PurpleMessageFlags flags, time_t mtime)
        void (*write_conv) (PurpleConversation *conv, const_char_ptr name, const_char_ptr alias, const_char_ptr message, PurpleMessageFlags flags, time_t mtime)
        void (*chat_add_users) (PurpleConversation *conv, GList *cbuddies, gboolean new_arrivals)
        void (*chat_rename_user) (PurpleConversation *conv, const_char_ptr old_name, const_char_ptr new_name, const_char_ptr new_alias)
        void (*chat_remove_users) (PurpleConversation *conv, GList *users)
        void (*chat_update_user) (PurpleConversation *conv, const_char_ptr user)
        void (*present) (PurpleConversation *conv)
        gboolean (*has_focus) (PurpleConversation *conv)
        gboolean (*custom_smiley_add) (PurpleConversation *conv, const_char_ptr smile, gboolean remote)
        void (*custom_smiley_write) (PurpleConversation *conv, const_char_ptr smile, const_guchar_ptr data, gsize size)
        void (*custom_smiley_close) (PurpleConversation *conv, const_char_ptr smile)
        void (*send_confirm) (PurpleConversation *conv, const_char_ptr message)

    void purple_conversations_init()
    PurpleConversation *purple_conversation_new(int type, PurpleAccount *account, const_char_ptr name)
    void purple_conversation_set_ui_ops(PurpleConversation *conv, PurpleConversationUiOps *ops)
    PurpleConvIm *purple_conversation_get_im_data(PurpleConversation *conv)
    void purple_conv_im_send(PurpleConvIm *im, const_char_ptr message)
    void *purple_conversations_get_handle()
    void purple_conversation_destroy(PurpleConversation *conv)

cdef class Conversation:
    """ Conversation class """
    cdef PurpleConversation *__conv

    def __cinit__(self):
        purple_conversations_init()

    def conversation_new(self, type, acc, const_char_ptr name):
        self.__conv = purple_conversation_new(type, <PurpleAccount*>acc.__account, name)

    def conversation_set_ui_ops(self):
        cdef PurpleConversationUiOps c_conv_ui_ops
        c_conv_ui_ops.create_conversation = NULL
        c_conv_ui_ops.destroy_conversation = NULL
        c_conv_ui_ops.write_chat = NULL
        c_conv_ui_ops.write_im = NULL
        c_conv_ui_ops.write_conv = NULL
        c_conv_ui_ops.chat_add_users = NULL
        c_conv_ui_ops.chat_rename_user = NULL
        c_conv_ui_ops.chat_remove_users = NULL
        c_conv_ui_ops.chat_update_user = NULL
        c_conv_ui_ops.present = NULL
        c_conv_ui_ops.has_focus = NULL
        c_conv_ui_ops.custom_smiley_add = NULL
        c_conv_ui_ops.custom_smiley_write = NULL
        c_conv_ui_ops.custom_smiley_close = NULL
        c_conv_ui_ops.send_confirm = NULL

        purple_conversation_set_ui_ops(self.__conv, &c_conv_ui_ops)

    def conversation_write(self, const_char_ptr message):
        purple_conv_im_send(purple_conversation_get_im_data(self.__conv), message)

    def conversation_destroy(self):
        purple_conversation_destroy(self.__conv)

    def conversation_get_handle(self):
        purple_conversations_get_handle()

    def send_message(self, buddy, const_char_ptr message):
        self.conversation_new(1, buddy.account, buddy.name)
        self.conversation_set_ui_ops()
        self.conversation_write(message)
