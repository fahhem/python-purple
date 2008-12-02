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
    ctypedef long int time_t
    ctypedef void* va_list

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
        char *title
        glib.gboolean active
        glib.GHashTable *attr_values

    ctypedef struct PurpleStatusBuddyKey:
        account.PurpleAccount *account
        char *name

    # PurpleStatusPrimitive API
    char *purple_primitive_get_id_from_type(PurpleStatusPrimitive type)
    char *purple_primitive_get_name_from_type(PurpleStatusPrimitive type)
    PurpleStatusPrimitive purple_primitive_get_type_from_id(char *id)

    # PurpleStatusType API
    PurpleStatusType *purple_status_type_new_full( \
            PurpleStatusPrimitive primitive, char *id, char *name, \
            glib.gboolean saveable, glib.gboolean user_settable, \
            glib.gboolean independent)
    PurpleStatusType *purple_status_type_new(PurpleStatusPrimitive primitive, \
            char *id, char *name, glib.gboolean user_settable)
    PurpleStatusType *purple_status_type_new_with_attrs( \
            PurpleStatusPrimitive primitive,
            char *id, char *name, glib.gboolean saveable, \
            glib.gboolean user_settable, glib.gboolean independent, \
            char *attr_id, char *attr_name, value.PurpleValue *attr_value, ...)
    void purple_status_type_destroy(PurpleStatusType *status_type)
    void purple_status_type_set_primary_attr(PurpleStatusType *status_type, \
            char *attr_id)
    void purple_status_type_add_attr(PurpleStatusType *status_type, char *id, \
            char *name, value.PurpleValue *value_)
    void purple_status_type_add_attrs(PurpleStatusType *status_type, \
            char *id, char *name, value.PurpleValue *value_, ...)
    void purple_status_type_add_attrs_vargs(PurpleStatusType *status_type, \
            va_list args)
    PurpleStatusPrimitive purple_status_type_get_primitive( \
            PurpleStatusType *status_type)
    char *purple_status_type_get_id(PurpleStatusType *status_type)
    char *purple_status_type_get_name(PurpleStatusType *status_type)
    glib.gboolean purple_status_type_is_saveable(PurpleStatusType *status_type)
    glib.gboolean purple_status_type_is_user_settable( \
            PurpleStatusType *status_type)
    glib.gboolean purple_status_type_is_independent( \
            PurpleStatusType *status_type)
    glib.gboolean purple_status_type_is_exclusive( \
            PurpleStatusType *status_type)
    glib.gboolean purple_status_type_is_available( \
            PurpleStatusType *status_type)
    char *purple_status_type_get_primary_attr(PurpleStatusType *type)
    PurpleStatusAttr *purple_status_type_get_attr( \
            PurpleStatusType *status_type, char *id)
    glib.GList *purple_status_type_get_attrs(PurpleStatusType *status_type)
    PurpleStatusType *purple_status_type_find_with_id( \
            glib.GList *status_types, char *id)

    # PurpleStatusAttr API
    PurpleStatusAttr *purple_status_attr_new(char *id, char *name, \
            value.PurpleValue *value_type)
    void purple_status_attr_destroy(PurpleStatusAttr *attr)
    char *purple_status_attr_get_id(PurpleStatusAttr *attr)
    char *purple_status_attr_get_name(PurpleStatusAttr *attr)
    value.PurpleValue *purple_status_attr_get_value(PurpleStatusAttr *attr)

    # PurpleStatus API
    PurpleStatus *purple_status_new(PurpleStatusType *status_type, \
            PurplePresence *presence)
    void purple_status_destroy(PurpleStatus *status)
    void purple_status_set_active(PurpleStatus *status, glib.gboolean active)
    void purple_status_set_active_with_attrs(PurpleStatus *status, \
            glib.gboolean active, va_list args)
    void purple_status_set_active_with_attrs_list(PurpleStatus *status, \
            glib.gboolean active, glib.GList *attrs)
    void purple_status_set_attr_boolean(PurpleStatus *status, char *id, \
            glib.gboolean value_)
    void purple_status_set_attr_int(PurpleStatus *status, char *id, int value_)
    void purple_status_set_attr_string(PurpleStatus *status, char *id, \
            char *value_)
    PurpleStatusType *purple_status_get_type(PurpleStatus *status)
    PurplePresence *purple_status_get_presence(PurpleStatus *status)
    char *purple_status_get_id(PurpleStatus *status)
    char *purple_status_get_name(PurpleStatus *status)
    glib.gboolean purple_status_is_independent(PurpleStatus *status)
    glib.gboolean purple_status_is_exclusive(PurpleStatus *status)
    glib.gboolean purple_status_is_available(PurpleStatus *status)
    glib.gboolean purple_status_is_active(PurpleStatus *status)
    glib.gboolean purple_status_is_online(PurpleStatus *status)
    value.PurpleValue *purple_status_get_attr_value(PurpleStatus *status, \
            char *id)
    glib.gboolean purple_status_get_attr_boolean(PurpleStatus *status, \
            char *id)
    int purple_status_get_attr_int(PurpleStatus *status, char *id)
    char *purple_status_get_attr_string(PurpleStatus *status, char *id)
    glib.gint purple_status_compare(PurpleStatus *status1, \
            PurpleStatus *status2)

    # PurplePresence API
    PurplePresence *purple_presence_new(PurplePresenceContext context)
    PurplePresence *purple_presence_new_for_account( \
            account.PurpleAccount *account)
    PurplePresence *purple_presence_new_for_conv( \
            conversation.PurpleConversation *conv)
    PurplePresence *purple_presence_new_for_buddy(blist.PurpleBuddy *buddy)
    void purple_presence_destroy(PurplePresence *presence)
    void purple_presence_add_status(PurplePresence *presence, \
            PurpleStatus *status)
    void purple_presence_add_list(PurplePresence *presence, \
            glib.GList *source_list)
    void purple_presence_set_status_active(PurplePresence *presence, \
            char *status_id, glib.gboolean active)
    void purple_presence_switch_status(PurplePresence *presence, \
            char *status_id)
    void purple_presence_set_idle(PurplePresence *presence, \
            glib.gboolean idle, time_t idle_time)
    void purple_presence_set_login_time(PurplePresence *presence, \
            time_t login_time)
    PurplePresenceContext purple_presence_get_context(PurplePresence *presence)
    account.PurpleAccount *purple_presence_get_account( \
            PurplePresence *presence)
    conversation.PurpleConversation *purple_presence_get_conversation( \
            PurplePresence *presence)
    char *purple_presence_get_chat_user(PurplePresence *presence)
    blist.PurpleBuddy *purple_presence_get_buddy(PurplePresence *presence)
    glib.GList *purple_presence_get_statuses(PurplePresence *presence)
    PurpleStatus *purple_presence_get_status(PurplePresence *presence, \
            char *status_id)
    PurpleStatus *purple_presence_get_active_status(PurplePresence *presence)
    glib.gboolean purple_presence_is_available(PurplePresence *presence)
    glib.gboolean purple_presence_is_online(PurplePresence *presence)
    glib.gboolean purple_presence_is_status_active(PurplePresence *presence, \
            char *status_id)
    glib.gboolean purple_presence_is_status_primitive_active( \
            PurplePresence *presence, PurpleStatusPrimitive primitive)
    glib.gboolean purple_presence_is_idle(PurplePresence *presence)
    time_t purple_presence_get_idle_time(PurplePresence *presence)
    time_t purple_presence_get_login_time(PurplePresence *presence)
    glib.gint purple_presence_compare(PurplePresence *presence1, \
            PurplePresence *presence2)

    # Status subsystem
    void *purple_status_get_handle()
    void purple_status_init()
    void purple_status_uninit()
