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

cdef extern from "libpurple/eventloop.h":
    ctypedef enum PurpleInputCondition:
        PURPLE_INPUT_READ
        PURPLE_INPUT_WRITE

    ctypedef void (*PurpleInputFunction) (gpointer, gint, PurpleInputCondition)

    ctypedef struct PurpleEventLoopUiOps:
        guint (*timeout_add) (guint interval, GSourceFunc function, gpointer data)
        gboolean (*timeout_remove) (guint handle)
        guint (*input_add) (int fd, PurpleInputCondition cond, PurpleInputFunction func, gpointer user_data)
        gboolean (*input_remove) (guint handle)
        int (*input_get_error) (int fd, int *error)
        guint (*timeout_add_seconds)(guint interval, GSourceFunc function, gpointer data)

    void c_purple_eventloop_set_ui_ops "purple_eventloop_set_ui_ops" (PurpleEventLoopUiOps *ops)
