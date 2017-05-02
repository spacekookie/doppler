require 'luarocks.loader'
lgi = require 'lgi'
Gtk = lgi.require 'Gtk'

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
        .on_clicked = =>
          with Gtk.AboutDialog {
            program_name: 'Moonscript is awesome Demo'
            title: 'About that...'
            name: 'LGI Wazzap'
            copyright: '(C) Copyright 2017 Yo Mama'
            authors: { 'spacekookie' }
          }
            .license_type = Gtk.License.MIT_X11
            \run!
            \hide!
    ), -1

  -- Pack everything into the window.
  \add with Gtk.VBox!
    \pack_start toolbar, false, false, 0
    \pack_start (Gtk.Label { label: 'Contents' }), true, true, 0
    \pack_end status_bar, false, false, 0

  \show_all!

Gtk\main!

