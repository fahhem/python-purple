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

cdef class Conversation:
    """ Conversation class """
    cdef conversation.PurpleConversation *__conv
    cdef object __acc

    cdef object __name

    def __init__(self):
        conversation.purple_conversations_init()
        self.__name = None
        self.__acc = None

    def __get_account(self):
        return self.__acc
    def __set_account(self, acc):
        self.__acc = acc
    account = property(__get_account, __set_account)

    def __get_name(self):
        return self.__name
    def __set_name(self, name):
        self.__name = name
    name = property(__get_name, __set_name)

    def initialize(self, acc, type, char *name):
        cdef account.PurpleAccount *c_account
        self.__acc = acc
        self.__name = name

        c_account = account.purple_accounts_find(<char *> acc[0], <char *> acc[1])
        if not c_account:
            return

        if type == "UNKNOWN":
            self.__conv =\
            conversation.purple_conversation_new(conversation.PURPLE_CONV_TYPE_UNKNOWN,\
                c_account, self.__name)
        elif type == "IM":
            self.__conv =\
            conversation.purple_conversation_new(conversation.PURPLE_CONV_TYPE_IM,\
                <account.PurpleAccount*> c_account, self.__name)
        elif type == "CHAT":
            self.__conv =\
            conversation.purple_conversation_new(conversation.PURPLE_CONV_TYPE_CHAT,\
                c_account, self.__name)
        elif type == "MISC":
            self.__conv =\
            conversation.purple_conversation_new(conversation.PURPLE_CONV_TYPE_MISC,\
                c_account, self.__name)
        elif type == "ANY":
            self.__conv =\
            conversation.purple_conversation_new(conversation.PURPLE_CONV_TYPE_ANY,\
                c_account, self.__name)

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

        conversation.purple_conversation_set_ui_ops(self.__conv, &c_conv_ui_ops)

    def write(self, char *message):
        if self.__conv:
            conversation.purple_conv_im_send(conversation.purple_conversation_get_im_data(self.__conv), message)

    def get_handle(self):
        conversation.purple_conversations_get_handle()

    def destroy(self):
        print "[DEBUG]: Destroy conversation: %s" % self.__name
        if self.__conv:
            conversation.purple_conversation_destroy(self.__conv)
