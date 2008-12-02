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

    def __init__(self, id):
        self.c_plugin = plugin.c_purple_plugins_find_with_id(id)
        self.c_prpl_info = plugin.c_PURPLE_PLUGIN_PROTOCOL_INFO(self.c_plugin)

    def get_name(self):
        return self.c_plugin.info.name

    def get_id(self):
        return self.c_plugin.info.id


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
        iter = plugin.c_purple_plugins_get_protocols()
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
