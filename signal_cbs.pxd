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

cdef void signal_buddy_signed_off_cb (blist.PurpleBuddy *buddy):
    if buddy.server_alias:
        name = buddy.server_alias
    elif buddy.alias:
        name = buddy.alias
    else:
        name = buddy.name

    try:
        (<object> signal_cbs["buddy-signed-off"])(name, buddy.name)
    except KeyError:
        pass

cdef glib.gboolean signal_receiving_im_msg_cb (account.PurpleAccount *account,
        char **sender, char **message, conversation.PurpleConversation *conv,
        conversation.PurpleMessageFlags *flags):
    cdef blist.PurpleBuddy *buddy = blist.c_purple_find_buddy(account, sender[0])

    if buddy.server_alias:
        name = buddy.server_alias
    elif buddy.alias:
        name = buddy.alias
    else:
        name = buddy.name

    stripped = util.c_purple_markup_strip_html(message[0])

    try:
        return (<object> signal_cbs["receiving-im-msg"])(sender[0], name, stripped)
    except KeyError:
        return False

cdef void jabber_receiving_xmlnode_cb (connection.PurpleConnection *gc,
        xmlnode.xmlnode **packet, glib.gpointer null):

    message = xmlnode.xmlnode_to_str(packet[0], NULL)

    try:
        (<object> signal_cbs["jabber-receiving-xmlnode"])(message)
    except KeyError:
        pass
