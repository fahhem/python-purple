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

cimport status
cimport glib
cimport account
cimport status

cdef extern from *:
    ctypedef long int time_t

cdef extern from "libpurple/savedstatuses.h":
    ctypedef struct PurpleSavedStatus:
        pass

    PurpleSavedStatus *purple_savedstatus_new(char *title, status.PurpleStatusPrimitive type)
    void c_purple_savedstatus_activate "purple_savedstatus_activate" (PurpleSavedStatus *saved_status)
    PurpleSavedStatus *purple_savedstatus_get_current()
    glib.gboolean purple_savedstatus_is_transient(PurpleSavedStatus *saved_status)
    void purple_savedstatus_set_substatus(PurpleSavedStatus *status, account.PurpleAccount *account, \
            status.PurpleStatusType *type, char *message)
    void purple_savedstatus_set_idleaway(glib.gboolean idleaway)
    PurpleSavedStatus *purple_savedstatus_find(char *title)
    PurpleSavedStatus *purple_savedstatus_find_transient_by_type_and_message( \
            status.PurpleStatusPrimitive type, char *message)
    void purple_savedstatus_set_message(PurpleSavedStatus *status, char *message)
    void purple_savedstatus_activate(PurpleSavedStatus *saved_status)
    void purple_savedstatus_activate_for_account(PurpleSavedStatus *saved_status, \
            account.PurpleAccount *account)
    time_t purple_savedstatus_get_creation_time(PurpleSavedStatus *saved_status)
    void purple_savedstatus_set_title(PurpleSavedStatus *status, char *title)
