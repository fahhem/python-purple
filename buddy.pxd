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

cdef class Buddy:
    """ Buddy class """
    cdef PurpleBuddy *__buddy

    def __cinit__(self):
        self.__buddy = NULL

    def new_buddy(self, acc, const_char_ptr scr, const_char_ptr alias):
        self.__buddy = c_purple_buddy_new(<PurpleAccount *>acc.__account, scr, alias)

    def get_alias(self):
        return c_purple_buddy_get_alias_only(self.__buddy)

    def get_name(self):
        return c_purple_buddy_get_name(self.__buddy)
