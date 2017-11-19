/*-
 * Copyright (c) 2015-2016 elementary LLC.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Adam Bieńkowski <donadigos159@gmail.com>
 */

namespace Network.Widgets {
    public class ProxyPage : Page {
        public Gtk.Stack stack;
        public signal void update_status_label (string mode);

        private DeviceItem owner;

        public ProxyPage (DeviceItem _owner) {
            owner = _owner;

            init (null);
            title = _("Proxy");
            icon_name = "preferences-system-network";

            column_spacing = 12;
            row_spacing = 12;
            margin = 24;
            margin_bottom = 12;

            var configuration_page = new ConfigurationPage (control_switch);
            var exceptions_page = new ExecepionsPage ();

            control_switch.notify["active"].disconnect (control_switch_activated);
            control_switch.notify["active"].connect (configuration_page.apply_settings);

            stack = new Gtk.Stack ();
            stack.add_titled (configuration_page, "configuration", _("Configuration"));
            stack.add_titled (exceptions_page, "exceptions", _("Exceptions"));

            var stackswitcher = new Gtk.StackSwitcher ();
            stackswitcher.halign = Gtk.Align.CENTER;
            stackswitcher.stack = stack;

            proxy_settings.changed.connect (update_mode);
            update_mode ();

            add (stackswitcher);
            add (stack);

            show_all ();

            stack.visible_child = configuration_page;
        }

        protected override void control_switch_activated () {
        }

        protected override void update_switch () {
        }

        private void update_mode () {
            var mode = Utils.CustomMode.INVALID;
            switch (proxy_settings.mode) {
                case "none":
                    mode = Utils.CustomMode.PROXY_NONE;
                    control_switch.active = false;
                    break;
                case "manual":
                    mode = Utils.CustomMode.PROXY_MANUAL;
                    control_switch.active = true;
                    break;
                case "auto":
                    mode = Utils.CustomMode.PROXY_AUTO;
                    control_switch.active = true;
                    break;
                default:
                    mode = Utils.CustomMode.INVALID;
                    break;
            }

            owner.switch_status (mode);
        }
    }
}
