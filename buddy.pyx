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

cimport account
cimport blist
cimport status

cdef class Buddy:
    '''Buddy class

    @param name Buddy's name.
    @param account Buddy's account.
    '''

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
        '''Returns the buddy's C struct from purple.

        @return A pointer to buddy's C struct from purple.
        '''

        return blist.purple_find_buddy(account.purple_accounts_find( \
                self.__account.username, self.__account.protocol.id), \
                self.__name)

    def __get_exists(self):
        '''Answer if exists corresponding buddy in the purple.

        @return True if buddy is a valid buddy of False otherwise.
        '''

        return self.__exists
    exists = property(__get_exists)

    def __get_name(self):
        '''Returns the buddy's name.

        @return Buddy's name.
        '''

        if self.__exists:
            return <char *> blist.purple_buddy_get_name(self._get_structure())
        else:
            return self.__name
    name = property(__get_name)

    def __get_alias(self):
        '''Returns the buddy's alias

        @return Buddy alias(if set) or None
        '''

        cdef char *c_alias = NULL
        c_alias = <char *> blist.purple_buddy_get_alias_only( \
                self._get_structure())
        if c_alias:
            return unicode(c_alias, 'utf-8')
        else:
            return None
    alias = property(__get_alias)

    def __get_account(self):
        '''Returns the buddy's account.

        @return The account(if buddy exists) or None.
        '''

        if self.__exists:
            return self.__account
        else:
            return None
    account = property(__get_account)

    def __get_group(self):
        '''Returns the buddy's group.

        @return The group or None if buddy is not in a group.
        '''

        cdef blist.PurpleGroup *c_group = NULL
        if self.__exists:
            c_group = blist.purple_buddy_get_group(self._get_structure())
            return <char *> blist.purple_group_get_name(c_group)
        else:
            return None
    group = property(__get_group)

    def __get_server_alias(self):
        '''Gets the server alias of the buddy.

        @return  The server alias, or None if it is not set.
        '''

        cdef char *c_server_alias = NULL
        c_server_alias = <char *> blist.purple_buddy_get_server_alias( \
                self._get_structure())
        if c_server_alias:
            return c_server_alias
        else:
            return None
    server_alias = property(__get_server_alias)

    def __get_contact_alias(self):
        '''Returns the correct name to display for a buddy, taking the contact
           alias into account. In order of precedence: the buddy's alias;
           the buddy's contact alias; the buddy's server alias; the buddy's
           user name.

        @return The appropriate name or alias, or None.
        '''

        cdef char *c_contact_alias = NULL
        c_contact_alias = <char *> blist.purple_buddy_get_contact_alias( \
                self._get_structure())
        if c_contact_alias:
            return c_contact_alias
        else:
            return None
    contact_alias = property(__get_contact_alias)

    def __get_local_alias(self):
        '''Returns the correct alias for this user, ignoring server aliases.
           Used when a user-recognizable name is required.  In order: buddy's
           alias; buddy's contact alias; buddy's user name.

        @return The appropriate name or alias, or None.
        '''

        cdef char *c_local_alias = NULL
        c_local_alias = <char *> blist.purple_buddy_get_local_alias( \
                self._get_structure())
        if c_local_alias:
            return c_local_alias
        else:
            return None
    local_alias = property(__get_local_alias)

    def __get_available(self):
        '''Returns whether or not buddy's presence is available.
        Available presences are online and possibly invisible, but not away or idle.

        @return True if the buddy's presence is available, or False otherwise.
        '''

        if self.__exists:
            return status.purple_presence_is_available( \
                    blist.purple_buddy_get_presence(self._get_structure()))
        else:
            return False
    available = property(__get_available)

    def __get_online(self):
        '''Returns whether or not the buddy's presence is online.

        @return True if the buddy's presence is online, of False otherwise.
        '''

        if self.__exists:
            return status.purple_presence_is_online( \
                    blist.purple_buddy_get_presence(self._get_structure()))
        else:
            return False
    online = property(__get_online)

    def __get_idle(self):
        '''Returns whether or not the buddy presence is idle.

        @return True if the presence is idle, or False otherwise.
        '''

        if self.__exists:
            return status.purple_presence_is_idle( \
                    blist.purple_buddy_get_presence(self._get_structure()))
        else:
            return False
    idle = property(__get_idle)

    def __get_active_status(self):
        '''Returns the buddy's active status.

        @return The active status.
        '''

        cdef status.PurpleStatus* c_status = NULL
        cdef char *type = NULL
        cdef char *name = NULL
        cdef char *msg = NULL
        if self.__exists:
            active = {}
            c_status = status.purple_presence_get_active_status( \
                    blist.purple_buddy_get_presence(self._get_structure()))
            type = <char *> status.purple_status_get_id(c_status)
            name = <char *> status.purple_status_get_name(c_status)
            msg = <char *> status.purple_status_get_attr_string(c_status,
                "message")

            active['type'] = type
            active['name'] = name
            if msg:
                active['message'] = msg

            return active
        else:
            return None
    active_status = property(__get_active_status)

    def set_alias(self, alias):
        '''Sets the buddy's alias.

        @param alias Buddy alias
        @return True if success or False if failure to set.
        '''

        if self.__exists:
            blist.purple_blist_alias_buddy(self._get_structure(), alias)
            return True
        else:
            return False

    def set_group(self, group):
        '''Sets the buddy's group.

        @param group Buddy group
        @return True if success or False if failure to set.
        '''

        cdef blist.PurpleContact *c_contact = NULL
        cdef blist.PurpleGroup *c_group = NULL
        if self.__exists and group:
            c_group = blist.purple_find_group(group)
            if c_group == NULL:
                c_group = blist.purple_group_new(group)

            c_contact = blist.purple_buddy_get_contact(self._get_structure())
            blist.purple_blist_add_contact(c_contact, c_group, NULL)
            return True
        else:
            return False
