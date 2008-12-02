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
                         "create_conversation\n")
    try:
        (<object>conversation_cbs["create_conversation"])(conv.name, conv.type)
    except KeyError:
        pass

cdef void destroy_conversation (conversation.PurpleConversation *conv):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "destroy_conversation\n")
    try:
        (<object>conversation_cbs["destroy_conversation"])("destroy_conversation")
    except KeyError:
        pass

cdef void write_chat (conversation.PurpleConversation *conv, const_char *who,
                      const_char *message, conversation.PurpleMessageFlags flags,
                      time_t mtime):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "write_chat\n")
    try:
        (<object>conversation_cbs["write_chat"])("write_chat")
    except KeyError:
        pass

cdef void write_im (conversation.PurpleConversation *conv, const_char *who,
                    const_char *message, conversation.PurpleMessageFlags flags,
                    time_t mtime):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation", "write_im\n")
    if who:
        sender = <char *> who
    else:
        sender = None
    try:
        (<object>conversation_cbs["write_im"])(conv.account.username, sender, <char *> message)
    except KeyError:
        pass

cdef void write_conv (conversation.PurpleConversation *conv, const_char *name,
                      const_char *alias, const_char *message,
                      conversation.PurpleMessageFlags flags, time_t mtime):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "write_conv\n")
    try:
        (<object>conversation_cbs["write_conv"])("write_conv")
    except KeyError:
        pass

cdef void chat_add_users (conversation.PurpleConversation *conv,
                          glib.GList *cbuddies, glib.gboolean new_arrivals):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "chat_add_users\n")
    try:
        (<object>conversation_cbs["chat_add_users"])("chat_add_users")
    except KeyError:
        pass

cdef void chat_rename_user (conversation.PurpleConversation *conv,
                            const_char *old_name, const_char *new_name,
                            const_char *new_alias):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "chat_rename_user\n")
    try:
        (<object>conversation_cbs["chat_rename_user"])("chat_rename_user")
    except KeyError:
        pass

cdef void chat_remove_users (conversation.PurpleConversation *conv,
                             glib.GList *users):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "chat_remove_users\n")
    try:
        (<object>conversation_cbs["chat_remove_users"])("chat_remove_users")
    except KeyError:
        pass

cdef void chat_update_user (conversation.PurpleConversation *conv,
                            const_char *user):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "chat_update_user\n")
    try:
        (<object>conversation_cbs["chat_update_user"])("chat_update_user")
    except KeyError:
        pass

cdef void present (conversation.PurpleConversation *conv):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "present\n")
    try:
        (<object>conversation_cbs["present"])("present")
    except KeyError:
        pass

cdef glib.gboolean has_focus (conversation.PurpleConversation *conv):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "has_focus\n")
    try:
        (<object>conversation_cbs["has_focus"])("has_focus")
        return False
    except KeyError:
        return False

cdef glib.gboolean custom_smiley_add (conversation.PurpleConversation *conv,
                                      const_char *smile, glib.gboolean remote):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "custom_smiley_add\n")
    try:
        (<object>conversation_cbs["custom_smiley_add"])("custom_smiley_add")
        return False
    except KeyError:
        return False

cdef void custom_smiley_write (conversation.PurpleConversation *conv,
                               const_char *smile, const_guchar *data,
                               glib.gsize size):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "custom_smiley_write\n")
    try:
        (<object>conversation_cbs["custom_smiley_write"])("custom_smiley_write")
    except KeyError:
        pass


cdef void custom_smiley_close (conversation.PurpleConversation *conv,
                               const_char *smile):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "custom_smiley_close\n")
    try:
        (<object>conversation_cbs["custom_smiley_close"])("custom_smiley_close")
    except KeyError:
        pass

cdef void send_confirm (conversation.PurpleConversation *conv,
                        const_char *message):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "conversation",
                         "send_confirm\n")
    try:
        (<object>conversation_cbs["send_confirm"])("send_confirm")
    except KeyError:
        pass
