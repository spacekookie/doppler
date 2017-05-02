lgi = require 'lgi'
Gtk = lgi.require 'Gtk'

dialog= with Gtk.AboutDialog {
    program_name: 'Moonscript is awesome Demo'
    title: 'About that...'
    name: 'LGI Wazzap'
    copyright: '(C) Copyright 2017 Yo Mama'
    authors: { 'spacekookie' }
  }
    .license_type = Gtk.License.MIT_X11

=> with dialog
  \run!
  \hide!
