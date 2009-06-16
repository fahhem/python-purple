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

signal_cbs = {}

cdef extern from *:
    ctypedef char const_gchar "const gchar"

cdef void signal_signed_on_cb(connection.PurpleConnection *gc, \
        glib.gpointer null):
    """
    Emitted when a connection has signed on.
    @params gc  The connection that has signed on.
    """
    cdef account.PurpleAccount *acc = connection.purple_connection_get_account(gc)
    cdef char *c_username = NULL
    cdef char *c_protocol_id = NULL

    c_username = <char *> account.purple_account_get_username(acc)
    if c_username == NULL:
        username = None
    else:
        username = c_username

    c_protocol_id = <char *> account.purple_account_get_protocol_id(acc)
    if c_protocol_id == NULL:
        protocol_id = None
    else:
        protocol_id = c_protocol_id

    if "signed-on" in signal_cbs:
        (<object> signal_cbs["signed-on"])(username, protocol_id)

cdef void signal_signed_off_cb(connection.PurpleConnection *gc, \
        glib.gpointer null):
    """
    Emitted when a connection has signed off.
    @params gc  The connection that has signed off.
    """
    cdef account.PurpleAccount *acc = connection.purple_connection_get_account(gc)
    cdef char *c_username = NULL
    cdef char *c_protocol_id = NULL

    c_username = <char *> account.purple_account_get_username(acc)
    if c_username == NULL:
        username = None
    else:
        username = c_username

    c_protocol_id = <char *> account.purple_account_get_protocol_id(acc)
    if c_protocol_id == NULL:
        protocol_id = None
    else:
        protocol_id = c_protocol_id

    if "signed-off" in signal_cbs:
        (<object> signal_cbs["signed-off"])(username, protocol_id)

cdef void signal_connection_error_cb(connection.PurpleConnection *gc, \
        connection.PurpleConnectionError err, const_gchar *c_desc):
    """
    Emitted when a connection error occurs, before signed-off.
    @params gc   The connection on which the error has occured
    @params err  The error that occured
    @params desc A description of the error, giving more information
    """
    cdef account.PurpleAccount *acc = connection.purple_connection_get_account(gc)
    cdef char *c_username = NULL
    cdef char *c_protocol_id = NULL

    c_username = <char *> account.purple_account_get_username(acc)
    if c_username:
        username = <char *> c_username
    else:
        username = None

    c_protocol_id = <char *> account.purple_account_get_protocol_id(acc)
    if c_protocol_id:
        protocol_id = <char *> c_protocol_id
    else:
        protocol_id = None

    short_desc = {
        0: "Network error",
        1: "Invalid username",
        2: "Authentication failed",
        3: "Authentication impossible",
        4: "No SSL support",
        5: "Encryption error",
        6: "Name in use",
        7: "Invalid settings",
        8: "SSL certificate not provided",
        9: "SSL certificate untrusted",
        10: "SSL certificate expired",
        11: "SSL certificate not activated",
        12: "SSL certificate hostname mismatch",
        13: "SSL certificate fingerprint mismatch",
        14: "SSL certificate self signed",
        15: "SSL certificate other error",
        16: "Other error" }[<int> err]

    if c_desc:
        desc = str(<char *> c_desc)
    else:
        desc = None

    if "connection-error" in signal_cbs:
        (<object> signal_cbs["connection-error"])(username, protocol_id, \
                short_desc, desc)

cdef void signal_buddy_signed_on_cb(blist.PurpleBuddy *buddy):
    """
    Emitted when a buddy on your buddy list signs on.
    @params buddy  The buddy that signed on.
    """
    cdef char *c_name = NULL
    cdef char *c_alias = NULL

    c_name = <char *> blist.purple_buddy_get_name(buddy)
    if c_name == NULL:
        name = None
    else:
        name = c_name

    c_alias = <char *> blist.purple_buddy_get_alias_only(buddy)
    if c_alias == NULL:
        alias = None
    else:
        alias = c_alias

    if "buddy-signed-on" in signal_cbs:
        (<object> signal_cbs["buddy-signed-on"])(name, alias)

cdef void signal_buddy_signed_off_cb(blist.PurpleBuddy *buddy):
    """
    Emitted when a buddy on your buddy list signs off.
    @params buddy  The buddy that signed off.
    """
    cdef char *c_name = NULL
    cdef char *c_alias = NULL

    c_name = <char *> blist.purple_buddy_get_name(buddy)
    if c_name == NULL:
        name = None
    else:
        name = c_name

    c_alias = <char *> blist.purple_buddy_get_alias_only(buddy)
    if c_alias == NULL:
        alias = None
    else:
        alias = c_alias

    if "buddy-signed-off" in signal_cbs:
        (<object> signal_cbs["buddy-signed-off"])(name, alias)

cdef glib.gboolean signal_receiving_im_msg_cb(account.PurpleAccount *account, \
        char **sender, char **message, conversation.PurpleConversation *conv, \
        conversation.PurpleMessageFlags *flags):
    """
    Emitted when an IM is received. The callback can replace the name of the
    sender, the message, or the flags by modifying the pointer to the strings
    and integer. This can also be used to cancel a message by returning TRUE.
    @note Make sure to free *sender and *message before you replace them!
    @returns TRUE if the message should be canceled, or FALSE otherwise.
    @params account  The account the message was received on.
    @params sender   A pointer to the username of the sender.
    @params message  A pointer to the message that was sent.
    @params conv     The IM conversation.
    @params flags    A pointer to the IM message flags.
    """
    cdef blist.PurpleBuddy *buddy = blist.purple_find_buddy(account, sender[0])
    cdef char *c_alias = NULL

    c_alias = <char *> blist.purple_buddy_get_alias_only(buddy)
    if c_alias == NULL:
        alias = None
    else:
        alias = c_alias

    stripped = util.purple_markup_strip_html(message[0])

    if "receiving-im-msg" in signal_cbs:
        return (<object> signal_cbs["receiving-im-msg"])(sender[0], alias, stripped)

cdef void jabber_receiving_xmlnode_cb(connection.PurpleConnection *gc, \
        xmlnode.xmlnode **packet, glib.gpointer null):
    """
    Emitted when jabber receives a XML node.
    """
    message = xmlnode.xmlnode_to_str(packet[0], NULL)

    if "jabber-receiving-xmlnode" in signal_cbs:
        (<object> signal_cbs["jabber-receiving-xmlnode"])(message)
