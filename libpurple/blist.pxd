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
cimport buddyicon

# hack to avoid recursive loops by cython
cdef extern from "libpurple/status.h":
    ctypedef struct PurpleStatus
    ctypedef struct PurplePresence

cdef extern from "libpurple/blist.h":
    ctypedef struct PurpleBuddyList
    ctypedef struct PurpleBlistUiOps
    ctypedef struct PurpleBlistNode
    ctypedef struct PurpleChat
    ctypedef struct PurpleGroup
    ctypedef struct PurpleContact
    ctypedef struct PurpleBuddy

    ctypedef enum PurpleBlistNodeType:
        PURPLE_BLIST_GROUP_NODE
        PURPLE_BLIST_CONTACT_NODE
        PURPLE_BLIST_BUDDY_NODE
        PURPLE_BLIST_CHAT_NODE
        PURPLE_BLIST_OTHER_NODE

    ctypedef enum PurpleBlistNodeFlags:
        PURPLE_BLIST_NODE_FLAG_NO_SAVE = 1 << 0

    ctypedef struct PurpleBlistNode:
        PurpleBlistNodeType type
        PurpleBlistNode *prev
        PurpleBlistNode *next
        PurpleBlistNode *parent
        PurpleBlistNode *child
        glib.GHashTable *settings
        void *ui_data
        PurpleBlistNodeFlags flags

    ctypedef struct PurpleBuddy:
        char *name
        char *alias
        char *server_alias
        void *proto_data
        buddyicon.PurpleBuddyIcon *icon
        account.PurpleAccount *account
        PurplePresence *presence

    ctypedef struct PurpleContact:
        PurpleBlistNode node
        char *alias
        int totalsize
        int currentsize
        int online
        PurpleBuddy *priority
        glib.gboolean priority_valid

    ctypedef struct PurpleGroup:
        PurpleBlistNode node
        char *name
        int totalsize
        int currentsize
        int online

    ctypedef struct PurpleChat:
        PurpleBlistNode node
        char *alias
        glib.GHashTable *components
        account.PurpleAccount *account

    ctypedef struct PurpleBuddyList:
        PurpleBlistNode *root
        glib.GHashTable *buddies
        void *ui_data

    ctypedef struct PurpleBlistUiOps:
        void (*new_list) (PurpleBuddyList *list)
        void (*new_node) (PurpleBlistNode *node)
        void (*show) (PurpleBuddyList *list)
        void (*update) (PurpleBuddyList *list, PurpleBlistNode *node)
        void (*remove) (PurpleBuddyList *list, PurpleBlistNode *node)
        void (*destroy) (PurpleBuddyList *list)
        void (*set_visible) (PurpleBuddyList *list, glib.gboolean show)
        void (*request_add_buddy) (account.PurpleAccount *account, char *username, char *group, char *alias)
        void (*request_add_chat) (account.PurpleAccount *account, PurpleGroup *group, char *alias, char *name)
        void (*request_add_group) ()

    # Buddy List API
    PurpleBuddyList *purple_blist_new()
    void purple_set_blist(PurpleBuddyList *blist)
    PurpleBuddyList *purple_get_blist()
    PurpleBlistNode *purple_blist_get_root()
    PurpleBlistNode *purple_blist_node_next(PurpleBlistNode *node, \
            glib.gboolean offline)
    PurpleBlistNode *purple_blist_node_get_parent(PurpleBlistNode *node)
    PurpleBlistNode *purple_blist_node_get_first_child(PurpleBlistNode *node)
    PurpleBlistNode *purple_blist_node_get_sibling_next(PurpleBlistNode *node)
    PurpleBlistNode *purple_blist_node_get_sibling_prev(PurpleBlistNode *node)
    void purple_blist_show()
    void purple_blist_destroy()
    void purple_blist_set_visible(glib.gboolean show)
    void purple_blist_update_buddy_status(PurpleBuddy *buddy, \
            PurpleStatus *old_status)
    void purple_blist_update_node_icon(PurpleBlistNode *node)
    void purple_blist_rename_buddy(PurpleBuddy *buddy, char *name)
    void purple_blist_alias_contact(PurpleContact *contact, char *alias)
    void purple_blist_alias_buddy(PurpleBuddy *buddy, char *alias)
    void purple_blist_server_alias_buddy(PurpleBuddy *buddy, char *alias)
    void purple_blist_alias_chat(PurpleChat *chat, char *alias)
    void purple_blist_rename_group(PurpleGroup *group, char *name)
    PurpleChat *purple_chat_new(account.PurpleAccount *account, char *alias, \
            glib.GHashTable *components)
    void purple_blist_add_chat(PurpleChat *chat, PurpleGroup *group, \
            PurpleBlistNode *node)
    PurpleBuddy *purple_buddy_new(account.PurpleAccount *account, \
            char *screenname, char *alias)
    void purple_buddy_set_icon(PurpleBuddy *buddy, \
            buddyicon.PurpleBuddyIcon *icon)
    account.PurpleAccount *purple_buddy_get_account(PurpleBuddy *buddy)
    char *purple_buddy_get_name(PurpleBuddy *buddy)
    buddyicon.PurpleBuddyIcon *purple_buddy_get_icon(PurpleBuddy *buddy)
    PurpleContact *purple_buddy_get_contact(PurpleBuddy *buddy)
    PurplePresence *purple_buddy_get_presence(PurpleBuddy *buddy)
    void purple_blist_add_buddy(PurpleBuddy *buddy, PurpleContact *contact, \
            PurpleGroup *group, PurpleBlistNode *node)
    PurpleGroup *purple_group_new(char *name)
    void purple_blist_add_group(PurpleGroup *group, PurpleBlistNode *node)
    PurpleContact *purple_contact_new()
    void purple_blist_add_contact(PurpleContact *contact, PurpleGroup *group, \
            PurpleBlistNode *node)
    void purple_blist_merge_contact(PurpleContact *source, \
            PurpleBlistNode *node)
    PurpleBuddy *purple_contact_get_priority_buddy(PurpleContact *contact)
    char *purple_contact_get_alias(PurpleContact *contact)
    glib.gboolean purple_contact_on_account(PurpleContact *contact, \
            account.PurpleAccount *account)
    void purple_contact_invalidate_priority_buddy(PurpleContact *contact)
    void purple_blist_remove_buddy(PurpleBuddy *buddy)
    void purple_blist_remove_contact(PurpleContact *contact)
    void purple_blist_remove_chat(PurpleChat *chat)
    void purple_blist_remove_group(PurpleGroup *group)
    char *purple_buddy_get_alias_only(PurpleBuddy *buddy)
    char *purple_buddy_get_server_alias(PurpleBuddy *buddy)
    char *purple_buddy_get_contact_alias(PurpleBuddy *buddy)
    char *purple_buddy_get_local_alias(PurpleBuddy *buddy)
    char *purple_buddy_get_alias(PurpleBuddy *buddy)
    char *purple_chat_get_name(PurpleChat *chat)
    PurpleBuddy *purple_find_buddy(account.PurpleAccount *account, char *name)
    PurpleBuddy *purple_find_buddy_in_group(account.PurpleAccount *account, \
            char *name, PurpleGroup *group)
    glib.GSList *purple_find_buddies(account.PurpleAccount *account, \
            char *name)
    PurpleGroup *purple_find_group(char *name)
    PurpleChat *purple_blist_find_chat(account.PurpleAccount *account, \
            char *name)
    PurpleGroup *purple_chat_get_group(PurpleChat *chat)
    account.PurpleAccount *purple_chat_get_account(PurpleChat *chat)
    glib.GHashTable *purple_chat_get_components(PurpleChat *chat)
    PurpleGroup *purple_buddy_get_group(PurpleBuddy *buddy)
    glib.GSList *purple_group_get_accounts(PurpleGroup *g)
    glib.gboolean purple_group_on_account(PurpleGroup *g, \
            account.PurpleAccount *account)
    char *purple_group_get_name(PurpleGroup *group)
    void purple_blist_add_account(account.PurpleAccount *account)
    void purple_blist_remove_account(account.PurpleAccount *account)
    int purple_blist_get_group_size(PurpleGroup *group, glib.gboolean offline)
    int purple_blist_get_group_online_count(PurpleGroup *group)

    # Buddy list file management API
    void purple_blist_load()
    void purple_blist_schedule_save()
    void purple_blist_request_add_buddy(account.PurpleAccount *account, \
            char *username, char *group, char *alias)
    void purple_blist_request_add_chat(account.PurpleAccount *account, \
            PurpleGroup *group, char *alias, char *name)
    void purple_blist_request_add_group()
    void purple_blist_node_set_bool(PurpleBlistNode *node, char *key, \
            glib.gboolean value)
    glib.gboolean purple_blist_node_get_bool(PurpleBlistNode *node, char *key)
    void purple_blist_node_set_int(PurpleBlistNode *node, char *key, int value)
    int purple_blist_node_get_int(PurpleBlistNode *node, char *key)
    void purple_blist_node_set_string(PurpleBlistNode *node, char *key, \
            char *value)
    char *purple_blist_node_get_string(PurpleBlistNode *node, char *key)
    void purple_blist_node_remove_setting(PurpleBlistNode *node, char *key)
    void purple_blist_node_set_flags(PurpleBlistNode *node, \
            PurpleBlistNodeFlags flags)
    PurpleBlistNodeFlags purple_blist_node_get_flags(PurpleBlistNode *node)
    PurpleBlistNodeType purple_blist_node_get_type(PurpleBlistNode *node)
    glib.GList *purple_blist_node_get_extended_menu(PurpleBlistNode *n)

    # UI Registration Functions
    void purple_blist_set_ui_ops(PurpleBlistUiOps *ops)
    PurpleBlistUiOps *purple_blist_get_ui_ops()

    # Buddy List Subsystem
    void *purple_blist_get_handle()
    void purple_blist_init()
    void purple_blist_uninit()
