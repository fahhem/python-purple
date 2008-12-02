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

cdef extern from "libpurple/blist.h":
    ctypedef struct PurpleBuddyList

    cdef void c_purple_set_blist "purple_set_blist" (PurpleBuddyList *list)
    cdef void c_purple_blist_load "purple_blist_load" ()
    cdef PurpleBuddyList* purple_blist_new "purple_blist_new" ()

class BList(object):
    """ BList class """

    def __init__(self):
        purple_buddy_list = None

    # FIXME
    """
    def purple_set_blist(self, list):
        c_purple_set_blist(list)

    def purple_blist_load(self):
        c_purple_blist_load()

    def purple_blist_new(self):
        return c_purple_blist_new()
    """
