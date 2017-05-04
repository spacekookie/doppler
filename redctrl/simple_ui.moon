lgi = require 'lgi'
math = require 'math'
Gtk = lgi.require 'Gtk'


class SimpleUI

  -- Creates a new SimpleUI and has references to ui_handle and redstate
  new: (ui_handle, redstate)=>

    @state = redstate
    day = @state.color_day
    night = @state.color_night

    -- Create temperature sliders
    @daylight = @\create_scale 'day', day, (val) -> @state.color_day = val
    @nightlight = @\create_scale 'night', night, (val) -> @state.color_night = val

    @trans = Gtk.Switch { 
      expand: false
      halign: Gtk.ALIGN_START

      -- Invert state because we're about to set it here!
      on_state_set: => redstate.transitions = not @get_state!
    }

    @ui = with Gtk.VBox!
      \pack_start ui_handle.toolbar, false, false, 3 
      \pack_start (with Gtk.Grid { row_homogeneous: false, column_homogeneous: true }

        \attach (Gtk.Label { label: 'Daylight' }), 0, 0, 1, 1
        \attach @daylight, 1, 0, 1, 1

        \attach (Gtk.Label { label: 'Nightlight' }), 0, 1, 1, 1
        \attach @nightlight, 1, 1, 1, 1

        \attach (Gtk.Label { label: 'Enable day-night transitions' }), 0, 2, 1, 1
        \attach (with Gtk.Box!
          \add @trans
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

  create_scale: (id, start, funct) =>
    Gtk.Scale { 
      id: id
      digits: 0
      orientation: 'HORIZONTAL'
        adjustment: Gtk.Adjustment { 
        lower: 2500
        upper: 6000
        value: start
        step_increment: 50
        on_value_changed: =>
          val = @get_value!
          newval = math.floor(val/50)*50
          @set_value newval if val != newval
          funct newval -- Set value in state
      }
    }