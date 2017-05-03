require 'luarocks.loader'

-- Import statements sorted by length #ocd #feminism
Redstate = require 'redctrl.redstate'
RedGUI = require 'redctrl.simple_gui'

-- Initialise state
state = Redstate!

-- Finally initialise UI and run the app
app = RedGUI state
app\run!
