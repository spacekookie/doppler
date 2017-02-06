package de.spacekookie.redctrl

import org.gnome.gdk.Event
import org.gnome.gtk._

object Controller {
  val DEF_UPPER : Int = 5500
  val DEF_LOWER : Int = 2000
  
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
    layout.add(new HSeparator);

    layout.add(sliderFactory("Day Temperature", 4500));
    layout.add(sliderFactory("Nights Temperature", 3250));

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
  
  private def sliderFactory(name: String, default: Int) : Scale = {
    var adj = new Adjustment();
    adj.setLower(DEF_LOWER);
    adj.setUpper(DEF_UPPER);
    adj.setValue(default);
    
    var scale = new Scale(Orientation.HORIZONTAL, adj);
    scale.setTooltipText(name);
    return scale;
  }
}
