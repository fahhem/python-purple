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

cdef class Plugin:
    cdef plugin.PurplePlugin *c_plugin
    cdef prpl.PurplePluginProtocolInfo *c_prpl_info
    cdef plugin.PurplePluginInfo *c_plugin_info

    def __init__(self):
        pass

    '''
    def __init__(self, id):
        self.c_plugin = plugin.purple_plugins_find_with_id(id)
        self.c_prpl_info = plugin.c_PURPLE_PLUGIN_PROTOCOL_INFO(self.c_plugin)
    '''

    def get_name(self):
        return self.c_plugin.info.name

    def get_id(self):
        return self.c_plugin.info.id

    def get_all(self):
        ''' @return A string list of protocols' (id, name) '''
        '''    [('prpl-jabber', 'XMPP'), ('foo', 'MSN'), ...] '''
        cdef glib.GList *iter
        cdef plugin.PurplePlugin *pp

        protocols = []

        iter = plugin.purple_plugins_get_protocols()
        while iter:
            pp = <plugin.PurplePlugin*> iter.data
            if pp.info and pp.info.name:
                protocols.append((pp.info.id, pp.info.name))
            iter = iter.next

        return protocols

    def get_options(self, id, username=None):
        ''' @param id The protocol's id '''
        ''' @param username The account's username '''
        ''' @return {'setting type': ('UI label', str|int|bool value)} '''

        cdef plugin.PurplePlugin *c_plugin
        cdef prpl.PurplePluginProtocolInfo *c_prpl_info
        cdef account.PurpleAccount *c_account
        cdef glib.GList *iter
        cdef accountopt.PurpleAccountOption *option
        cdef prefs.PurplePrefType type
        cdef const_char *label_name
        cdef const_char *str_value
        cdef const_char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        c_account = NULL

        if username:
            c_account = account.purple_accounts_find(username, id)

        c_plugin = plugin.purple_plugins_find_with_id(id)
        c_prpl_info = plugin.c_PURPLE_PLUGIN_PROTOCOL_INFO(c_plugin)

        po = {}

        iter = c_prpl_info.protocol_options

        while iter:

            option = <accountopt.PurpleAccountOption *> iter.data
            type = accountopt.purple_account_option_get_type(option)
            label_name = accountopt.purple_account_option_get_text(option)
            setting = accountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)
            label = str(<char *> label_name)

            if type == prefs.PURPLE_PREF_STRING:
                str_value = accountopt.purple_account_option_get_default_string(option)
                if c_account != NULL:
                    str_value = account.purple_account_get_string(c_account, setting, str_value)

                val = str(<char *> str_value)

            elif type == prefs.PURPLE_PREF_INT:
                int_value = accountopt.purple_account_option_get_default_int(option)
                if c_account != NULL:
                    int_value = account.purple_account_get_int(c_account, setting, int_value)

                val = int(int_value)

            elif type == prefs.PURPLE_PREF_BOOLEAN:
                bool_value = accountopt.purple_account_option_get_default_bool(option)
                if c_account != NULL:
                    bool_value = account.purple_account_get_bool(c_account, setting, bool_value)

                val = bool(bool_value)

            elif type == prefs.PURPLE_PREF_STRING_LIST:
                str_value = accountopt.purple_account_option_get_default_list_value(option)
                if c_account != NULL:
                    str_value = account.purple_account_get_string(c_account, setting, str_value)

                val = str(<char *> str_value)

            iter = iter.next

            po[sett] = (label, val)

        return po

    def set_options(self, acc, po):
        #FIXME: account
        ''' @param id The protocol's id '''
        ''' @param username The account's username '''
        ''' @param po Dictionary {'setting type': str|int|bool value, ...} '''
        ''' @return True to success or False to failure '''

        cdef plugin.PurplePlugin *c_plugin
        cdef prpl.PurplePluginProtocolInfo *c_prpl_info
        cdef account.PurpleAccount *c_account
        cdef glib.GList *iter
        cdef accountopt.PurpleAccountOption *option
        cdef prefs.PurplePrefType type
        cdef const_char *str_value
        cdef const_char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        c_account = NULL

        c_account = account.purple_accounts_find(acc[0], acc[1])
        if c_account == NULL:
            # FIXME: Message error or call a error handler
            return False

        c_plugin = plugin.purple_plugins_find_with_id(acc[1])
        c_prpl_info = plugin.c_PURPLE_PLUGIN_PROTOCOL_INFO(c_plugin)

        iter = c_prpl_info.protocol_options

        while iter:

            option = <accountopt.PurpleAccountOption *> iter.data
            type = accountopt.purple_account_option_get_type(option)
            setting = accountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)

            iter = iter.next

            if sett not in po or po[sett] == None:
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

        return True


cdef class Plugins:

    cdef protocols

    def __init__(self):
        self.protocols = None

    def get_protocols(self):
        if self.protocols:
            return self.protocols
        cdef glib.GList *iter
        cdef plugin.PurplePlugin *pp
        protocols = []
        iter = plugin.purple_plugins_get_protocols()
        while iter:
            pp = <plugin.PurplePlugin*> iter.data
            if pp.info and pp.info.name:
                p = Plugin(pp.info.id)
                if p:
                    protocols += [p]
            iter = iter.next
        glib.g_list_free(iter)
        self.protocols = protocols
        return protocols
