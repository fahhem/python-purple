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
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "signal",
                         "buddy_signed_off\n")
    try:
        (<object>signal_cbs["buddy_signed_off"])(buddy.name)
    except KeyError:
        pass

cdef glib.gboolean signal_receiving_im_msg_cb (account.PurpleAccount *account,
                                        char **sender,
                                        char **message,
                                        conversation.PurpleConversation *conv,
                                        conversation.PurpleMessageFlags *flags):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "signal",
                         "receivinv_im_msg_cb\n")
    try:
        (<object>signal_cbs["receiving_im_msg"])(sender[0], message[0])
    except KeyError:
        pass