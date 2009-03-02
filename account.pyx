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

cdef class Account:
    """
    Account class
    @param username
    @param protocol Protocol class instance
    @param core Purple class instance
    """

    cdef object __username
    cdef object __protocol
    cdef object __core
    cdef object __exists

    def __init__(self, username, protocol, core):
        self.__username = username
        self.__protocol = protocol
        self.__core = core

        if protocol.exists and self._get_structure() != NULL:
            self.__exists = True
        else:
            self.__exists = False

    cdef account.PurpleAccount *_get_structure(self):
        return account.purple_accounts_find(self.__username, \
                self.__protocol.id)

    def __is_connected(self):
        if self.__exists:
            return account.purple_account_is_connected(self._get_structure())
        else:
            return None
    is_connected = property(__is_connected)

    def __is_connecting(self):
        if self.__exists:
            return account.purple_account_is_connecting(self._get_structure())
        else:
            return None
    is_connecting = property(__is_connecting)

    def __is_disconnected(self):
        if self.__exists:
            return account.purple_account_is_disconnected( \
                    self._get_structure())
        else:
            return None
    is_disconnected = property(__is_disconnected)

    def __get_core(self):
        return self.__core
    core = property(__get_core)

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

    def __get_protocol(self):
        return self.__protocol
    protocol = property(__get_protocol)

    def _get_protocol_options(self):
        """
        @return Dictionary {'setting': value, ...}
        """
        cdef glib.GList *iter
        cdef account.PurpleAccount *c_account
        cdef plugin.PurplePlugin *c_plugin
        cdef prpl.PurplePluginProtocolInfo *prpl_info
        cdef accountopt.PurpleAccountOption *option
        cdef prefs.PurplePrefType type
        cdef char *label_name
        cdef char *str_value
        cdef char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        c_account = self._get_structure()

        if c_account == NULL:
            return None

        po = {}

        c_plugin = plugin.purple_plugins_find_with_id(self.__protocol.id)
        prpl_info = plugin.PURPLE_PLUGIN_PROTOCOL_INFO(c_plugin)
        iter = prpl_info.protocol_options

        while iter:

            option = <accountopt.PurpleAccountOption *> iter.data
            type = accountopt.purple_account_option_get_type(option)
            label_name = <char *> accountopt.purple_account_option_get_text(option)
            setting = <char *> accountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)

            if type == prefs.PURPLE_PREF_STRING:

                str_value = <char *> accountopt.purple_account_option_get_default_string(option)

                # Hack to set string "" as default value to Account options when
                # the default value of the protocol is NULL
                if str_value == NULL:
                    str_value = ""
                str_value = <char *> account.purple_account_get_string(c_account, setting, str_value)

                val = str(<char *> str_value)

            elif type == prefs.PURPLE_PREF_INT:

                int_value = accountopt.purple_account_option_get_default_int(option)
                int_value = account.purple_account_get_int(c_account, setting, int_value)

                val = int(int_value)

            elif type == prefs.PURPLE_PREF_BOOLEAN:

                bool_value = accountopt.purple_account_option_get_default_bool(option)
                bool_value = account.purple_account_get_bool(c_account, setting, bool_value)

                val = bool(bool_value)

            elif type == prefs.PURPLE_PREF_STRING_LIST:

                str_value = <char *> accountopt.purple_account_option_get_default_list_value(option)
                str_value = <char *> account.purple_account_get_string(c_account, setting, str_value)

                val = str(<char *> str_value)

            iter = iter.next

            po[sett] = val

        return po
    protocol_options = property(_get_protocol_options)

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
    password = property(__get_password)

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
    alias = property(__get_alias)

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
    user_info = property(__get_user_info)

    def __get_remember_password(self):
        if self.__exists:
            return account.purple_account_get_remember_password( \
                    self._get_structure())
        else:
            return None
    remember_password = property(__get_remember_password)

    def __get_enabled(self):
        if self.__exists:
            return account.purple_account_get_enabled(self._get_structure(), \
                    self.__core.ui_name)
        else:
            return None
    enabled = property(__get_enabled)

    def __get_status_types(self):
        cdef glib.GList *iter = NULL
        cdef status.PurpleStatusType *c_statustype = NULL
        cdef char *id = NULL
        cdef char *name = NULL

        status_types = []
        if self.__exists:
            iter = account.purple_account_get_status_types(self._get_structure())
            while iter:
                c_statustype = <status.PurpleStatusType *> iter.data
                id = <char *> status.purple_status_type_get_id(c_statustype)
                name = <char *> status.purple_status_type_get_name(c_statustype)
                status_types.append((id, name))
                iter = iter.next

        return status_types

    status_types = property(__get_status_types)

    def __get_active_status(self):
        cdef status.PurpleStatus* c_status = NULL
        cdef char *type = NULL
        cdef char *name = NULL
        cdef char *msg = NULL
        if self.__exists:
            active = {}
            c_status = <status.PurpleStatus*> account.purple_account_get_active_status(self._get_structure())
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

    def set_username(self, username):
        """
        Sets the account's username.

        @param username The username
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            account.purple_account_set_username(self._get_structure(), \
                    username)
            return True
        else:
            return False

    def set_protocol(self, protocol):
        """
        Sets the account's protocol.

        @param protocol A Protocol class instance
        @return True if successful, False if account doesn't exists
        """
        if protocol.exists and self.__exists:
            account.purple_account_set_protocol_id(self._get_structure(), \
                        protocol.id)
            self.__protocol = protocol
            return True
        else:
            return False

    def set_protocol_options(self, po):
        """
        @param po Dictionary {'setting': value, ...} options to be updated
        @return True to success or False to failure
        """
        cdef glib.GList *iter
        cdef account.PurpleAccount *c_account
        cdef plugin.PurplePlugin *c_plugin
        cdef prpl.PurplePluginProtocolInfo *prpl_info
        cdef accountopt.PurpleAccountOption *option
        cdef prefs.PurplePrefType type
        cdef char *str_value
        cdef char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        c_account = self._get_structure()

        if c_account == NULL:
            return False

        c_plugin = plugin.purple_plugins_find_with_id(self.__protocol.id)
        prpl_info = plugin.PURPLE_PLUGIN_PROTOCOL_INFO(c_plugin)
        iter = prpl_info.protocol_options

        while iter:

            option = <accountopt.PurpleAccountOption *> iter.data
            type = accountopt.purple_account_option_get_type(option)
            setting = <char *> accountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)

            if sett not in po:
                iter = iter.next
                continue

            if type == prefs.PURPLE_PREF_STRING:

                str_value = <char *> po[sett]
                account.purple_account_set_string(c_account, setting, str_value)

            elif type == prefs.PURPLE_PREF_INT:

                int_value = int(po[sett])
                account.purple_account_set_int(c_account, setting, int_value)

            elif type == prefs.PURPLE_PREF_BOOLEAN:

                bool_value = bool(po[sett])
                account.purple_account_set_bool(c_account, setting, bool_value)

            elif type == prefs.PURPLE_PREF_STRING_LIST:

                str_value = <char *> po[sett]
                account.purple_account_set_string(c_account, setting, str_value)

            iter = iter.next

        return True

    def set_password(self, password):
        """
        Sets the account's password.

        @param password The password
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            account.purple_account_set_password(self._get_structure(), \
                    password)
            return True
        else:
            return False

    def set_alias(self, alias):
        """
        Sets the account's alias

        @param alias The alias
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            account.purple_account_set_alias(self._get_structure(), \
                    alias)
            return True
        else:
            return False

    def set_user_info(self, user_info):
        """
        Sets the account's user information

        @param user_info The user information
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            account.purple_account_set_user_info(self._get_structure(), \
                    user_info)
            return True
        else:
            return False

    def set_remember_password(self, remember_password):
        """
        Sets whether or not this account should save its password.

        @param remember_password True if should remember the password,
                                 or False otherwise
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            account.purple_account_set_remember_password( \
                self._get_structure(), remember_password)
            return True
        else:
            return False

    def set_enabled(self, value):
        """
        Sets wheter or not this account is enabled.

        @param value True if it is enabled, or False otherwise
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            account.purple_account_set_enabled(self._get_structure(), \
                    self.__core.ui_name, bool(value))
            return True
        else:
            return False

    def new(self):
        """
        Creates a new account.

        @return True if successful, False if account already exists
        """
        if self.__exists:
            return False
        else:
            account.purple_accounts_add(account.purple_account_new( \
                    self.__username, self.__protocol.id))

            self.__exists = True
            return True

    def remove(self):
        """
        Removes an existing account.

        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            account.purple_accounts_delete(self._get_structure())
            self__exists = False
            return True
        else:
            return False

    def connect(self):
        """
        Connects to an account.

        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            account.purple_account_connect(self._get_structure())
            return True
        else:
            return False

    def disconnect(self):
        """
        Disconnects from an account.

        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            account.purple_account_disconnect(self._get_structure())
            return True
        else:
            return False

    def add_buddy(self, name, alias=None, group=None):
        """
        Adds a buddy to account's buddy list.

        @param name  Buddy name
        @param alias Buddy alias (optional)
        @return True if successfull, False otherwise
        """
        cdef blist.PurpleBuddy *c_buddy = NULL
        cdef blist.PurpleGroup *c_group = NULL
        cdef char *c_alias = NULL

        if alias:
            c_alias = alias
        else:
            c_alias = NULL

        if self.__exists and \
                account.purple_account_is_connected(self._get_structure()):
            if blist.purple_find_buddy(self._get_structure(), name):
                return False

            if group:
                c_group = blist.purple_find_group(group)
                if c_group == NULL:
                    c_group = blist.purple_group_new(group)

            c_buddy = blist.purple_buddy_new(self._get_structure(), \
                    name, c_alias)
            if c_buddy == NULL:
                return False

            blist.purple_blist_add_buddy(c_buddy, NULL, c_group, NULL)
            account.purple_account_add_buddy(self._get_structure(), c_buddy)
            if c_alias:
                blist.purple_blist_alias_buddy(c_buddy, c_alias)
                server.serv_alias_buddy(c_buddy)

            return True

        else:
            return None

    def remove_buddy(self, name):
        """
        Removes a buddy from account's buddy list.

        @param name Buddy name
        @return True if successful, False otherwise
        """
        cdef blist.PurpleBuddy *c_buddy = NULL
        cdef blist.PurpleGroup *c_group = NULL

        if self.__exists and \
                account.purple_account_is_connected(self._get_structure()):
            c_buddy = blist.purple_find_buddy(self._get_structure(), name)
            if c_buddy == NULL:
                return False

            c_group = blist.purple_buddy_get_group(c_buddy)

            account.purple_account_remove_buddy(self._get_structure(), \
                    c_buddy, c_group)
            blist.purple_blist_remove_buddy(c_buddy)
            return True
        else:
            return None

    def get_buddies_online(self):
        cdef glib.GSList *iter = NULL
        cdef blist.PurpleBuddy *c_buddy = NULL
        cdef char *c_alias = NULL

        buddies_list = []
        if self.__exists and \
                account.purple_account_is_connected(self._get_structure()):
            iter = blist.purple_find_buddies(self._get_structure(), NULL)

            while iter:
                c_alias = NULL
                c_buddy = <blist.PurpleBuddy *> iter.data
                if <blist.PurpleBuddy *> c_buddy and \
                        status.purple_presence_is_online( \
                                blist.purple_buddy_get_presence(c_buddy)):
                    name = <char *> blist.purple_buddy_get_name(c_buddy)

                    new_buddy = Buddy(name, self)

                    c_alias = <char *> blist.purple_buddy_get_alias_only(c_buddy)
                    if c_alias:
                        new_buddy.set_alias(c_alias)

                    buddies_list.append(new_buddy)
                iter = iter.next

        return buddies_list

    def get_buddies(self):
        """
        @return Account's buddies list
        """
        cdef glib.GSList *iter = NULL
        cdef blist.PurpleBuddy *c_buddy = NULL
        cdef char *c_alias = NULL

        buddies_list = []
        if self.__exists:
            iter = blist.purple_find_buddies(self._get_structure(), NULL)

            while iter:
                c_alias = NULL
                c_buddy = <blist.PurpleBuddy *> iter.data

                name = <char *> blist.purple_buddy_get_name(c_buddy)
                new_buddy = Buddy(name, self)

                c_alias = <char *> blist.purple_buddy_get_alias_only(c_buddy)
                if c_alias:
                    new_buddy.set_alias(c_alias)

                buddies_list.append(new_buddy)
                iter = iter.next

        return buddies_list

    def request_add_buddy(self, buddy_username, buddy_alias):
        if buddy_alias:
            blist.purple_blist_request_add_buddy(self._get_structure(), \
                    buddy_username, NULL, buddy_alias)
        else:
            blist.purple_blist_request_add_buddy(self._get_structure(), \
                    buddy_username, NULL, NULL)

    def set_active_status(self, type, msg=None):
        cdef status.PurpleStatusType *c_statustype = NULL
        cdef savedstatuses.PurpleSavedStatus *c_savedstatus = NULL

        if self.__exists:
            if msg:
                account.purple_account_set_status(self._get_structure(),
                        <char *> type, True, "message", <char *> msg, NULL)
            else:
                account.purple_account_set_status(self._get_structure(),
                        <char *> type, True, NULL)

            # FIXME: We can create only a savedstatus for each statustype
            c_savedstatus = savedstatuses.purple_savedstatus_find(type)
            if c_savedstatus == NULL:
                c_statustype = account.purple_account_get_status_type( \
                        self._get_structure(), type)
                c_savedstatus = savedstatuses.purple_savedstatus_new( \
                        NULL, status.purple_status_type_get_primitive( \
                                c_statustype))
                savedstatuses.purple_savedstatus_set_title(c_savedstatus,
                        type)

            savedstatuses.purple_savedstatus_set_message(c_savedstatus, msg)
            prefs.purple_prefs_set_int("/purple/savedstatus/idleaway",
                    savedstatuses.purple_savedstatus_get_creation_time(c_savedstatus))

            return True
        else:
            return False

    def set_status_message(self, type, msg):
        cdef status.PurpleStatus* c_status = NULL
        cdef status.PurpleStatusType *c_statustype = NULL
        cdef savedstatuses.PurpleSavedStatus *c_savedstatus = NULL

        if self.__exists and msg:
            c_status = account.purple_account_get_status(self._get_structure(),
                    type)
            if c_status == NULL:
                return False
            status.purple_status_set_attr_string(c_status, "message", msg)

            # FIXME: We can create only a savedstatus for each statustype
            c_savedstatus = savedstatuses.purple_savedstatus_find(type)
            if c_savedstatus == NULL:
                c_statustype = account.purple_account_get_status_type( \
                        self._get_structure(), type)
                c_savedstatus = savedstatuses.purple_savedstatus_new( \
                        NULL, status.purple_status_type_get_primitive( \
                                c_statustype))
                savedstatuses.purple_savedstatus_set_title(c_savedstatus,
                        type)

            savedstatuses.purple_savedstatus_set_message(c_savedstatus, msg)
            return True
        else:
            return False
