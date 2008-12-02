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

connection_cbs = {}

cdef extern from *:
    ctypedef int size_t

cdef void connect_progress (connection.PurpleConnection *gc, const_char *text,
                            size_t step, size_t step_count):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "connect-progress\n")
    try:
        (<object>connection_cbs["connect-progress"])(<char *>text, step, step_count)
    except KeyError:
        pass

cdef void connected (connection.PurpleConnection *gc):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "connected\n")
    try:
        (<object>connection_cbs["connected"])("connected: TODO")
    except KeyError:
        pass

cdef void disconnected (connection.PurpleConnection *gc):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "disconnected\n")
    try:
        (<object>connection_cbs["disconnected"])("disconnected: TODO")
    except KeyError:
        pass

cdef void notice (connection.PurpleConnection *gc, const_char *text):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "notice\n")
    try:
        (<object>connection_cbs["notice"])("notice: TODO")
    except KeyError:
        pass

cdef void report_disconnect (connection.PurpleConnection *gc,
                             const_char *text):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "report-disconnect\n")
    try:
        (<object>connection_cbs["report-disconnect"])(<char *>text)
    except KeyError:
        pass

cdef void network_connected ():
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "network-connected\n")
    try:
        (<object>connection_cbs["network-connected"])("network-connected: TODO")
    except KeyError:
        pass

cdef void network_disconnected ():
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "network-disconnected\n")
    try:
        (<object>connection_cbs["network-disconnected"])("network-disconnected: TODO")
    except KeyError:
        pass

cdef void report_disconnect_reason (connection.PurpleConnection *gc,
                                    connection.PurpleConnectionError reason,
                                    const_char *text):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "report-disconnect-reason\n")

    reason_string = {
        0: 'Network error',
        1: 'Invalid username',
        2: 'Authentication failed',
        3: 'Authentication impossible',
        4: 'No SSL support',
        5: 'Encryption error',
        6: 'Name in use',
        7: 'Invalid settings',
        8: 'Certificate not provided',
        9: 'Certificate untrusted',
        10: 'Certificate expired',
        11: 'Certificate not activated',
        12: 'Certificate hostname mismatch',
        13: 'Certificate fingerprint mismatch',
        14: 'Certificate self signed',
        15: 'Certificate error (other)',
        16: 'Other error' }[reason]

    try:
        (<object>connection_cbs["report-disconnect-reason"])(reason_string, <char *>text)
    except KeyError:
        pass
