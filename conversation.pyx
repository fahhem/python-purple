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
    """
    Conversation class
    @param type    UNKNOWN, IM, CHAT, MISC, ANY
    @param account Your account
    @param name    Buddy name
    """

    cdef object __account
    cdef object __name
    cdef object __type
    cdef object __exists

    def __init__(self, type, account, name):
        self.__type = {
            "UNKNOWN": conversation.PURPLE_CONV_TYPE_UNKNOWN,
            "IM": conversation.PURPLE_CONV_TYPE_IM,
            "CHAT": conversation.PURPLE_CONV_TYPE_CHAT,
            "MISC": conversation.PURPLE_CONV_TYPE_MISC,
            "ANY": conversation.PURPLE_CONV_TYPE_ANY }[type]
        self.__account = account
        self.__name = name

        if self._get_structure() != NULL:
            self.__exists = True
        else:
            self.__exists = False

    cdef conversation.PurpleConversation *_get_structure(self):
        return conversation.purple_find_conversation_with_account( \
            self.__type, self.__name, account.purple_accounts_find( \
            self.__account.username, self.__account.protocol.id))

    def __get_exists(self):
        return self.__exists
    exists = property(__get_exists)

    def __get_account(self):
        if self.__exists:
            return self.__account
        else:
            return None
    account = property(__get_account)

    def __get_name(self):
        if self.__exists:
            return <char *> conversation.purple_conversation_get_name( \
                    self._get_structure())
        else:
            return None
    name = property(__get_name)

    def new(self):
        """
        Creates a new conversation.

        @return True if successful, False if conversation already exists
        """
        if self.__exists:
            return False
        else:
            conversation.purple_conversation_new(self.__type, \
                    account.purple_accounts_find(self.__account.username, \
                    self.__account.protocol.id), self.__name)
            self.__exists = True
            return True

    def destroy(self):
        """
        Destroys a conversation.

        @return True if successful, False if conversation doesn't exists
        """
        if self.__exists:
            conversation.purple_conversation_destroy(self._get_structure())
            self.__exists = False
            return True
        else:
            return False

    def set_ui_ops(self, cbs):
        """
        Sets UI operations for a conversation.

        @return True if sucessful, False otherwise
        """
        # FIXME: We may need to create c-functions for each of these?
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

        conversation.purple_conversation_set_ui_ops(self._get_structure(), \
                &c_conv_ui_ops)
        return True

    def im_send(self, message):
        """
        Sends a message to this IM conversation.

        @return True if successful, False if conversation is not IM or conversation doesn't exists
        """
        if self.__exists and self.__type == conversation.PURPLE_CONV_TYPE_IM:
            conversation.purple_conv_im_send( \
                    conversation.purple_conversation_get_im_data( \
                    self._get_structure()), message)
            return True
        else:
            return False
