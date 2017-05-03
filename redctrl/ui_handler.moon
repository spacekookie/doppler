lgi = require 'lgi'
math = require 'math'
Gtk = lgi.require 'Gtk'


-- Utility function that creates Gtk sliders
create_scale = (id, start) ->
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
        @set_value newval if val != newval
    }
  }


return class RedGUI

  -- Initialise the UI in all it's glory
  new: (state, w, h) => 

    -- Store the state for later
    @state = state

    -- Fill a basic Gtk window with love
    @window = with Gtk.Window { 
      title:'Redshift Control'
      default_width: w
      default_height: h
      on_destroy: Gtk.main_quit
    }

      -- Create a toolbar (TODO: Remove this again?)
      @toolbar = with Gtk.Toolbar!
        \insert Gtk.ToolButton({ 
          stock_id: 'gtk-quit'
          on_clicked: -> @window\destroy!
        }), -1
        \insert (
          with Gtk.ToolButton { stock_id: 'gtk-about' }
            .on_clicked = require 'redctrl.about_dialog'
        ), -1

      -- Daylight temperature
      daylight = create_scale 'daylight', 5000
      nightlight = create_scale 'nightlight', 3500

      -- TODO: Move this to a different file somehow?
      \add with Gtk.VBox!
        \pack_start @toolbar, false, false, 3 
        \pack_start (with Gtk.Grid { row_homogeneous: false, column_homogeneous: true }

          \attach (Gtk.Label { label: 'Daylight' }), 0, 0, 1, 1
          \attach daylight, 1, 0, 1, 1

          \attach (Gtk.Label { label: 'Nightlight' }), 0, 1, 1, 1
          \attach nightlight, 1, 1, 1, 1

          \attach (Gtk.Label { label: 'Enable day-night transitions' }), 0, 2, 1, 1
          \attach (with Gtk.Box!
            \add Gtk.Switch { expand: false, halign: Gtk.ALIGN_START }
          ), 1, 2, 1, 1

          -- 
          \attach (Gtk.Label { label: 'Do you want to change screen hue based on time or location?' }), 0, 3, 2, 1

          -- Create sub-groups for time and location settings
          time_settings = require 'redctrl.time_settings'
          location_settings = require 'redctrl.location_settings'

          -- Add stack switcher for time/ position settings
          stack = with Gtk.Stack { homogeneous: true }
            \set_transition_type Gtk.StackTransitionType.SLIDE_LEFT_RIGHT
            \set_transition_duration 150
            \add_titled time_settings, "time", "By time"
            \add_titled location_settings, "location", "By location"

          stack_switcher = with Gtk.StackSwitcher { homogeneous: true }
            \set_stack stack

          \attach stack_switcher, 0, 4, 2, 1
          \attach stack, 0, 5, 2, 1

          \attach (Gtk.Button { label: 'Apply Settings' }), 0, 6, 2, 1
        ), true, true, 5

      -- Show our creation to the world \o/
      \show_all!

  run: => Gtk\main!