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

cimport account
cimport blist
cimport conversation
cimport value

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef long int time_t

cdef extern from "libpurple/status.h":
    ctypedef struct PurpleStatusType
    ctypedef struct PurpleStatusAttr
    ctypedef struct PurplePresence
    ctypedef struct PurpleStatus

    ctypedef enum PurplePresenceContext:
        PURPLE_PRESENCE_CONTEXT_UNSET = 0
        PURPLE_PRESENCE_CONTEXT_ACCOUNT
        PURPLE_PRESENCE_CONTEXT_CONV
        PURPLE_PRESENCE_CONTEXT_BUDDY

    ctypedef enum PurpleStatusPrimitive:
        PURPLE_STATUS_UNSET = 0
        PURPLE_STATUS_OFFLINE
        PURPLE_STATUS_AVAILABLE
        PURPLE_STATUS_UNAVAILABLE
        PURPLE_STATUS_INVISIBLE
        PURPLE_STATUS_AWAY
        PURPLE_STATUS_EXTENDED_AWAY
        PURPLE_STATUS_MOBILE
        PURPLE_STATUS_TUNE
        PURPLE_STATUS_NUM_PRIMITIVES

    ctypedef struct PurpleStatusType:
        PurpleStatusPrimitive primitive
        char *id
        char *name
        char *primary_attr_id
        glib.gboolean saveable
        glib.gboolean user_settable
        glib.gboolean independent
        glib.GList *attrs

    ctypedef struct PurpleStatusAttr:
        char *id
        char *name
        value.PurpleValue *value_type

    ctypedef struct __ChatType:
        conversation.PurpleConversation *conv
        char *user

    ctypedef struct __BuddyType:
        account.PurpleAccount *account
        char *name
        blist.PurpleBuddy *buddy

    ctypedef union __UnionType:
        account.PurpleAccount *account
        __ChatType chat
        __BuddyType buddy

    ctypedef struct PurplePresence:
        PurplePresenceContext context
        glib.gboolean idle
        time_t idle_time
        time_t login_time
        glib.GList *statuses
        glib.GHashTable *status_table
        PurpleStatus *active_status
        __UnionType u

    ctypedef struct PurpleStatus:
        PurpleStatusType *type
        PurplePresence *presence
        const_char *title
        glib.gboolean active
        glib.GHashTable *attr_values

    ctypedef struct PurpleStatusBuddyKey:
        account.PurpleAccount *account
        char *name

    glib.gboolean c_purple_presence_is_online "purple_presence_is_online" (PurplePresence *presence)
