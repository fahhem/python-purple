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

cdef class Buddy:
    """
    Buddy class
    @param name
    @param account
    """

    cdef object __account
    cdef object __name
    cdef object __exists

    def __init__(self, name, account):
        self.__name = name
        self.__account = account

        if self._get_structure() != NULL:
            self.__exists = True
        else:
            self.__exists = False

    cdef blist.PurpleBuddy *_get_structure(self):
        return blist.purple_find_buddy(account.purple_accounts_find( \
                self.__account.username, self.__account.protocol.id), \
                self.__name)

    def __get_exists(self):
        return self.__exists
    exists = property(__get_exists)

    def __get_name(self):
        if self.__exists:
            return <char *> blist.purple_buddy_get_name(self._get_structure())
        else:
            return self.__name
    name = property(__get_name)

    def __get_account(self):
        if self.__exists:
            return self.__account
        else:
            return None
    account = property(__get_account)

    def __get_alias(self):
        cdef char *c_alias = NULL
        c_alias = <char *> blist.purple_buddy_get_alias_only( \
                self._get_structure())
        if c_alias:
            return c_alias
        else:
            return None
    alias = property(__get_alias)

    def __get_server_alias(self):
        cdef char *c_server_alias = NULL
        c_server_alias = <char *> blist.purple_buddy_get_server_alias( \
                self._get_structure())
        if c_server_alias:
            return c_server_alias
        else:
            return None
    server_alias = property(__get_server_alias)

    def __get_contact_alias(self):
        cdef char *c_contact_alias = NULL
        c_contact_alias = <char *> blist.purple_buddy_get_contact_alias( \
                self._get_structure())
        if c_contact_alias:
            return c_contact_alias
        else:
            return None
    contact_alias = property(__get_contact_alias)

    def __get_local_alias(self):
        cdef char *c_local_alias = NULL
        c_local_alias = <char *> blist.purple_buddy_get_local_alias( \
                self._get_structure())
        if c_local_alias:
            return c_local_alias
        else:
            return None
    local_alias = property(__get_local_alias)

    def __get_available(self):
        if self.__exists:
            return status.purple_presence_is_available( \
                    blist.purple_buddy_get_presence(self._get_structure()))
        else:
            return None
    available = property(__get_available)

    def __get_online(self):
        if self.__exists:
            return status.purple_presence_is_online( \
                    blist.purple_buddy_get_presence(self._get_structure()))
        else:
            return None
    online = property(__get_online)

    def __get_idle(self):
        if self.__exists:
            return status.purple_presence_is_idle( \
                    blist.purple_buddy_get_presence(self._get_structure()))
        else:
            return None
    idle = property(__get_idle)

    def set_alias(self, alias):
        if self.__exists:
            blist.purple_blist_alias_buddy(self._get_structure(), alias)
            return True
        else:
            return False
