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
    """ Buddy class """
    cdef blist.PurpleBuddy *c_buddy
    cdef Account __acc

    def __init__(self):
        self.c_buddy = NULL

    def new_buddy(self, acc, char *scr, char *alias):
        self.__acc = acc
        self.c_buddy = blist.c_purple_buddy_new(<account.PurpleAccount *>\
                self.__acc.c_account, scr, alias)

    def __get_alias(self):
        return <char *>blist.c_purple_buddy_get_alias_only(self.c_buddy)
    alias = property(__get_alias)

    def __get_name(self):
        return <char *>blist.c_purple_buddy_get_name(self.c_buddy)
    name = property(__get_name)

    def __get_online(self):
        name = self.name
        self.c_buddy = blist.c_purple_find_buddy(self.__acc.c_account, name)
        return status.c_purple_presence_is_online(blist.c_purple_buddy_get_presence(self.c_buddy))
    online = property(__get_online)
