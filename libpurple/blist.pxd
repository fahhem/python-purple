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
    ctypedef struct PurpleBlistNode:
        pass

    ctypedef struct PurpleBlistUiOps:
        pass

    ctypedef struct PurpleBuddy:
        pass

    ctypedef struct PurpleBuddyList:
        pass

    void *c_purple_blist_get_handle "purple_blist_get_handle" ()
    void c_purple_blist_load "purple_blist_load" ()
    PurpleBuddyList* c_purple_blist_new "purple_blist_new" ()
    void c_purple_blist_set_ui_ops "purple_blist_set_ui_ops" (PurpleBlistUiOps *ops)

    PurpleBuddy *c_purple_buddy_new "purple_buddy_new" (PurpleAccount *account,
            const_char_ptr screenname, const_char_ptr alias)
    const_char_ptr c_purple_buddy_get_alias_only "purple_buddy_get_alias_only" (PurpleBuddy *buddy)
    const_char_ptr c_purple_buddy_get_name "purple_buddy_get_name" (PurpleBuddy *buddy)
    PurpleBuddy *c_purple_find_buddy "purple_find_buddy" (PurpleAccount *account,
            const_char_ptr name)
    void c_purple_set_blist "purple_set_blist" (PurpleBuddyList *list)
