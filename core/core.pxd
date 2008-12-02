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

cdef extern from "libpurple/core.h":
    ctypedef struct PurpleCoreUiOps

    cdef gboolean c_purple_core_init "purple_core_init" (const_char_ptr ui)
    cdef void c_purple_core_quit "purple_core_quit" ()
    cdef gboolean c_purple_core_migrate "purple_core_migrate" ()
    cdef void c_purple_core_set_ui_ops "purple_core_set_ui_ops" (PurpleCoreUiOps *ops)

class Core(object):
    """ Core class """

    def __init__(self):
        purple_core_ui_ops = None

    def purple_core_init(self, ui_name):
        return c_purple_core_init(ui_name)

    def purple_core_quit(self):
        c_purple_core_quit()

    def purple_core_migrate(self):
        return c_purple_core_migrate()

    # FIXME
    """
    def purple_core_set_ui_ops(ui_ops):
        c_purple_core_set_ui_ops(ui_ops)
    """
