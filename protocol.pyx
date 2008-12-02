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

cimport purple

cdef class Protocol:
    """
    Protocol class
    @param protocol_id
    """

    def __init__(self, id):
        self.__id = id

        if self._get_structure() != NULL:
            self.__exists = True
        else:
            self.__exists = False

    cdef plugin.PurplePlugin *_get_structure(self):
        return plugin.purple_plugins_find_with_id(self.__protocol_id)

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
