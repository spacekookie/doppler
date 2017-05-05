lgi = require 'lgi'
Gtk = lgi.require 'Gtk'


-- Erm...yea, whatever. This only works if I can stop Gtk from updating the input
-- field and do it myself :( I guess we don't do it for now :/
clean_text = (new, length, pos, obj) ->
  hack_insert = (obj, text) ->
    obj.text =  obj\get_text! .. text

  -- This handles cases 1-3
  if length == 0
    unless new == '1' or new == '2' or new == '0'
      hack_insert obj, ':'
      return pos + 1 
  
  -- Handles cases 4-5
  else if length == 1
    first = obj\get_text!

    if first == '1'
      print "yup..."
      hack_insert obj, ':'
      return pos + 1

    elseif first == '2'
      if new == '0' or new == '1' or new == '2' or new == '3' or new == '4'
        hack_insert obj, ':'
        return pos + 1
      

  return pos


(redstate) ->

  start = Gtk.Entry {
    text: redstate.time_start
    placeholder_text: "HH:MM"
    on_changed: => redstate.time_start = @get_text!
  }

  stop = Gtk.Entry {
    text: redstate.time_stop
    placeholder_text: "HH:MM"
    on_changed: => redstate.time_stop = @get_text!
  }

  return with Gtk.Box!
    \pack_start (with Gtk.Grid { row_homogeneous: false, column_homogeneous: true }

      -- Add some label
      \attach (Gtk.Label { label: 'Nighttime' }), 0, 0, 1, 1
      \attach (Gtk.Label { label: 'Daytime' }), 0, 1, 1, 1

      \attach start, 1, 0, 1, 1
      \attach stop, 1, 1, 1, 1
    ), true, true, 5

 

  -- return with Gtk.VBox!
  --   \pack_start (with Gtk.Grid { row_homogeneous: false, column_homogeneous: true }
  --     -- \attach (Gtk.Label { label: 'Set a time to switch screen hue' }), 0, 0, 2, 1
  --     \attach (Gtk.Label { label: 'Nighttime' }), 0, 0, 1, 1
  --     \attach (Gtk.Label { label: 'Daytime' }), 1, 0, 1, 1

  --     -- Add the daytime time picker
  --     \attach (with Gtk.Box { hexpand: true, halign: Gtk.ALIGN_FILL }
  --       \set_center_widget (with Gtk.Box { halign: Gtk.ALIGN_CENTER }
  --         \add night_hours
  --         \add Gtk.Label { label: '  :  ', hexpand: false }
  --         \add night_minutes
  --       )
  --     ), 1, 1, 1, 1
      
  --     -- Add the nighttime time picker
  --     \attach (with Gtk.Box { hexpand: true, halign: Gtk.ALIGN_FILL }
  --       \set_center_widget (with Gtk.Box { halign: Gtk.ALIGN_CENTER }
  --         \add day_hours
  --         \add Gtk.Label { label: '  :  ' }
  --         \add day_minutes
  --       )
  --     ), 0, 1, 1, 1
  --   ), true, true, 5



     -- day_hours = Gtk.SpinButton {
  --   orientation: 'VERTICAL'
  --   hexpand: false
  --   on_value_changed: => redstate.time_stop_hours = @get_value!
  --   adjustment: Gtk.Adjustment {
  --     upper: 24
  --     lower: 0
  --     value: redstate.time_stop_hours
  --   }
  -- }

  -- day_minutes = Gtk.SpinButton {
  --   orientation: 'VERTICAL'
  --   numeric: true
  --   on_value_changed: => redstate.time_stop_minutes = @get_value!
  --   adjustment: Gtk.Adjustment {
  --     upper: 59
  --     lower: 0
  --     value: redstate.time_stop_minutes
  --   }
  -- }

  -- night_hours = Gtk.SpinButton {
  --   orientation: 'VERTICAL'
  --   numeric: true
  --   on_value_changed: => redstate.time_start_hours = @get_value!
  --   adjustment: Gtk.Adjustment {
  --     upper: 24
  --     lower: 0
  --     value: redstate.time_start_hours
  --   }
  -- }

  -- night_minutes = Gtk.SpinButton {
  --   orientation: 'VERTICAL'
  --   numeric: true
  --   on_value_changed: => redstate.time_start_minutes = @get_value!
  --   adjustment: Gtk.Adjustment {
  --     upper: 59
  --     lower: 0
  --     value: redstate.time_start_minutes
  --   }
  -- }