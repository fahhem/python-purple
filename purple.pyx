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

include "glib.pxd"

cdef extern from *:
    ctypedef char* const_char_ptr "const char *"

cdef extern from "time.h":
    ctypedef long int time_t

cdef extern from "libpurple/debug.h":
    void c_purple_debug_set_enabled "purple_debug_set_enabled" (gboolean debug_enabled)

cdef extern from "libpurple/plugin.h":
    void c_purple_plugins_add_search_path "purple_plugins_add_search_path" (const_char_ptr path)

cdef extern from "libpurple/util.h":
    void c_purple_util_set_user_dir "purple_util_set_user_dir" (char *dir)

cdef extern from "c_purple.h":
     void init_libpurple(const_char_ptr ui_id)

class Purple(object):
    def __init__(self):
        self.DEFAULT_PATH = "/home/user/MyDocs/Carman"
        self.APP_NAME = "carman-purple-python"

        self.debug_set_enabled(True)
        self.util_set_user_dir(self.DEFAULT_PATH)
        self.plugin_add_search_path(self.DEFAULT_PATH)

        init_libpurple(self.APP_NAME)
    # __init__

    def debug_set_enabled(self, debug_enabled):
        c_purple_debug_set_enabled(debug_enabled)
    # debug_set_enabled

    def plugin_add_search_path(self, path):
        c_purple_plugins_add_search_path(path)
    # plugin_add_search_path

    def util_set_user_dir(self, dir):
        c_purple_util_set_user_dir(dir)
    # util_set_user_dir

#include "core/account.pxd"
#include "core/blist.pxd"
#include "core/connection.pxd"
#include "core/core.pxd"
#include "core/eventloop.pxd"
#include "core/idle.pxd"
#include "core/pounce.pxd"
#include "core/prefs.pxd"
