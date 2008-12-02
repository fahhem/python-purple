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

class ProxyType:
    def __init__(self):
        self.PROXY_USE_GLOBAL = -1
        self.PROXY_NONE = 0
        self.PROXY_HTTP = 1
        self.PROXY_SOCKS4 = 2
        self.PROXY_SOCKS5 = 3
        self.PROXY_USE_ENVVAR = 4


class StatusPrimitive:
    def __init__(self):
        self.STAUTS_UNSET = 0
        self.STATUS_OFFLINE = 1
        self.STATUS_AVAILABLE = 2
        self.STATUS_UNAVAILABLE = 3
        self.STATUS_INVISIBLE = 4
        self.STATUS_AWAY = 5
        self.STATUS_EXTENDED_AWAY = 6
        self.STATUS_MOBILE = 7
        self.STATUS_TUNE = 8
        self.STATUS_NUN_PRIMITIVE = 9

cdef class Account:
    """ Account class """
    cdef PurpleAccount *__account
    cdef PurpleSavedStatus *__sstatus

    def __cinit__(self, const_char_ptr username, const_char_ptr protocol_id):
        self.__account = c_purple_account_new(username, protocol_id)

    def set_password(self, password):
        c_purple_account_set_password(self.__account, password)

    def set_enabled(self, ui, value):
        c_purple_account_set_enabled(self.__account, ui, value)

    def get_acc_username(self):
        if self.__account:
            return c_purple_account_get_username(self.__account)

    def get_password(self):
        if self.__account:
            return c_purple_account_get_password(self.__account)

    def set_status(self):
        self.__sstatus = c_purple_savedstatus_new(NULL, StatusPrimitive().STATUS_AVAILABLE)
        c_purple_savedstatus_activate(self.__sstatus)

