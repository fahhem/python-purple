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

blist_cbs = {}

cdef void __group_node_cb(blist.PurpleBlistNode *node, object callback):
    cdef blist.PurpleGroup *group = <blist.PurpleGroup *>node
    cdef char *c_name = NULL

    c_name = <char *> blist.c_purple_group_get_name(group)
    if c_name == NULL:
        name = None
    else:
        name = c_name

    currentsize = blist.c_purple_blist_get_group_size(group, False)
    totalsize = blist.c_purple_blist_get_group_size(group, True)
    online = blist.c_purple_blist_get_group_online_count(group)

    try:
        callback(node.type, name, totalsize, currentsize, online)
    except KeyError:
        pass

cdef void __contact_node_cb(blist.PurpleBlistNode *node, object callback):
    cdef blist.PurpleContact *contact = <blist.PurpleContact *>node
    cdef char *c_alias = NULL

    c_alias = <char *> blist.c_purple_contact_get_alias(contact)
    if c_alias == NULL:
        alias = None
    else:
        alias = c_alias

    try:
        callback(node.type, alias, contact.totalsize, contact.currentsize, \
                 contact.online)
    except KeyError:
        pass

cdef void __buddy_node_cb(blist.PurpleBlistNode *node, object callback):
    cdef blist.PurpleBuddy *buddy = <blist.PurpleBuddy *>node
    cdef char *c_name = NULL
    cdef char *c_alias = NULL

    c_name = <char *> blist.c_purple_buddy_get_name(buddy)
    if c_name == NULL:
        name = None
    else:
        name = c_name

    c_alias = <char *> blist.c_purple_buddy_get_alias_only(buddy)
    if c_alias == NULL:
        alias = None
    else:
        alias = c_alias

    try:
        callback(node.type, name, alias)
    except KeyError:
        pass

cdef void __chat_node_cb(blist.PurpleBlistNode *node, object callback):
    cdef blist.PurpleChat *chat = <blist.PurpleChat *>node
    cdef char *c_name = NULL

    c_name = <char *> blist.c_purple_chat_get_name(chat)
    if c_name == NULL:
        name = None
    else:
        name = c_name

    try:
        callback(node.type, name)
    except KeyError:
        pass

cdef void __other_node_cb(blist.PurpleBlistNode *node, object callback):
    try:
        callback(node.type)
    except KeyError:
        pass

cdef void new_list (blist.PurpleBuddyList *list):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "new_list\n")
    try:
        (<object>blist_cbs["new_list"])("new_list")
    except KeyError:
        pass

cdef void new_node (blist.PurpleBlistNode *node):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "new_node\n")
    try:
        if node.type == blist.PURPLE_BLIST_GROUP_NODE:
            __group_node_cb(node, blist_cbs["new_node"])
        elif node.type == blist.PURPLE_BLIST_CONTACT_NODE:
            __contact_node_cb(node, blist_cbs["new_node"])
        elif node.type == blist.PURPLE_BLIST_BUDDY_NODE:
            __buddy_node_cb(node, blist_cbs["new_node"])
        elif node.type == blist.PURPLE_BLIST_CHAT_NODE:
            __chat_node_cb(node, blist_cbs["new_node"])
        elif node.type == blist.PURPLE_BLIST_OTHER_NODE:
            __other_node_cb(node, blist_cbs["new_node"])
    except KeyError:
        pass

cdef void show (blist.PurpleBuddyList *list):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "show\n")
    try:
        (<object>blist_cbs["show"])("show: TODO")
    except KeyError:
        pass

cdef void update (blist.PurpleBuddyList *list, blist.PurpleBlistNode *node):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "update\n")
    try:
        if node.type == blist.PURPLE_BLIST_GROUP_NODE:
            __group_node_cb(node, blist_cbs["update"])
        elif node.type == blist.PURPLE_BLIST_CONTACT_NODE:
            __contact_node_cb(node, blist_cbs["update"])
        elif node.type == blist.PURPLE_BLIST_BUDDY_NODE:
            __buddy_node_cb(node, blist_cbs["update"])
        elif node.type == blist.PURPLE_BLIST_CHAT_NODE:
            __chat_node_cb(node, blist_cbs["update"])
        elif node.type == blist.PURPLE_BLIST_OTHER_NODE:
            __other_node_cb(node, blist_cbs["update"])
    except KeyError:
        pass

cdef void remove (blist.PurpleBuddyList *list, blist.PurpleBlistNode *node):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "remove\n")

    try:
        if node.type == blist.PURPLE_BLIST_GROUP_NODE:
            __group_node_cb(node, blist_cbs["remove"])
        elif node.type == blist.PURPLE_BLIST_CONTACT_NODE:
            __contact_node_cb(node, blist_cbs["remove"])
        elif node.type == blist.PURPLE_BLIST_BUDDY_NODE:
            __buddy_node_cb(node, blist_cbs["remove"])
        elif node.type == blist.PURPLE_BLIST_CHAT_NODE:
            __chat_node_cb(node, blist_cbs["remove"])
        elif node.type == blist.PURPLE_BLIST_OTHER_NODE:
            __other_node_cb(node, blist_cbs["remove"])
    except KeyError:
        pass

cdef void destroy (blist.PurpleBuddyList *list):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "destroy\n")
    try:
        (<object>blist_cbs["destroy"])("destroy: TODO")
    except KeyError:
        pass

cdef void set_visible (blist.PurpleBuddyList *list, glib.gboolean show):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "set-visible\n")
    try:
        (<object>blist_cbs["set_visible"])("set-visible: TODO")
    except KeyError:
        pass

cdef void request_add_buddy (account.PurpleAccount *acc,
                             const_char *username, const_char *group,
                             const_char *alias):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "request-add-buddy\n")
    try:
        (<object>blist_cbs["request-add-buddy"])("request-add-buddy: TODO")
    except KeyError:
        pass

cdef void request_add_chat (account.PurpleAccount *acc,
                            blist.PurpleGroup *group, const_char *alias,
                            const_char *name):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "request_add_chat\n")
    try:
        (<object>blist_cbs["request-add-chat"])("request-add-chat: TODO")
    except KeyError:
        pass

cdef void request_add_group ():
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "request_add_group\n")
    try:
        (<object>blist_cbs["request-add-chat"])("request-add-group: TODO")
    except KeyError:
        pass
