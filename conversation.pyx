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

cimport conversation

cdef class Conversation:
    """ Conversation class """
    cdef conversation.PurpleConversation *__conv

    def __cinit__(self):
        conversation.c_purple_conversations_init()

    def conversation_new(self, type, acc, char *name):
        self.__conv = conversation.c_purple_conversation_new(type, <account.PurpleAccount*>acc.__account, name)

    def conversation_set_ui_ops(self):
        cdef conversation.PurpleConversationUiOps c_conv_ui_ops
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

        conversation.c_purple_conversation_set_ui_ops(self.__conv, &c_conv_ui_ops)

    def conversation_write(self, char *message):
        conversation.c_purple_conv_im_send(conversation.c_purple_conversation_get_im_data(self.__conv), message)

    def conversation_destroy(self):
        conversation.c_purple_conversation_destroy(self.__conv)

    def conversation_get_handle(self):
        conversation.c_purple_conversations_get_handle()

    def send_message(self, buddy, char *message):
        self.conversation_new(1, buddy.account, buddy.name)
        self.conversation_set_ui_ops()
        self.conversation_write(message)
