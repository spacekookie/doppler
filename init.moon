-- Fix package path for redctrl
package.path = "?.lua;?/init.lua;" .. package.path

-- Then load our app
require 'redctrl'
