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

cdef extern from "libpurple/status.h":
    ctypedef struct PurplePresence:
        pass

    ctypedef enum PurpleStatusPrimitive:
        PURPLE_STATUS_UNSET
        PURPLE_STATUS_OFFLINE
        PURPLE_STATUS_AVAILABLE
        PURPLE_STATUS_UNAVAILABLE
        PURPLE_STATUS_INVISIBLE
        PURPLE_STATUS_AWAY
        PURPLE_STATUS_EXTENDED_AWAY
        PURPLE_STATUS_MOBILE
        PURPLE_STATUS_TUNE
        PURPLE_STATUS_NUN_PRIMITIVE

    glib.gboolean c_purple_presence_is_online "purple_presence_is_online" (PurplePresence *presence)
