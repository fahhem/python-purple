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
                         "connect_progress\n")
    global connection_cbs
    try:
        (<object>connection_cbs["connect_progress"])("connect_progress")
    except KeyError:
        pass

cdef void connected (connection.PurpleConnection *gc):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "connected\n")
    global connection_cbs
    try:
        (<object>connection_cbs["connected"])("connected")
    except KeyError:
        pass

cdef void disconnected (connection.PurpleConnection *gc):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "disconnected\n")
    global connection_cbs
    try:
        (<object>connection_cbs["disconnected"])("disconnected")
    except KeyError:
        pass

cdef void notice (connection.PurpleConnection *gc, const_char *text):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "notice\n")
    global connection_cbs
    try:
        (<object>connection_cbs["notice"])("notice")
    except KeyError:
        pass

cdef void report_disconnect (connection.PurpleConnection *gc,
                             const_char *text):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "report_disconnect\n")
    global connection_cbs
    try:
        (<object>connection_cbs["report_disconnect"])("report_disconnect")
    except KeyError:
        pass

cdef void network_connected ():
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "network_connected\n")
    global connection_cbs
    try:
        (<object>connection_cbs["network_connected"])("network_connected")
    except KeyError:
        pass

cdef void network_disconnected ():
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "network_disconnected\n")
    global connection_cbs
    try:
        (<object>connection_cbs["network_disconnected"])("network_disconnected")
    except KeyError:
        pass

cdef void report_disconnect_reason (connection.PurpleConnection *gc,
                                    connection.PurpleConnectionError reason,
                                    const_char *text):
    debug.c_purple_debug(debug.PURPLE_DEBUG_INFO, "connection",
                         "report_disconnect_reason\n")
    global connection_cbs
    try:
        (<object>connection_cbs["report_disconnect_reason"])("report_disconnect_reason")
    except KeyError:
        pass
