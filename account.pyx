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

cimport account
cimport blist
cimport savedstatuses
cimport status

cdef class Account:
    """ Account class """
    cdef account.PurpleAccount *__account
    cdef savedstatuses.PurpleSavedStatus *__sstatus

    def __cinit__(self, char *username, char *protocol_id):
        self.__account = account.c_purple_account_new(username, protocol_id)

    def set_password(self, password):
        account.c_purple_account_set_password(self.__account, password)

    def set_enabled(self, ui, value):
        account.c_purple_account_set_enabled(self.__account, ui, value)

    def get_acc_username(self):
        if self.__account:
            return account.c_purple_account_get_username(self.__account)

    def get_password(self):
        if self.__account:
            return account.c_purple_account_get_password(self.__account)

    def set_status(self):
        self.__sstatus = savedstatuses.c_purple_savedstatus_new(NULL, status.PURPLE_STATUS_AVAILABLE)
        savedstatuses.c_purple_savedstatus_activate(self.__sstatus)

    def get_buddies_online(self, acc):
        cdef glib.GSList *iter
        cdef blist.PurpleBuddy *buddy
        buddies = []
        iter = blist.c_purple_find_buddies(self.__account, NULL)
        while iter:
            buddy = <blist.PurpleBuddy *> iter.data
            if <object> buddy and \
                account.c_purple_account_is_connected(blist.c_purple_buddy_get_account(buddy)) and \
                status.c_purple_presence_is_online(blist.c_purple_buddy_get_presence(buddy)):
                buddies += [buddy.name]
            iter = iter.next
        return buddies
