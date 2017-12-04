using Gtk;


int main (string[] args) {
    Gtk.init (ref args);
 
    try {
        var builder = new Builder();
        builder.add_from_file("settings.ui");
        builder.connect_signals(null);
 
        var window = builder.get_object("window") as Window;
        var switcheroo = builder.get_object("redctrl_simple_switch") as Gtk.Switch;
        var simple_settings = builder.get_object("redctrl_simple_setting") as Gtk.Revealer;
        var normal_settings = builder.get_object("redctrl_normal_setting") as Gtk.Revealer;

        var drawing_area = builder.get_object("redctrl_curve_settings") as DrawingArea;
        drawing_area.draw.connect ((context) => {
            weak Gtk.StyleContext style_context = drawing_area.get_style_context ();
            int height = drawing_area.get_allocated_height ();
            int width = drawing_area.get_allocated_width ();
            Gdk.RGBA color = new Gdk.RGBA();
            
            /* Render a background (maybe based on current color? */
            color.parse("#ffccb2");
            context.rectangle(0, 0, width, height);
            Gdk.cairo_set_source_rgba (context, color);
            context.fill();
            
            context.move_to (0, height / 2);
            context.set_source_rgba (0.25, 0.25, 0.25, 0.75);
            context.rel_curve_to (0, 0, 75, -50, 150, -height);
            context.stroke ();

            return true;
        });


        switcheroo.state_set.connect((state) => {
            stdout.printf("Setting state to: %i\n", (int) state);
            normal_settings.reveal_child = !state;
            simple_settings.reveal_child = state;

            return false;
        });

        window.show_all();
        Gtk.main();
     } catch (Error e) {
        stderr.printf("Could not load UI: %s\n", e.message);
        return 1;
     }
 
     return 0;
}
