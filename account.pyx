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

from protocol import Protocol

cdef class Account:
    """
    Account class
    @param username
    @param protocol_id
    """

    def __init__(self, username, protocol_id):
        self.__username = username
        self.__protocol = Protocol(self, protocol_id)

        if self._get_structure() == NULL:
            self.__exists = False
        else:
            self.__exists = True

    cdef account.PurpleAccount *_get_structure(self):
        return account.purple_accounts_find(self.username, \
                self.protocol_id)

    def __get_exists(self):
        return self.__exists
    exists = property(__get_exists)

    def __get_username(self):
        cdef char *username = NULL
        if self.__exists:
            username = <char *> account.purple_account_get_username( \
                    self._get_structure())
            if username:
                return username
            else:
                return None
        else:
            return self.__username
    username = property(__get_username)

    def __get_protocol_id(self):
        cdef char *protocol_id = NULL
        if self.__exists:
            protocol_id = <char *> account.purple_account_get_protocol_id( \
                    self._get_structure())
            if protocol_id:
                return protocol_id
            else:
                return None
        else:
            return self.protocol_id
    protocol_id = property(__get_protocol_id)

    def __get_password(self):
        cdef char *password = NULL
        if self.__exists:
            password = <char *> account.purple_account_get_password( \
                    self._get_structure())
            if password:
                return password
            else:
                return None
        else:
            return None
    def __set_password(self, password):
        if self.__exists:
            account.purple_account_set_password(self._get_structure(), \
                    password)
            return True
        else:
            return False
    password = property(__get_password, __set_password)

    def __get_alias(self):
        cdef char *alias = NULL
        if self.__exists:
            alias = <char *> account.purple_account_get_alias(self._get_structure())
            if alias:
                return alias
            else:
                return None
        else:
            return None
    def __set_alias(self, alias):
        if self.__exists:
            account.purple_account_set_alias(self._get_structure(), \
                    alias)
            return True
        else:
            return False
    alias = property(__get_alias, __set_alias)

    def __get_user_info(self):
        cdef char *user_info = NULL
        if self.__exists:
            user_info = <char *> account.purple_account_get_user_info(self._get_structure())
            if user_info:
                return user_info
            else:
                return None
        else:
            return None
    def __set_user_info(self, user_info):
        if self.__exists:
            account.purple_account_set_user_info(self._get_structure(), \
                    user_info)
            return True
        else:
            return False
    user_info = property(__get_user_info, __set_user_info)

    def __get_remember_password(self):
        if self.__exists:
            return account.purple_account_get_remember_password( \
                    self._get_structure())
        else:
            return None
    def __set_remember_password(self, remember_password):
        if self.__exists:
            account.purple_account_set_remember_password( \
                self._get_structure(), remember_password)
            return True
        else:
            return False
    remember_password = property(__get_remember_password, \
            __set_remember_password)

    def set_username(self, username):
        if self.__exists:
            account.purple_account_set_username(self._get_structure(), \
                    username)
            return True
        else:
            return False

    def set_protocol_id(self, protocol_id):
        if self.__exists:
            self.__protocol._set_protocol_id(protocol_id)
            return True
        else:
            return False

    def new(self):
        if self.__exists:
            return False
        else:
            account.purple_account_new(self.username, self.protocol_id)
            self.__exists = True
            return True
