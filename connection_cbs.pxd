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

cdef extern from *:
    ctypedef char const_char "const char"

connection_cbs = {}

cdef extern from *:
    ctypedef int size_t

cdef void connect_progress(connection.PurpleConnection *gc, const_char *text, \
        size_t step, size_t step_count):
    """
    When an account is connecting, this operation is called to notify the UI
    of what is happening, as well as which a step out of step_count has been
    reached (which might be displayed as a progress bar).
    """
    debug.purple_debug_info("connection", "%s", "connect-progress\n")
    if "connect-progress" in connection_cbs:
        (<object> connection_cbs["connect-progress"]) \
            (<char *> text, step, step_count)

cdef void connected(connection.PurpleConnection *gc):
    """
    Called when a connection is established (just before the signed-on signal).
    """
    debug.purple_debug_info("connection", "%s", "connected")
    if "connected" in connection_cbs:
        (<object> connection_cbs["connected"])("connected: TODO")

cdef void disconnected(connection.PurpleConnection *gc):
    """
    Called when a connection is ended (between the signing-off and signed-off
    signal).
    """
    debug.purple_debug_info("connection", "%s", "disconnected")
    if "disconnected" in connection_cbs:
        (<object> connection_cbs["disconnected"])("disconnected: TODO")

cdef void notice(connection.PurpleConnection *gc, const_char *text):
    """
    Used to display connection-specific notices. (Pidgin's Gtk user interface
    implements this as a no-op; purple_connection_notice(), which uses this
    operation, is not used by any of the protocols shipped with libpurple.)
    """
    debug.purple_debug_info("connection", "%s", "notice")
    if "notice" in connection_cbs:
        (<object> connection_cbs["notice"])("notice: TODO")

cdef void report_disconnect(connection.PurpleConnection *gc, const_char *text):
    """
    Called when an error causes a connection to be disconnected.
    Called before disconnected.
    @param text  a localized error message.
    @see purple_connection_error
    @deprecated in favour of
                PurpleConnectionUiOps.report_disconnect_reason.
    """
    debug.purple_debug_info("connection", "%s", "report-disconnect\n")
    if "report-disconnect" in connection_cbs:
        (<object> connection_cbs["report-disconnect"])(<char *> text)

cdef void network_connected():
    """
    Called when libpurple discovers that the computer's network connection
    is active. On Linux, this uses Network Manager if available; on Windows,
    it uses Win32's network change notification infrastructure.
    """
    debug.purple_debug_info("connection", "%s", "network-connected\n")
    if "network-connected" in connection_cbs:
        (<object> connection_cbs["network-connected"])()

cdef void network_disconnected():
    """
    Called when libpurple discovers that the computer's network connection
    has gone away.
    """
    debug.purple_debug_info("connection", "%s", "network-disconnected\n")
    if "network-disconnected" in connection_cbs:
        (<object> connection_cbs["network-disconnected"])()

cdef void report_disconnect_reason(connection.PurpleConnection *gc, \
        connection.PurpleConnectionError reason, const_char *c_text):
    """
    Called when an error causes a connection to be disconnected. Called
    before disconnected. This op is intended to replace report_disconnect.
    If both are implemented, this will be called first; however, there's no
    real reason to implement both.
    @param reason  why the connection ended, if known, or
                   PURPLE_CONNECTION_ERROR_OTHER_ERROR, if not.
    @param text  a localized message describing the disconnection
                 in more detail to the user.
    @see purple_connection_error_reason
    @since 2.3.0
    """
    debug.purple_debug_info("connection", "%s", "report-disconnect-reason\n")

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

    if c_text:
        text = <char *> c_text
    else:
        text = None

    if "report-disconnect-reason" in connection_cbs:
        (<object> connection_cbs["report-disconnect-reason"]) \
            (reason_string, <char *> text)
