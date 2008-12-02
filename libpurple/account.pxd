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

cdef extern from "libpurple/account.h":
    ctypedef struct PurpleAccount:
        pass

    ctypedef struct PurpleAccountUiOps:
        pass

    PurpleAccount *c_purple_account_new "purple_account_new" (const_char_ptr username, const_char_ptr protocol_id)
    void c_purple_account_set_password "purple_account_set_password" (PurpleAccount *account, const_char_ptr password)
    const_char_ptr c_purple_account_get_password "purple_account_get_password" (PurpleAccount *account)
    void c_purple_account_set_enabled "purple_account_set_enabled" (PurpleAccount *account, const_char_ptr ui, gboolean value)
    const_char_ptr c_purple_account_get_username "purple_account_get_username" (PurpleAccount *account)
    GList *c_purple_accounts_get_all_active "purple_accounts_get_all_active" ()
    void c_purple_accounts_set_ui_ops "purple_accounts_set_ui_ops" (PurpleAccountUiOps *ops)
