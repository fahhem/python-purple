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
cimport connection
cimport buddyicon

cdef extern from "time.h":
    ctypedef long int time_t

cdef extern from "libpurple/conversation.h":
    ctypedef struct PurpleConversationUiOps
    ctypedef struct PurpleConversation
    ctypedef struct PurpleConvIm
    ctypedef struct PurpleConvChat
    ctypedef struct PurpleConvChatBuddy
    ctypedef struct PurpleConvMessage

    ctypedef enum PurpleConversationType:
        PURPLE_CONV_TYPE_UNKNOWN = 0
        PURPLE_CONV_TYPE_IM
        PURPLE_CONV_TYPE_CHAT
        PURPLE_CONV_TYPE_MISC
        PURPLE_CONV_TYPE_ANY

    ctypedef enum PurpleConvUpdateType:
        PURPLE_CONV_UPDATE_ADD = 0
        PURPLE_CONV_UPDATE_REMOVE
        PURPLE_CONV_UPDATE_ACCOUNT
        PURPLE_CONV_UPDATE_TYPING
        PURPLE_CONV_UPDATE_UNSEEN
        PURPLE_CONV_UPDATE_LOGGING
        PURPLE_CONV_UPDATE_TOPIC
        PURPLE_CONV_ACCOUNT_ONLINE
        PURPLE_CONV_ACCOUNT_OFFLINE
        PURPLE_CONV_UPDATE_AWAY
        PURPLE_CONV_UPDATE_ICON
        PURPLE_CONV_UPDATE_TITLE
        PURPLE_CONV_UPDATE_CHATLEFT
        PURPLE_CONV_UPDATE_FEATURES

    ctypedef enum PurpleTypingState:
        PURPLE_NOT_TYPING = 0
        PURPLE_TYPING
        PURPLE_TYPED

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

    ctypedef enum PurpleConvChatBuddyFlags:
        PURPLE_CBFLAGS_NONE = 0x0000
        PURPLE_CBFLAGS_VOICE = 0x0001
        PURPLE_CBFLAGS_HALFOP = 0x0002
        PURPLE_CBFLAGS_OP = 0x0004
        PURPLE_CBFLAGS_FOUNDER = 0x0008
        PURPLE_CBFLAGS_TYPING = 0x0010

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

    ctypedef struct PurpleConvIm:
        PurpleConversation *conv
        PurpleTypingState typing_state
        glib.guint typing_timeout
        time_t type_again
        glib.guint send_typed_timeout
        buddyicon.PurpleBuddyIcon *icon

    ctypedef struct PurpleConvChat:
        PurpleConversation *conv
        glib.GList *in_room
        glib.GList *ignored
        char *who
        char *topic
        int id
        char *nick
        glib.gboolean left

    ctypedef struct PurpleConvChatBuddy:
        char *name
        char *alias
        char *alias_key
        glib.gboolean buddy
        PurpleConvChatBuddyFlags flags

    ctypedef struct PurpleConvMessage:
        char *who
        char *what
        PurpleMessageFlags flags
        time_t when
        PurpleConversation *conv
        char *alias

    ctypedef union UnionType:
        PurpleConvIm *im
        PurpleConvChat *chat
        void *misc

    ctypedef struct PurpleConversation:
        PurpleConversationType type
        account.PurpleAccount *account
        char *name
        char *title
        glib.gboolean logging
        glib.GList *logs
        UnionType u
        PurpleConversationUiOps *ui_ops
        void *ui_data
        glib.GHashTable *data
        connection.PurpleConnectionFlags features
        glib.GList *message_history

    # Conversation API
    PurpleConversation *purple_conversation_new(int type, \
            account.PurpleAccount *account, char *name)
    void purple_conversation_destroy(PurpleConversation *conv)
    void purple_conversation_present(PurpleConversation *conv)
    PurpleConversationType purple_conversation_get_type( \
            PurpleConversation *conv)
    void purple_conversation_set_ui_ops(PurpleConversation *conv, \
            PurpleConversationUiOps *ops)
    void purple_conversations_set_ui_ops(PurpleConversationUiOps *ops)
    PurpleConversationUiOps *purple_conversation_get_ui_ops( \
            PurpleConversation *conv)
    void purple_conversation_set_account(PurpleConversation *conv, \
            account.PurpleAccount *account)
    account.PurpleAccount *purple_conversation_get_account( \
            PurpleConversation *conv)
    connection.PurpleConnection *purple_conversation_get_gc( \
            PurpleConversation *conv)
    void purple_conversation_set_title(PurpleConversation *conv, char *title)
    char *purple_conversation_get_title(PurpleConversation *conv)
    void purple_conversation_autoset_title(PurpleConversation *conv)
    void purple_conversation_set_name(PurpleConversation *conv, char *name)
    char *purple_conversation_get_name(PurpleConversation *conv)
    void purple_conversation_set_logging(PurpleConversation *conv, \
            glib.gboolean log)
    glib.gboolean purple_conversation_is_logging(PurpleConversation *conv)
    void purple_conversation_close_logs(PurpleConversation *conv)
    PurpleConvIm *purple_conversation_get_im_data(PurpleConversation *conv)
    PurpleConvChat *purple_conversation_get_chat_data(PurpleConversation *conv)
    void purple_conversation_set_data(PurpleConversation *conv, char *key, \
            glib.gpointer data)
    glib.gpointer purple_conversation_get_data(PurpleConversation *conv, \
            char *key)
    glib.GList *purple_get_conversations()
    glib.GList *purple_get_ims()
    glib.GList *purple_get_chats()
    PurpleConversation *purple_find_conversation_with_account( \
            PurpleConversationType type, char *name, \
            account.PurpleAccount *account)
    void purple_conversation_write(PurpleConversation *conv, char *who, \
    char *message, PurpleMessageFlags flags, time_t mtime)
    void purple_conversation_set_features(PurpleConversation *conv, \
            connection.PurpleConnectionFlags features)
    connection.PurpleConnectionFlags purple_conversation_get_features( \
            PurpleConversation *conv)
    glib.gboolean purple_conversation_has_focus(PurpleConversation *conv)
    void purple_conversation_update(PurpleConversation *conv, \
            PurpleConvUpdateType type)
    void purple_conversation_foreach(void (*func)(PurpleConversation *conv))
    glib.GList *purple_conversation_get_message_history( \
            PurpleConversation *conv)
    void purple_conversation_clear_message_history(PurpleConversation *conv)
    char *purple_conversation_message_get_sender(PurpleConvMessage *msg)
    char *purple_conversation_message_get_message(PurpleConvMessage *msg)
    PurpleMessageFlags purple_conversation_message_get_flags( \
            PurpleConvMessage *msg)
    time_t purple_conversation_message_get_timestamp(PurpleConvMessage *msg)

    #IM Conversation API
    PurpleConversation *purple_conv_im_get_conversation(PurpleConvIm *im)
    void purple_conv_im_set_icon(PurpleConvIm *im, \
            buddyicon.PurpleBuddyIcon *icon)
    buddyicon.PurpleBuddyIcon *purple_conv_im_get_icon(PurpleConvIm *im)
    void purple_conv_im_set_typing_state(PurpleConvIm *im, \
            PurpleTypingState state)
    PurpleTypingState purple_conv_im_get_typing_state(PurpleConvIm *im)
    void purple_conv_im_start_typing_timeout(PurpleConvIm *im, int timeout)
    void purple_conv_im_stop_typing_timeout(PurpleConvIm *im)
    glib.guint purple_conv_im_get_typing_timeout(PurpleConvIm *im)
    void purple_conv_im_set_type_again(PurpleConvIm *im, unsigned int val)
    time_t purple_conv_im_get_type_again(PurpleConvIm *im)
    void purple_conv_im_start_send_typed_timeout(PurpleConvIm *im)
    void purple_conv_im_stop_send_typed_timeout(PurpleConvIm *im)
    glib.guint purple_conv_im_get_send_typed_timeout(PurpleConvIm *im)
    void purple_conv_im_update_typing(PurpleConvIm *im)
    void purple_conv_im_write(PurpleConvIm *im, char *who, \
            char *message, PurpleMessageFlags flags, time_t mtime)
    glib.gboolean purple_conv_present_error(char *who, \
            account.PurpleAccount *account, char *what)
    void purple_conv_im_send(PurpleConvIm *im, char *message)
    void purple_conv_send_confirm(PurpleConversation *conv, \
            char *message)
    void purple_conv_im_send_with_flags(PurpleConvIm *im, char *message, \
            PurpleMessageFlags flags)
    glib.gboolean purple_conv_custom_smiley_add(PurpleConversation *conv, \
            char *smile, char *cksum_type, char *chksum, glib.gboolean remote)
    void purple_conv_custom_smiley_write(PurpleConversation *conv, \
            char *smile, glib.guchar *data, glib.gsize size)
    void purple_conv_custom_smiley_close(PurpleConversation *conv, char *smile)

    # Chat Conversation API
    PurpleConversation *purple_conv_chat_get_conversation(PurpleConvChat *chat)
    glib.GList *purple_conv_chat_set_users(PurpleConvChat *chat, \
            glib.GList *users)
    glib.GList *purple_conv_chat_get_users(PurpleConvChat *chat)
    void purple_conv_chat_ignore(PurpleConvChat *chat, char *name)
    void purple_conv_chat_unignore(PurpleConvChat *chat, char *name)
    glib.GList *purple_conv_chat_set_ignored(PurpleConvChat *chat, \
            glib.GList *ignored)
    glib.GList *purple_conv_chat_get_ignored(PurpleConvChat *chat)
    char *purple_conv_chat_get_ignored_user(PurpleConvChat *chat, char *user)
    glib.gboolean purple_conv_chat_is_user_ignored(PurpleConvChat *chat, \
            char *user)
    void purple_conv_chat_set_topic(PurpleConvChat *chat, char *who, \
            char *topic)
    char *purple_conv_chat_get_topic(PurpleConvChat *chat)
    void purple_conv_chat_set_id(PurpleConvChat *chat, int id)
    int purple_conv_chat_get_id(PurpleConvChat *chat)
    void purple_conv_chat_write(PurpleConvChat *chat, char *who, \
            char *message, PurpleMessageFlags flags, time_t mtime)
    void purple_conv_chat_send(PurpleConvChat *chat, char *message)
    void purple_conv_chat_send_with_flags(PurpleConvChat *chat, \
            char *message, PurpleMessageFlags flags)
    void purple_conv_chat_add_user(PurpleConvChat *chat, char *user, \
            char *extra_msg, PurpleConvChatBuddyFlags flags, \
            glib.gboolean new_arrival)
    void purple_conv_chat_add_users(PurpleConvChat *chat, glib.GList *users, \
            glib.GList *extra_msgs, glib.GList *flags, \
            glib.gboolean new_arrivals)
    void purple_conv_chat_rename_user(PurpleConvChat *chat, \
            char *old_user, char *new_user)
    void purple_conv_chat_remove_user(PurpleConvChat *chat, \
            char *user, char *reason)
    void purple_conv_chat_remove_users(PurpleConvChat *chat, \
            glib.GList *users, char *reason)
    glib.gboolean purple_conv_chat_find_user(PurpleConvChat *chat, char *user)
    void purple_conv_chat_user_set_flags(PurpleConvChat *chat, char *user, \
            PurpleConvChatBuddyFlags flags)
    PurpleConvChatBuddyFlags purple_conv_chat_user_get_flags( \
            PurpleConvChat *chat, char *user)
    void purple_conv_chat_clear_users(PurpleConvChat *chat)
    void purple_conv_chat_set_nick(PurpleConvChat *chat, char *nick)
    char *purple_conv_chat_get_nick(PurpleConvChat *chat)
    PurpleConversation *purple_find_chat(connection.PurpleConnection *gc, \
            int id)
    void purple_conv_chat_left(PurpleConvChat *chat)
    glib.gboolean purple_conv_chat_has_left(PurpleConvChat *chat)
    PurpleConvChatBuddy *purple_conv_chat_cb_new(char *name, char *alias, \
            PurpleConvChatBuddyFlags flags)
    PurpleConvChatBuddy *purple_conv_chat_cb_find(PurpleConvChat *chat, \
            char *name)
    char *purple_conv_chat_cb_get_name(PurpleConvChatBuddy *cb)
    void purple_conv_chat_cb_destroy(PurpleConvChatBuddy *cb)
    glib.GList * purple_conversation_get_extended_menu( \
            PurpleConversation *conv)
    glib.gboolean purple_conversation_do_command(PurpleConversation *conv, \
            glib.gchar *cmdline, glib.gchar *markup, glib.gchar **error)

    # Conversations Subsystem
    void *purple_conversations_get_handle()
    void purple_conversations_init()
    void purple_conversations_uninit()
