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

cdef extern from "libpurple/plugin.h":
    ctypedef struct PurplePlugin

    cdef void c_purple_plugins_add_search_path "purple_plugins_add_search_path" (const_char_ptr path)
    cdef void c_purple_plugins_load_saved "purple_plugins_load_saved" (const_char_ptr key)
    cdef gboolean c_purple_plugin_register "purple_plugin_register" (PurplePlugin *plugin)

class Plugin(object):
    """ Plugin class """

    def __init__(self):
        purple_plugin = None

    def purple_plugins_add_search_path(path):
        c_purple_plugins_add_search_path(path)

    def purple_plugins_load_saved(key):
        c_purple_plugins_load_saved(key)

    # FIXME
    """
    def purple_plugin_register(plugin):
        return c_purple_plugin_register(plugin)
    """
