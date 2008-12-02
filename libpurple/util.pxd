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
cimport notify
cimport glib
cimport signals
cimport xmlnode

cdef extern from *:
    ctypedef int size_t

cdef extern from "libpurple/util.h":
    ctypedef struct PurpleUtilFetchUrlData:
        pass

    ctypedef struct PurpleMenuAction:
        char *label
        signals.PurpleCallback callback
        glib.gpointer data
        glib.GList *children

    ctypedef char *(*PurpleInfoFieldFormatCallback)(char *field, size_t len)

    ctypedef struct PurpleKeyValuePair:
        glib.gchar *key
        void *value

    PurpleMenuAction *purple_menu_action_new(char *label, \
            signals.PurpleCallback callback, glib.gpointer data, \
            glib.GList *children)
    void purple_menu_action_free(PurpleMenuAction *act)

    void purple_util_set_current_song(char *title, char *artist, char *album)

    char *purple_util_format_song_info(char *title, char *artist, \
            char *album, glib.gpointer unused)

    # Utility Subsystem
    void purple_util_init()
    void purple_util_uninit()

    # Base16 Functions
    glib.gchar *purple_base16_encode(glib.guchar *data, glib.gsize len)
    glib.guchar *purple_base16_decode(char *str, glib.gsize *ret_len)
    glib.gchar *purple_base16_encode_chunked(glib.guchar *data, glib.gsize len)

    # Base64 Functions
    glib.gchar *purple_base64_encode(glib.guchar *data, glib.gsize len)
    glib.guchar *purple_base64_decode(char *str, glib.gsize *ret_len)

    # Quoted Printable Functions
    glib.guchar *purple_quotedp_decode(char *str, glib.gsize *ret_len)

    # MIME Functions
    char *purple_mime_decode_field(char *str)

    # Date/Time Functions FIXME
    #char *purple_utf8_strftime(char *format, struct tm *tm)
    #char *purple_get_tzoff_str(struct tm *tm, glib.gboolean iso)
    #char *purple_date_format_short(struct tm *tm)
    #char *purple_date_format_long(struct tm *tm)
    #char *purple_date_format_full(struct tm *tm)
    #char *purple_time_format(struct tm *tm)
    #time_t purple_time_build(int year, int month, int day, int hour, int min, \
            #int sec)
    #time_t purple_str_to_time(char *timestamp, glib.gboolean utc, \
            #struct tm *tm, long *tz_off, char **rest);

    # Markup Functions FIXME
#    glib.gboolean purple_markup_find_tag(char *needle, char *haystack, \
#            char **start, char **end, glib.GData **attributes)
    glib.gboolean purple_markup_extract_info_field(char *str, int len, \
            notify.PurpleNotifyUserInfo *user_info, char *start_token, \
            int skip, char *end_token, char check_value, \
            char *no_value_token, char *display_name, glib.gboolean is_link, \
            char *link_prefix, PurpleInfoFieldFormatCallback format_cb)
    void purple_markup_html_to_xhtml(char *html, char **dest_xhtml, char **dest_plain)
    char *purple_markup_strip_html(char *str)
    char *purple_markup_linkify(char *str)
    char *purple_unescape_html(char *html)
    char *purple_markup_slice(char *str, glib.guint x, glib.guint y)
    char *purple_markup_get_tag_name(char *tag)
    char *purple_markup_unescape_entity(char *text, int *length)
    char *purple_markup_get_css_property(glib.gchar *style, glib.gchar *opt)

    # Path/Filename Functions
    glib.gchar *purple_home_dir()
    glib.gchar *purple_user_dir()
    void purple_util_set_user_dir(char *dir)
    int purple_build_dir(char *path, int mode)
    glib.gboolean purple_util_write_data_to_file(char *filename, char *data, \
            glib.gssize size)
    glib.gboolean purple_util_write_data_to_file_absolute(char *filename_full, char *data, glib.gssize size)
    xmlnode.xmlnode *purple_util_read_xml_from_file(char *filename, char *description)
    #FILE *purple_mkstemp(char **path, glib.gboolean binary)
    #char *purple_util_get_image_extension(glib.gconstpointer data, size_t len)
    #char *purple_util_get_image_checksum(glib.gconstpointer image_data, size_t image_len)
    #char *purple_util_get_image_filename(glib.gconstpointer image_data, size_t image_len)

    # Environment Detection Functions
    glib.gboolean purple_program_is_valid(char *program)
    glib.gboolean purple_running_gnome()
    glib.gboolean purple_running_kde()
    glib.gboolean purple_running_osx()
    char *purple_fd_get_ip(int fd)

    # String Functions FIXME
    char *purple_normalize(account.PurpleAccount *account, char *str)
    char *purple_normalize_nocase(account.PurpleAccount *account, char *str)
    glib.gboolean purple_str_has_prefix(char *s, char *p)
    glib.gboolean purple_str_has_suffix(char *s, char *x)
    glib.gchar *purple_strdup_withhtml(glib.gchar *src)
    char *purple_str_add_cr(char *str)
    void purple_str_strip_char(char *str, char thechar)
    void purple_util_chrreplace(char *string, char delimiter, char replacement)
    glib.gchar *purple_strreplace(char *string, char *delimiter, \
            char *replacement)
    #char *purple_utf8_ncr_encode(char *in)
    #char *purple_utf8_ncr_decode(char *in)
    glib.gchar *purple_strcasereplace(char *string, char *delimiter, \
            char *replacement)
    char *purple_strcasestr(char *haystack, char *needle)
    #char *purple_str_size_to_units(size_t size)
    char *purple_str_seconds_to_string(glib.guint sec)
    char *purple_str_binary_to_ascii(unsigned char *binary, glib.guint len)

    # URI/URL Functions FIXME
    void purple_got_protocol_handler_uri(char *uri)
    glib.gboolean purple_url_parse(char *url, char **ret_host, int *ret_port, \
            char **ret_path, char **ret_user, char **ret_passwd)

    #ctypedef void (*PurpleUtilFetchUrlCallback)( \
            #PurpleUtilFetchUrlData *url_data, glib.gpointer user_data, \
            #glib.gchar *url_text, glib.gsize len, glib.gchar *error_message)

    #PurpleUtilFetchUrlData *purple_util_fetch_url_request(glib.gchar *url, \
    #        glib.gboolean full, glib.gchar *user_agent, glib.gboolean http11, \
    #        glib.gchar *request, glib.gboolean include_headers, \
    #        PurpleUtilFetchUrlCallback callback, glib.gpointer data)
    #PurpleUtilFetchUrlData *purple_util_fetch_url_request_len(glib.gchar *url, \
    #        glib.gboolean full, glib.gchar *user_agent, glib.gboolean http11, \
    #        glib.gchar *request, glib.gboolean include_headers, \
    #        glib.gssize max_len, PurpleUtilFetchUrlCallback callback, \
    #        glib.gpointer data)
    #void purple_util_fetch_url_cancel(PurpleUtilFetchUrlData *url_data)
    char *purple_url_decode(char *str)
    char *purple_url_encode(char *str)
    glib.gboolean purple_email_is_valid(char *address)
    glib.gboolean purple_ip_address_is_valid(char *ip)
    glib.GList *purple_uri_list_extract_uris(glib.gchar *uri_list)
    glib.GList *purple_uri_list_extract_filenames(glib.gchar *uri_list)

    # UTF8 String Functions FIXME
    glib.gchar *purple_utf8_try_convert(char *str)
    glib.gchar *purple_utf8_salvage(char *str)
    glib.gchar *purple_gai_strerror(glib.gint errnum)
    int purple_utf8_strcasecmp(char *a, char *b)
    glib.gboolean purple_utf8_has_word(char *haystack, char *needle)
    #void purple_print_utf8_to_console(FILE *filestream, char *message)
    glib.gboolean purple_message_meify(char *message, glib.gssize len)
    #char *purple_text_strip_mnemonic(char *in)
    char *purple_unescape_filename(char *str)
    char *purple_escape_filename(char *str)
    char *_purple_oscar_convert(char *act, char *protocol)
    void purple_restore_default_signal_handlers()
    glib.gchar *purple_get_host_name()
