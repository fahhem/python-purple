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

cimport account

cdef extern from "libpurple/connection.h":
    ctypedef struct PurpleConnection:
        pass

    ctypedef struct PurpleConnectionUiOps:
        pass

    account.PurpleAccount *c_purple_connection_get_account "purple_connection_get_account" (PurpleConnection *gc)
    void *c_purple_connections_get_handle "purple_connections_get_handle" ()
    void c_purple_connections_set_ui_ops "purple_connections_set_ui_ops" (PurpleConnectionUiOps *ops)
