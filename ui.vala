using Gtk;

//  public void enable_simple_mode(Gtk.Switch sw, bool state) {
//      if(state) {
//          stdout.printf("On :)\n");
//      } else {
//          stdout.printf("Off :(\n");
//      }
//  }

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


//  public class Application : Gtk.Window {
//  	public Application () {

//  		// Prepare Gtk.Window:
//  		this.title = "My Gtk.DrawingArea";
//  		this.window_position = Gtk.WindowPosition.CENTER;
//  		this.destroy.connect (Gtk.main_quit);
//  		this.set_default_size (400, 400);

//  		// The drawing area:
//  		Gtk.DrawingArea drawing_area = new Gtk.DrawingArea ();
//  		drawing_area.draw.connect ((context) => {
//  			weak Gtk.StyleContext style_context = drawing_area.get_style_context ();
//  			int height = drawing_area.get_allocated_height ();
//  			int width = drawing_area.get_allocated_width ();
//  			Gdk.RGBA color = style_context.get_color (0);

//  			// Draw an arc:
//  			double xc = width / 2.0;
//  			double yc = height / 2.0;
//  			double radius = int.min (width, height) / 2.0;
//  			double angle1 = 0;
//  			double angle2 = 2*Math.PI;

//  			context.arc (xc, yc, radius, angle1, angle2);
//  			Gdk.cairo_set_source_rgba (context, color);
//  			context.fill ();
//  			return true;
//  		});
//  		this.add (drawing_area);
//  	}

//  	public static int main (string[] args) {
//  		Gtk.init (ref args);

//  		Application app = new Application ();
//  		app.show_all ();
//  		Gtk.main ();
//  		return 0;
//  	}
//  }