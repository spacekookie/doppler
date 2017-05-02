require 'luarocks.loader'
lgi = require 'lgi'
Gtk = lgi.require 'Gtk'
math = require 'math'

window = with Gtk.Window { 
  title:'window'
  default_width: 400
  default_height: 300
  on_destroy: Gtk.main_quit
}

  -- Create some more widgets for the window.
  status_bar = with Gtk.Statusbar!
    ctx = \get_context_id 'default'
    \push ctx, 'This is statusbar message.'

  toolbar = with Gtk.Toolbar!
    -- When clicking at the toolbar 'quit' button, destroy the main window.
    \insert Gtk.ToolButton({ 
        stock_id: 'gtk-quit'
        on_clicked: -> window\destroy!
      }), -1

    -- About button in toolbar and its handling.
    \insert (
      with Gtk.ToolButton { stock_id: 'gtk-about' }
        .on_clicked = require'redctrl.about_dialog'
    ), -1

  create_scale = (id,start) ->
    Gtk.Scale { 
      id: id
      digits: 0
      orientation: 'HORIZONTAL'
      adjustment: Gtk.Adjustment { 
        lower: 2500
        upper: 5500
        value: start
        step_increment: 50
        on_value_changed: =>
          val = @get_value!
          newval = math.floor(val/50)*50
          @set_value newval if val ~= newval
      }
    }

  -- Daylight temperature
  daylight = create_scale 'daylight', 5000
  nightlight = create_scale 'nightlight', 3500

  -- \pack_start toolbar, false, false, 3 
  -- Pack everything into the window.
  -- \add with Gtk.HBox { homogeneous: false }
    
  --   -- Add the daylight slider (and label)
  --   \pack_start (with Gtk.VBox!
  --     \pack_start (Gtk.Label { label: 'Daylight' }), false, true, 5
  --     \pack_start (Gtk.Label { label: 'Nightlight' }), false, true, 5
  --     \pack_start (Gtk.Label { label: 'Enable day-night transitions' }), false, true, 5
  --   ), false, false, 5

  --   -- Add the nightlight slider (and label)
  --   \pack_start (with Gtk.VBox!
  --     \pack_start daylight, false, false, 5
  --     \pack_start nightlight, false, false, 5
  --     \pack_start Gtk.Switch!, false, false, 5
  --   ), true, true, 5

  --   -- \pack_start Gtk.Box!, true, true, 0
  --   -- \pack_end status_bar, false, false, 0

  \add with Gtk.VBox!
    \pack_start toolbar, false, false, 3 
    \pack_start (with Gtk.Grid { row_homogeneous: false, column_homogeneous: true }

      \attach (Gtk.Label { label: 'Daylight' }), 0, 0, 1, 1
      \attach daylight, 1, 0, 1, 1

      \attach (Gtk.Label { label: 'Nightlight' }), 0, 1, 1, 1
      \attach nightlight, 1, 1, 1, 1

      \attach (Gtk.Label { label: 'Enable day-night transitions' }), 0, 2, 1, 1
      \attach (with Gtk.Box!
        \add Gtk.Switch { expand: false, halign: Gtk.ALIGN_START }
      ), 1, 2, 1, 1
    ), true, true, 1

    \pack_start Gtk.StackSwitcher!, true, true, 1

    \pack_end status_bar, false, false, 0

  \show_all!

Gtk\main!

