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

signal_cbs = {}

cdef void signal_signed_on_cb (connection.PurpleConnection *gc, \
                               glib.gpointer null):
    cdef account.PurpleAccount *acc = connection.c_purple_connection_get_account(gc)
    cdef char *c_username = NULL
    cdef char *c_protocol_id = NULL

    c_username = <char *> account.c_purple_account_get_username(acc)
    if c_username == NULL:
        username = None
    else:
        username = c_username

    c_protocol_id = <char *> account.c_purple_account_get_protocol_id(acc)
    if c_protocol_id == NULL:
        protocol_id = None
    else:
        protocol_id = c_protocol_id

    try:
        (<object> signal_cbs["signed-on"])(username, protocol_id)
    except KeyError:
        pass

cdef void signal_signed_off_cb (connection.PurpleConnection *gc, \
                               glib.gpointer null):
    cdef account.PurpleAccount *acc = connection.c_purple_connection_get_account(gc)
    cdef char *c_username = NULL
    cdef char *c_protocol_id = NULL

    c_username = <char *> account.c_purple_account_get_username(acc)
    if c_username == NULL:
        username = None
    else:
        username = c_username

    c_protocol_id = <char *> account.c_purple_account_get_protocol_id(acc)
    if c_protocol_id == NULL:
        protocol_id = None
    else:
        protocol_id = c_protocol_id

    try:
        (<object> signal_cbs["signed-off"])(username, protocol_id)
    except KeyError:
        pass

cdef void signal_buddy_signed_on_cb (blist.PurpleBuddy *buddy):
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
        (<object> signal_cbs["buddy-signed-on"])(name, alias)
    except KeyError:
        pass

cdef void signal_buddy_signed_off_cb (blist.PurpleBuddy *buddy):
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
        (<object> signal_cbs["buddy-signed-off"])(name, alias)
    except KeyError:
        pass

cdef glib.gboolean signal_receiving_im_msg_cb (account.PurpleAccount *account,
        char **sender, char **message, conversation.PurpleConversation *conv,
        conversation.PurpleMessageFlags *flags):
    cdef blist.PurpleBuddy *buddy = blist.c_purple_find_buddy(account, sender[0])
    cdef char *c_alias = NULL

    c_alias = <char *> blist.c_purple_buddy_get_alias_only(buddy)
    if c_alias == NULL:
        alias = None
    else:
        alias = c_alias

    stripped = util.c_purple_markup_strip_html(message[0])

    try:
        return (<object> signal_cbs["receiving-im-msg"])(sender[0], alias, stripped)
    except KeyError:
        return False

cdef void jabber_receiving_xmlnode_cb (connection.PurpleConnection *gc,
        xmlnode.xmlnode **packet, glib.gpointer null):

    message = xmlnode.xmlnode_to_str(packet[0], NULL)

    try:
        (<object> signal_cbs["jabber-receiving-xmlnode"])(message)
    except KeyError:
        pass
