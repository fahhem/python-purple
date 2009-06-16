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

cimport accountopt
cimport plugin
cimport prefs
cimport prpl

cdef extern from *:
    ctypedef char const_char "const char"

cdef class Protocol:
    """
    Protocol class
    @param id
    """
    cdef object __id
    cdef object __exists

    def __init__(self, id):
        self.__id = id

        if self._get_structure() != NULL:
            self.__exists = True
        else:
            self.__exists = False

    cdef plugin.PurplePlugin *_get_structure(self):
        return plugin.purple_plugins_find_with_id(self.__id)

    def __get_exists(self):
        return self.__exists
    exists = property(__get_exists)

    def __get_id(self):
        return self.__id
    id = property(__get_id)

    def __get_name(self):
        cdef char *name = NULL
        if self.__exists:
            name = <char *> plugin.purple_plugin_get_name(self._get_structure())
            if name != NULL:
                return name
            else:
                return None
        return None
    name = property(__get_name)

    def __get_options_labels(self):
        cdef prpl.PurplePluginProtocolInfo *prpl_info
        cdef glib.GList *iter
        cdef accountopt.PurpleAccountOption *option
        cdef prefs.PurplePrefType type
        cdef const_char *label_name
        cdef const_char *setting

        if not self.__exists:
            return None

        prpl_info = plugin.PURPLE_PLUGIN_PROTOCOL_INFO(self._get_structure())

        po = {}

        iter = prpl_info.protocol_options

        while iter:

            option = <accountopt.PurpleAccountOption *> iter.data
            type = accountopt.purple_account_option_get_type(option)
            label_name = accountopt.purple_account_option_get_text(option)
            setting = accountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)
            label = str(<char *> label_name)

            iter = iter.next

            po[sett] = label

        return po
    options_labels = property(__get_options_labels)

    def __get_options_values(self):
        cdef prpl.PurplePluginProtocolInfo *prpl_info
        cdef glib.GList *iter
        cdef accountopt.PurpleAccountOption *option
        cdef prefs.PurplePrefType type
        cdef const_char *str_value
        cdef const_char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        if not self.__exists:
            return None

        prpl_info = plugin.PURPLE_PLUGIN_PROTOCOL_INFO(self._get_structure())

        po = {}

        iter = prpl_info.protocol_options

        while iter:

            option = <accountopt.PurpleAccountOption *> iter.data
            type = accountopt.purple_account_option_get_type(option)
            setting = accountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)

            if type == prefs.PURPLE_PREF_STRING:
                str_value = accountopt.purple_account_option_get_default_string(option)
                # Hack to set string "" as default value when the
                # protocol's option is NULL
                if str_value == NULL:
                    str_value = ""
                val = str(<char *> str_value)

            elif type == prefs.PURPLE_PREF_INT:
                int_value = accountopt.purple_account_option_get_default_int(option)
                val = int(int_value)

            elif type == prefs.PURPLE_PREF_BOOLEAN:
                bool_value = accountopt.purple_account_option_get_default_bool(option)

                val = bool(bool_value)

            elif type == prefs.PURPLE_PREF_STRING_LIST:
                str_value = accountopt.purple_account_option_get_default_list_value(option)

                val = str(<char *> str_value)

            iter = iter.next

            po[sett] = val

        return po
    options_values = property(__get_options_values)
