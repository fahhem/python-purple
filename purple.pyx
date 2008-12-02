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

cdef extern from "glib-2.0/glib.h":
    ctypedef gboolean

cdef extern from *:
    ctypedef char* const_char_ptr "const char *"

include "core/account.pxd"
include "core/blist.pxd"
include "core/connection.pxd"
include "core/core.pxd"
include "core/debug.pxd"
include "core/eventloop.pxd"
include "core/idle.pxd"
include "core/plugin.pxd"
include "core/pounce.pxd"
include "core/prefs.pxd"
include "core/util.pxd"
