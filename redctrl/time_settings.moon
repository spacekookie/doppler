lgi = require 'lgi'
Gtk = lgi.require 'Gtk'

return with Gtk.VBox!
  \pack_start (with Gtk.Grid { row_homogeneous: false, column_homogeneous: true }
    -- \attach (Gtk.Label { label: 'Set a time to switch screen hue' }), 0, 0, 2, 1
    \attach (Gtk.Label { label: 'Nighttime' }), 0, 0, 1, 1
    \attach (Gtk.Label { label: 'Daytime' }), 1, 0, 1, 1

    -- Add the daytime time picker
    \attach (with Gtk.Box { hexpand: true, halign: Gtk.ALIGN_FILL }
      \set_center_widget (with Gtk.Box { halign: Gtk.ALIGN_CENTER }
        \add Gtk.SpinButton { orientation: 'VERTICAL', hexpand: false  }
        \add Gtk.Label { label: '  :  ' }
        \add Gtk.SpinButton { orientation: 'VERTICAL', hexpand: false  }
      )
    ), 0, 1, 1, 1

    -- Add the nighttime time picker
    \attach (with Gtk.Box { hexpand: true, halign: Gtk.ALIGN_FILL }
      \set_center_widget (with Gtk.Box { halign: Gtk.ALIGN_CENTER }
        \add Gtk.SpinButton { orientation: 'VERTICAL', hexpand: false }
        \add Gtk.Label { label: '  :  ', hexpand: false }
        \add Gtk.SpinButton { orientation: 'VERTICAL', hexpand: false }
      )
    ), 1, 1, 1, 1
  ), true, true, 5