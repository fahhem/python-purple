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

    if group.name:
        name = group.name
    else:
        name = None

    try:
        callback(node.type, name, group.totalsize, group.currentsize, \
                 group.online)
    except KeyError:
        pass

cdef void __contact_node_cb(blist.PurpleBlistNode *node, object callback):
    cdef blist.PurpleContact *contact = <blist.PurpleContact *>node

    if contact.alias:
        alias = contact.alias
    else:
        alias = None

    try:
        callback(node.type, alias, contact.totalsize, contact.currentsize, \
                 contact.online)
    except KeyError:
        pass

cdef void __buddy_node_cb(blist.PurpleBlistNode *node, object callback):
    cdef blist.PurpleBuddy *buddy = <blist.PurpleBuddy *>node

    if buddy.server_alias:
        alias = buddy.server_alias
    elif buddy.alias:
        alias = buddy.alias
    else:
        alias = None

    if buddy.name:
        name = buddy.name
    else:
        name = None

    try:
        callback(node.type, name, alias)
    except KeyError:
        pass

cdef void __chat_node_cb(blist.PurpleBlistNode *node, object callback):
    cdef blist.PurpleChat *chat = <blist.PurpleChat *>node

    if chat.alias:
        alias = chat.alias
    else:
        alias = None

    try:
        callback(node.type, alias)
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
        else:
            (<object>blist_cbs["new_node"])(node.type)
    except KeyError:
        pass

cdef void show (blist.PurpleBuddyList *list):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "show\n")
    try:
        (<object>blist_cbs["show"])("show")
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
        else:
            (<object>blist_cbs["update"])(node.type)
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
        else:
            (<object>blist_cbs["remove"])(node.type)
    except KeyError:
        pass

cdef void destroy (blist.PurpleBuddyList *list):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "destroy\n")
    try:
        (<object>blist_cbs["destroy"])("destroy")
    except KeyError:
        pass

cdef void set_visible (blist.PurpleBuddyList *list, glib.gboolean show):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "set_visible\n")
    try:
        (<object>blist_cbs["set_visible"])("set_visible")
    except KeyError:
        pass

cdef void request_add_buddy (account.PurpleAccount *account,
                             const_char *username, const_char *group,
                             const_char *alias):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "request_add_buddy\n")
    try:
        (<object>blist_cbs["request_add_buddy"])("request_add_buddy")
    except KeyError:
        pass

cdef void request_add_chat (account.PurpleAccount *account,
                            blist.PurpleGroup *group, const_char *alias,
                            const_char *name):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "request_add_chat\n")
    try:
        (<object>blist_cbs["request_add_chat"])("request_add_chat")
    except KeyError:
        pass

cdef void request_add_group ():
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "blist", "request_add_group\n")
    try:
        (<object>blist_cbs["request_add_chat"])("request_add_group")
    except KeyError:
        pass
