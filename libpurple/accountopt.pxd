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

    ctypedef struct PurpleAccountUserSplit:
        char *text
        char *default_value
        char field_sep
        glib.gboolean reverse

    # Account Option API
    PurpleAccountOption *purple_account_option_new(prefs.PurplePrefType type, \
            char *text, char *pref_name)
    PurpleAccountOption *purple_account_option_bool_new(char *text, \
            char *pref_name, glib.gboolean default_value)
    PurpleAccountOption *purple_account_option_int_new(char *text, \
            char *pref_name, int default_value)
    PurpleAccountOption *purple_account_option_string_new(char *text, \
            char *pref_name,  char *default_value)
    PurpleAccountOption *purple_account_option_list_new(char *text, \
            char *pref_name, glib.GList *list)
    void purple_account_option_destroy(PurpleAccountOption *option)
    void purple_account_option_set_default_bool(PurpleAccountOption *option, \
            glib.gboolean value)
    void purple_account_option_set_default_int(PurpleAccountOption *option, \
            int value)
    void purple_account_option_set_default_string( \
            PurpleAccountOption *option, char *value)
    void purple_account_option_set_masked(PurpleAccountOption *option, \
            glib.gboolean masked)
    void purple_account_option_set_list(PurpleAccountOption *option, \
            glib.GList *values)
    void purple_account_option_add_list_item(PurpleAccountOption *option, \
            char *key,  char *value)
    prefs.PurplePrefType purple_account_option_get_type( \
            PurpleAccountOption *option)
    char *purple_account_option_get_text( PurpleAccountOption *option)
    char *purple_account_option_get_setting( PurpleAccountOption *option)
    glib.gboolean purple_account_option_get_default_bool( \
            PurpleAccountOption *option)
    int purple_account_option_get_default_int(PurpleAccountOption *option)
    char *purple_account_option_get_default_string(PurpleAccountOption *option)
    char *purple_account_option_get_default_list_value( \
            PurpleAccountOption *option)
    glib.gboolean purple_account_option_get_masked( \
            PurpleAccountOption *option)
    glib.GList *purple_account_option_get_list( \
            PurpleAccountOption *option)
    PurpleAccountUserSplit *purple_account_user_split_new(char *text, \
            char *default_value, char sep)
    void purple_account_user_split_destroy(PurpleAccountUserSplit *split)
    char *purple_account_user_split_get_text( PurpleAccountUserSplit *split)
    char *purple_account_user_split_get_default_value( \
            PurpleAccountUserSplit *split)
    char purple_account_user_split_get_separator(PurpleAccountUserSplit *split)
    glib.gboolean purple_account_user_split_get_reverse( \
            PurpleAccountUserSplit *split)
    void purple_account_user_split_set_reverse(PurpleAccountUserSplit *split, \
            glib.gboolean reverse)
