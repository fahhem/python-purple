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

cdef extern from "libpurple/core.h":
    ctypedef struct PurpleCoreUiOps:
        void (*ui_prefs_init) ()
        void (*debug_ui_init) ()
        void (*ui_init) ()
        void (*quit) ()
        glib.GHashTable* (*get_ui_info) ()

    glib.gboolean purple_core_init(char *ui_name)
    void purple_core_quit()
    void purple_core_set_ui_ops(PurpleCoreUiOps *ops)
    glib.gboolean purple_core_ensure_single_instance()
