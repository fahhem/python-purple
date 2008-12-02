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
    ctypedef glib.guchar const_guchar "const guchar"
    ctypedef long int time_t

conversation_cbs = {}

cdef void create_conversation (conversation.PurpleConversation *conv):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "create-conversation\n")
    cdef char *c_name = NULL

    c_name = <char *> conversation.c_purple_conversation_get_name(conv)
    if c_name == NULL:
        name = None
    else:
        name = c_name

    type = conversation.c_purple_conversation_get_type(conv)

    try:
        (<object>conversation_cbs["create-conversation"])(name, type)
    except KeyError:
        pass

cdef void destroy_conversation (conversation.PurpleConversation *conv):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "destroy-conversation\n")
    try:
        (<object>conversation_cbs["destroy-conversation"])("destroy-conversation: TODO")
    except KeyError:
        pass

cdef void write_chat (conversation.PurpleConversation *conv, const_char *who,
                      const_char *message, conversation.PurpleMessageFlags flags,
                      time_t mtime):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "write-chat\n")
    try:
        (<object>conversation_cbs["write-chat"])("write-chat: TODO")
    except KeyError:
        pass

cdef void write_im (conversation.PurpleConversation *conv, const_char *who,
                    const_char *c_message, conversation.PurpleMessageFlags flags,
                    time_t mtime):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation", "write-im\n")
    cdef account.PurpleAccount *acc = conversation.c_purple_conversation_get_account(conv)
    cdef blist.PurpleBuddy *buddy = blist.c_purple_find_buddy(acc, <char *> who)
    cdef char *c_username = NULL
    cdef char *c_sender_alias = NULL

    c_username = <char *> account.c_purple_account_get_username(acc)
    if c_username:
        username = c_username
    else:
        username = None

    if who:
        sender = <char *> who
        c_sender_alias = <char *> blist.c_purple_buddy_get_alias_only(buddy)
    else:
        sender = None

    if c_sender_alias:
        sender_alias = c_sender_alias
    else:
        sender_alias = None

    if c_message:
        message = <char *> c_message
    else:
        message = None

    try:
        (<object>conversation_cbs["write-im"])(username, sender, \
                                               sender_alias, message)
    except KeyError:
        pass

cdef void write_conv (conversation.PurpleConversation *conv, const_char *name,
                      const_char *alias, const_char *message,
                      conversation.PurpleMessageFlags flags, time_t mtime):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "write-conv\n")
    try:
        (<object>conversation_cbs["write-conv"])("write-conv: TODO")
    except KeyError:
        pass

cdef void chat_add_users (conversation.PurpleConversation *conv,
                          glib.GList *cbuddies, glib.gboolean new_arrivals):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "chat-add-users\n")
    try:
        (<object>conversation_cbs["chat-add-users"])("chat-add-users: TODO")
    except KeyError:
        pass

cdef void chat_rename_user (conversation.PurpleConversation *conv,
                            const_char *old_name, const_char *new_name,
                            const_char *new_alias):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "chat-rename-user\n")
    try:
        (<object>conversation_cbs["chat-rename-user"])("chat-rename-user: TODO")
    except KeyError:
        pass

cdef void chat_remove_users (conversation.PurpleConversation *conv,
                             glib.GList *users):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "chat-remove-users\n")
    try:
        (<object>conversation_cbs["chat-remove-users"])("chat-remove-users: TODO")
    except KeyError:
        pass

cdef void chat_update_user (conversation.PurpleConversation *conv,
                            const_char *user):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "chat-update-user\n")
    try:
        (<object>conversation_cbs["chat-update-user"])("chat-update-user: TODO")
    except KeyError:
        pass

cdef void present (conversation.PurpleConversation *conv):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "present\n")
    try:
        (<object>conversation_cbs["present"])("present: TODO")
    except KeyError:
        pass

cdef glib.gboolean has_focus (conversation.PurpleConversation *conv):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "has-focus\n")
    try:
        (<object>conversation_cbs["has-focus"])("has-focus: TODO")
        return False
    except KeyError:
        return False

cdef glib.gboolean custom_smiley_add (conversation.PurpleConversation *conv,
                                      const_char *smile, glib.gboolean remote):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "custom-smiley-add\n")
    try:
        (<object>conversation_cbs["custom-smiley-add"])("custom-smiley-add: TODO")
        return False
    except KeyError:
        return False

cdef void custom_smiley_write (conversation.PurpleConversation *conv,
                               const_char *smile, const_guchar *data,
                               glib.gsize size):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "custom-smiley-write\n")
    try:
        (<object>conversation_cbs["custom-smiley-write"])("custom-smiley-write: TODO")
    except KeyError:
        pass


cdef void custom_smiley_close (conversation.PurpleConversation *conv,
                               const_char *smile):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "custom-smiley-close\n")
    try:
        (<object>conversation_cbs["custom-smiley-close"])("custom-smiley-close: TODO")
    except KeyError:
        pass

cdef void send_confirm (conversation.PurpleConversation *conv,
                        const_char *message):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "send-confirm\n")
    try:
        (<object>conversation_cbs["send-confirm"])("send-confirm: TODO")
    except KeyError:
        pass
