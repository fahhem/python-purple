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

import getpass
import sys, dl
import time

sys.setdlopenflags(dl.RTLD_NOW | dl.RTLD_GLOBAL)

import purple

# The information below is needed by libpurple
__NAME__ = "nullclient"
__VERSION__ = "0.1"
__WEBSITE__ = "N/A"
__DEV_WEBSITE__ = "N/A"

if __name__ == '__main__':
    # Sets initial parameters
    core = purple.Purple(__NAME__, __VERSION__, __WEBSITE__, __DEV_WEBSITE__, \
            debug_enabled=True, default_path="/tmp")

    # Initializes libpurple
    core.purple_init()

    # Get username from user
    sys.stdout.write("Enter GTalk account: ")
    username = sys.stdin.readline()[:-1]

    # Initialize protocol class
    protocol = purple.Protocol('prpl-jabber')

    # Creates new account inside libpurple
    account = purple.Account(username, protocol, core)
    account.new()

    # Get password from user
    account.set_password(getpass.getpass())

    # Set account protocol options
    info = {}
    info['connect_server'] = 'talk.google.com'
    info['port'] = '443'
    info['old_ssl'] = True
    account.set_protocol_options(info)

    # Enable account (connects automatically)
    account.set_enabled(True)

    while True:
        core.iterate_main_loop()
        time.sleep(0.01)
