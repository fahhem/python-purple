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

                # Google Talk default domain hackery!
                if str_value == NULL and str(<char *> label_name) == "Connect server":
                    str_value = "talk.google.com"
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

            if not po.has_key(sett):
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
            # FIXME: Using purple_accounts_add(...) to save to xml
            #   I think we could improve this ..
            account.purple_accounts_add(account.purple_account_new( \
                    self.__username, self.__protocol.id))

            self.__exists = True
            return True

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

