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

cdef extern from "libpurple/debug.h":

    # Debug levels
    ctypedef enum PurpleDebugLevel:
        PURPLE_DEBUG_ALL = 0
        PURPLE_DEBUG_MISC
        PURPLE_DEBUG_INFO
        PURPLE_DEBUG_WARNING
        PURPLE_DEBUG_ERROR
        PURPLE_DEBUG_FATAL

    # Debug UI operations FIXME
    #ctypedef struct PurpleDebugUiOps:
        #void (*print)(PurpleDebugLevel level, char *category, char *arg_s)
        #glib.gboolean (*is_enabled)(PurpleDebugLevel level, char *category)

    # Debug API
    void purple_debug(PurpleDebugLevel level, char *category, \
            char *format_type, char *format)
    void purple_debug_misc(char *category, char *format_type, \
            char *format)
    void purple_debug_info(char *category, char *format_type, \
            char *format)
    void purple_debug_warning(char *category, char *format_type, \
            char *format)
    void purple_debug_error (char *category, char *format_type, \
            char *format)
    void purple_debug_fatal (char *category, char *format_type, \
            char *format)
    void purple_debug_set_enabled(glib.gboolean enabled)
    glib.gboolean purple_debug_is_enabled()

    # UI Registration Functions FIXME
    #void purple_debug_set_ui_ops(PurpleDebugUiOps *ops)
    #PurpleDebugUiOps *purple_debug_get_ui_ops(void)

    # Debug Subsystem
    void purple_debug_init()
