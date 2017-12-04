using Gtk;
using GLib;

public void enable_simple_mode(Gtk.Switch sw, bool state) {
    if(state) {
        stdout.printf("On :)\n");
    } else {
        stdout.printf("Off :(\n");
    }
}

int main (string[] args) {
    Gtk.init (ref args);
 
    try {
         var builder = new Builder();
         builder.add_from_file("settings.ui");
         builder.connect_signals(null);
 
         var window = builder.get_object("window") as Window;
         window.show_all();
         Gtk.main();
     } catch (Error e) {
         stderr.printf("Could not load UI: %s\n", e.message);
         return 1;
     }
 
     return 0;
 }
