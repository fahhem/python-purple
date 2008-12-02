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

cdef extern from "libpurple/prefs.h":

    ctypedef enum PurplePrefType:
        PURPLE_PREF_NONE
        PURPLE_PREF_BOOLEAN
        PURPLE_PREF_INT
        PURPLE_PREF_STRING
        PURPLE_PREF_STRING_LIST
        PURPLE_PREF_PATH
        PURPLE_PREF_PATH_LIST

    void purple_prefs_add_none(char *name)
    void purple_prefs_rename(char *oldname, char *newname)
    char *purple_prefs_get_string(char *name)
    glib.gboolean purple_prefs_load()
    void purple_prefs_add_bool(char *name, glib.gboolean value)
    void purple_prefs_set_int(char *name, int value)
