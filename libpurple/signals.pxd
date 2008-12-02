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

cdef extern from "libpurple/signals.h":
    ctypedef void (*PurpleCallback) ()

    gulong c_purple_signal_connect "purple_signal_connect" (void *instance,
            const_char_ptr signal, void *handle, PurpleCallback func,
            void *data)
    void c_purple_signal_disconnect "purple_signal_disconnect" (void *instance,
            const_char_ptr signal, void *handle, PurpleCallback func)
