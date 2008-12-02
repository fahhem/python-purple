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

cimport prpl

cdef extern from "libpurple/plugin.h":
    ctypedef struct PurplePluginInfo:
        char *id
        char *name

    ctypedef struct PurplePlugin:
        glib.gboolean native_plugin
        glib.gboolean loaded
        void *handle
        char *path
        PurplePluginInfo *info
        char *error
        void *ipc_data
        void *extra
        glib.gboolean unloadable
        glib.GList *dependent_plugins

    prpl.PurplePluginProtocolInfo *PURPLE_PLUGIN_PROTOCOL_INFO(PurplePlugin *plugin)
    PurplePlugin *purple_plugin_new(glib.gboolean native, char* path)

    void purple_plugins_add_search_path(char *path)
    glib.GList *purple_plugins_get_protocols()
    PurplePlugin purple_plugins_find_with_name(char *name)
    PurplePlugin *purple_plugins_find_with_id(char *id)
    char *purple_plugin_get_name(PurplePlugin *plugin)


