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
    ctypedef struct PurpleAccount:
        pass

    PurpleAccount *c_purple_account_new "purple_account_new" (const_char_ptr username, const_char_ptr protocol_id)
    void c_purple_account_set_username "purple_account_set_username" (PurpleAccount *account, const_char_ptr username)
    void c_purple_account_set_password "purple_account_set_password" (PurpleAccount *account, const_char_ptr password)
    void c_purple_account_set_enabled "purple_account_set_enabled" (PurpleAccount *account, const_char_ptr ui, gboolean value)

class Account(object):
    """ Account class """

    def __init__(self, username, protocol_id):
        cdef PurpleAccount *acc = c_purple_account_new(username, protocol_id)
        self.__acc = <object> acc
        acc = <PurpleAccount *> self.__acc

    """
    def purple_account_set_password(self, account, password):
        c_purple_account_set_password(account, password)

    def purple_account_set_enabled(self, account, ui, value):
        c_purple_account_set_enabled(account, ui, value)
    """
