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

cimport prefs

cdef extern from *:
    ctypedef char const_char "const char"

cdef extern from "libpurple/accountopt.h":

    ctypedef struct UnionType:
        glib.gboolean boolean
        int integer
        char *string
        glib.GList *list

    ctypedef struct PurpleAccountOption:
        prefs.PurplePrefType type
        char *text
        char *pref_name
        UnionType default_value
        glib.gboolean masked

    prefs.PurplePrefType c_purple_account_option_get_type "purple_account_option_get_type" (PurpleAccountOption *option)
    char *c_purple_account_option_get_setting "purple_account_option_get_setting" (PurpleAccountOption *option)
    char *c_purple_account_option_get_default_string "purple_account_option_get_default_string" (PurpleAccountOption *option)
    int c_purple_account_option_get_default_int "purple_account_option_get_default_int" (PurpleAccountOption *option)
    glib.gboolean c_purple_account_option_get_default_bool "purple_account_option_get_default_bool" (PurpleAccountOption *option)
    const_char *c_purple_account_option_get_default_list_value "purple_account_option_get_default_list_value" (PurpleAccountOption *option)
    const_char *c_purple_account_option_get_text "purple_account_option_get_text" (PurpleAccountOption *option)
