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

cimport account

cdef extern from *:
    ctypedef char const_char "const char"

cdef extern from "libpurple/privacy.h":
    ctypedef enum PurplePrivacyType:
        PURPLE_PRIVACY_ALLOW_ALL = 1
        PURPLE_PRIVACY_DENY_ALL
        PURPLE_PRIVACY_ALLOW_USERS
        PURPLE_PRIVACY_DENY_USERS
        PURPLE_PRIVACY_ALLOW_BUDDYLIST

    ctypedef struct PurplePrivacyUiOps:
        void (*permit_added) (account.PurpleAccount *account, const_char *name)
        void (*permit_removed) (account.PurpleAccount *account, const_char *name)
        void (*deny_added) (account.PurpleAccount *account, const_char *name)
        void (*deny_removed) (account.PurpleAccount *account, const_char *name)

    void c_purple_privacy_set_ui_ops "purple_privacy_set_ui_ops" (PurplePrivacyUiOps *ops)
    PurplePrivacyUiOps *c_purple_privacy_get_ui_ops "purple_privacy_get_ui_ops" ()
