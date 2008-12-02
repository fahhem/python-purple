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

cdef extern from "libpurple/account.h":
    cdef struct _PurpleAccount
    ctypedef _PurpleAccount PurpleAccount

    PurpleAccount *purple_account_new(const_char_ptr username, const_char_ptr protocol_id)
    void purple_account_set_password(PurpleAccount *account, const_char_ptr password)
    void purple_account_set_enabled(PurpleAccount *account, const_char_ptr ui, gboolean value)

cdef extern from "libpurple/status.h":
    ctypedef int PurpleStatusPrimitive

    cdef struct _PurpleSavedStatus
    ctypedef _PurpleSavedStatus PurpleSavedStatus

    PurpleSavedStatus *purple_saved_status_new(const_char_ptr title, PurpleStatusPrimitive type)
    void purple_saved_status_activate(PurpleSavedStatus *saved_status)

cdef extern from "libpurple/proxy.h":
    cdef struct PurpleProxyInfo

    ctypedef int PurpleProxyType
    PurpleProxyInfo *purple_proxy_info_new()
    void c_purple_proxy_info_set_type "purple_proxy_info_set_type" (PurpleProxyInfo *info, PurpleProxyType type)
    void c_purple_proxy_info_set_host "purple_proxy_info_set_host" (const_char_ptr host)
    void c_purple_proxy_info_set_port "purple_proxy_info_set_port" (const_char_ptr port)


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

    def __cinit__(self, const_char_ptr username, const_char_ptr protocol_id):
        self.__account = purple_account_new(username, protocol_id)
        """FIXME: Check status implementation"""
#        self.__sstatus = purple_saved_status_new("on-line", StatusPrimitive().STATUS_AVAILABLE)
#        purple_saved_status_activate(self.__sstatus)

    def set_password(self, password):
        purple_account_set_password(self.__account, password)

    def set_enabled(self, ui, value):
        purple_account_set_enabled(self.__account, ui, value)
