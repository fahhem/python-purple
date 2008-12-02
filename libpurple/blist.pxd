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

cdef extern from *:
    ctypedef char const_char "const char"

# hack to avoid recursive loops by cython
cdef extern from "libpurple/status.h":
    ctypedef struct PurplePresence:
        pass

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
        void (*request_add_buddy) (account.PurpleAccount *account, const_char *username, const_char *group, const_char *alias)
        void (*request_add_chat) (account.PurpleAccount *account, PurpleGroup *group, const_char *alias, const_char *name)
        void (*request_add_group) ()

    void *c_purple_blist_get_handle "purple_blist_get_handle" ()
    void c_purple_blist_load "purple_blist_load" ()
    PurpleBuddyList* c_purple_blist_new "purple_blist_new" ()
    PurpleBlistNodeType c_purple_blist_node_get_type \
            "purple_blist_node_get_type" (PurpleBlistNode *node)
    int c_purple_blist_get_group_size "purple_blist_get_group_size" \
            (PurpleGroup *group, glib.gboolean offline)
    int c_purple_blist_get_group_online_count \
            "purple_blist_get_group_online_count" (PurpleGroup *group)
    void c_purple_blist_set_ui_ops "purple_blist_set_ui_ops" (PurpleBlistUiOps *ops)
    const_char *c_purple_chat_get_name "purple_chat_get_name" (PurpleChat *chat)
    const_char *c_purple_contact_get_alias "purple_contact_get_alias" (PurpleContact *contact)
    const_char *c_purple_group_get_name "purple_group_get_name" (PurpleGroup *group)
    PurpleBuddy *c_purple_buddy_new "purple_buddy_new" (account.PurpleAccount *account,
            char *screenname, char *alias)
    const_char *c_purple_buddy_get_alias_only "purple_buddy_get_alias_only" (PurpleBuddy *buddy)
    const_char *c_purple_buddy_get_name "purple_buddy_get_name" (PurpleBuddy *buddy)
    PurpleBuddy *c_purple_find_buddy "purple_find_buddy" (account.PurpleAccount *account, char *name)
    void c_purple_set_blist "purple_set_blist" (PurpleBuddyList *list)
    glib.GSList *c_purple_find_buddies "purple_find_buddies" (account.PurpleAccount *account, char *name)
    account.PurpleAccount *c_purple_buddy_get_account "purple_buddy_get_account" (PurpleBuddy *buddy)
    PurplePresence *c_purple_buddy_get_presence "purple_buddy_get_presence" (PurpleBuddy *buddy)
