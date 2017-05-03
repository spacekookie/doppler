require 'luarocks.loader'

-- Import statements sorted by length #ocd #feminism
Redstate = require 'redctrl.redstate'
RedGUI = require 'redctrl.ui_handler'

-- Initialise state
state = Redstate!

-- TODO: Load previous configuration for state

-- Finally initialise UI and run the app
app = RedGUI state, 300, 400
app\run!
