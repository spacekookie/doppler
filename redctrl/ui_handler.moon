lgi = require 'lgi'
math = require 'math'
Gtk = lgi.require 'Gtk'


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

      -- Initialise and add a simple UI because that's all we know
      @simple = (require 'redctrl.simple_ui') @, @state
      \add @simple.ui

      -- Show our creation to the world \o/
      \show_all!

  run: => Gtk\main!