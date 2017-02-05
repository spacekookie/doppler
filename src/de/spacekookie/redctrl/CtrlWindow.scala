package de.spacekookie.redctrl

import org.gnome.gdk.Event
import org.gnome.gtk._

object Controller {
  
  
  
  def main(args: Array[String]) {
    Gtk.init(args);

    val window = new Window();
    val save = new Button(" Save ");
    val quit = new Button(" Quit ");
    val transition = new CheckButton("Enable day-night transition");
    val layout = new VBox(false, 3);

    window.setTitle("Redshift Control");
    window.add(layout);
    window.setSizeRequest(350, 250);

    layout.add(new Label(" Setup Redshift boundry values "));

    var adj = new Adjustment();
    adj.setLower(2000);
    adj.setUpper(5500);
    adj.setValue(3500);
    var night = new Scale(Orientation.HORIZONTAL, adj);

    var adj2 = new Adjustment();
    adj2.setLower(2000);
    adj2.setUpper(5500);
    adj2.setValue(4500);
    var day = new Scale(Orientation.HORIZONTAL, adj2);

    layout.add(day);
    layout.add(night);

    layout.add(transition);
    layout.add(new HSeparator);
    
    layout.add(save);
    layout.add(quit)
    window.showAll();

    window.connect(new Window.DeleteEvent {
      def onDeleteEvent(w: Widget, e: Event) = {
        Gtk.mainQuit
        false
      }
    })

    Gtk.main();
  }
}
