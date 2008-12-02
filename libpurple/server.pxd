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
cimport blist
cimport connection
cimport conversation
cimport prpl

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef long int time_t

cdef extern from "libpurple/server.h":
    unsigned int serv_send_typing(connection.PurpleConnection *gc, \
            const_char *name, conversation.PurpleTypingState state)
    void serv_move_buddy(blist.PurpleBuddy *, blist.PurpleGroup *, \
            blist.PurpleGroup *)
    int serv_send_im(connection.PurpleConnection *, const_char *, \
            const_char *, conversation.PurpleMessageFlags flags)
    prpl.PurpleAttentionType *purple_get_attention_type_from_code( \
            account.PurpleAccount *account, glib.guint type_code)
    void serv_send_attention(connection.PurpleConnection *gc, \
            const_char *who, glib.guint type_code)
    void serv_got_attention(connection.PurpleConnection *gc, \
            const_char *who, glib.guint type_code)
    void serv_get_info(connection.PurpleConnection *, const_char *)
    void serv_set_info(connection.PurpleConnection *, const_char *)
    void serv_add_permit(connection.PurpleConnection *, const_char *)
    void serv_add_deny(connection.PurpleConnection *, const_char *)
    void serv_rem_permit(connection.PurpleConnection *, const_char *)
    void serv_rem_deny(connection.PurpleConnection *, const_char *)
    void serv_set_permit_deny(connection.PurpleConnection *)
    void serv_chat_invite(connection.PurpleConnection *, int, \
            const_char *, const_char *)
    void serv_chat_leave(connection.PurpleConnection *, int)
    void serv_chat_whisper(connection.PurpleConnection *, int, \
            const_char *, const_char *)
    int serv_chat_send(connection.PurpleConnection *, int, const_char *, \
            conversation.PurpleMessageFlags flags)
    void serv_alias_buddy(blist.PurpleBuddy *)
    void serv_got_alias(connection.PurpleConnection *gc, const_char *who, \
            const_char *alias)
    void purple_serv_got_private_alias(connection.PurpleConnection *gc, \
            const_char *who, const_char *alias)

    void serv_got_typing(connection.PurpleConnection *gc, const_char *name, \
            int timeout, conversation.PurpleTypingState state)
    void serv_got_typing_stopped(connection.PurpleConnection *gc, \
            const_char *name)
    void serv_got_im(connection.PurpleConnection *gc, const_char *who, \
            const_char *msg, conversation.PurpleMessageFlags flags, \
            time_t mtime)
    void serv_join_chat(connection.PurpleConnection *, glib.GHashTable *data)
    void serv_reject_chat(connection.PurpleConnection *, glib.GHashTable *data)
    void serv_got_chat_invite(connection.PurpleConnection *gc, \
            const_char *name, const_char *who, const_char *message, \
            glib.GHashTable *data)
    conversation.PurpleConversation *serv_got_joined_chat( \
            connection.PurpleConnection *gc, int id, const_char *name)
    void purple_serv_got_join_chat_failed(connection.PurpleConnection *gc, \
            glib.GHashTable *data)
    void serv_got_chat_left(connection.PurpleConnection *g, int id)
    void serv_got_chat_in(connection.PurpleConnection *g, int id, \
            const_char *who, conversation.PurpleMessageFlags flags, \
            const_char *message, time_t mtime)
    void serv_send_file(connection.PurpleConnection *gc, const_char *who, \
            const_char *file)
