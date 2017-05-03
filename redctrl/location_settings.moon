lgi = require 'lgi'
Gtk = lgi.require 'Gtk'

-- Create a VBox group and return it for us to use in the main layout
return with Gtk.VBox!
  \pack_start (with Gtk.Grid { row_homogeneous: false, column_homogeneous: true }

    \attach (Gtk.Button {  label: 'Attempt Geoclue Lookup' }), 0, 0, 2, 1

    -- \attach (Gtk.Label { label: 'Set a time to switch screen hue' }), 0, 0, 2, 1
    \attach (Gtk.Label { label: 'Latitude' }), 0, 1, 1, 1
    \attach (Gtk.Label { label: 'Longitude' }), 0, 2, 1, 1

    -- Add the daytime time picker
    \attach Gtk.Entry!, 1, 1, 1, 1
    \attach Gtk.Entry!, 1, 2, 1, 1
  ), true, true, 5
