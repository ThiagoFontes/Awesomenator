--[[
											 
	 Powerarrow Darker Awesome WM config 2.0 
	 github.com/copycat-killer
	 
	 Modified By Thiago Fontes
	 github.com/ThiagoFontes
											 
--]]

-- {{{ Required libraries
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
				  require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local drop      = require("scratchdrop")
local lain      = require("lain")
local menubar	= require("menubar")
local vicious	= require("vicious")
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
					 title = "Oops, there were errors during startup!",
					 text = awesome.startup_errors })
end

do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
						 title = "Oops, an error happened!",
						 text = err })
		in_error = false
	end)
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
	 findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

--run_once("urxvtd")
--run_once("unclutter -root")
--run_once("terminator screenfetch")
--run_once("VBoxClient-all &")
--run_once("xrandr --newmode "1368x768"   85.25  1368 1440 1576 1784  768 771 781 798 -hsync +vsync")
--run_once("xrandr --addmode VGA-0 1368x768")
--run_once("xrandr --output VGA-0 --mode  1368x768")
run_once("conky")
run_once("xcompmgr -n -C &")
--run_once("setxkbmap -model abnt2 -layout br")
--run_once("terminator -x /root/archupdate.sh")
--run_once("terminator -x top")
--run_once("terminator -x iftop")
-- }}}
-- {{{ Variable definitions

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-green/theme.lua")

local pomodoro = require("pomodoro")
pomodoro.init()
-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "terminator"
editor     = os.getenv("EDITOR") or "gedit" or "nano"
editor_cmd = terminal .. editor .. " -e " 

-- user defined
browser    = "firefox"


--browser2   = "iron"
--gui_editor = "gvim"
--graphics   = "gimp"
--mail       = terminal .. " -e mutt "
--iptraf     = terminal .. " -g 180x54-20+34 -e sudo iptraf-ng -i all "
--musicplr   = terminal .. " -g 130x34-320+16 -e ncmpcpp "

local layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
}
-- }}}

-- {{{ Tags
tags = {
   names = { "w", "e", "s", "o","m","e"},
   layout = { layouts[4], layouts[3], layouts[2], layouts[1], layouts[2], layouts[2]}
}

for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.maximized(beautiful.wallpaper, s, true)
	end
end
-- }}}

function get_conky()
	local clients = client.get()
	local conky = nil
	local i = 1
	while clients[i]
	do
		if clients[i].class == "Conky"
		then
			conky = clients[i]
		end
		i = i + 1
	end
	return conky
end
function raise_conky()
	local conky = get_conky()
	if conky
	then
		conky.ontop = true
	end
end
function lower_conky()
	local conky = get_conky()
	if conky
	then
		conky.ontop = false
	end
end
function toggle_conky()
	local conky = get_conky()
	if conky
	then
		if conky.ontop
		then
			conky.ontop = false
		else
			conky.ontop = true
		end
	end
end

--]]
--[[
--Aplications
apacheds 		= "/root/Downloads/ApacheDirectoryStudio/ApacheDirectoryStudio"
apacheds_icon		= "/root/Downloads/ApacheDirectoryStudio/icon.png"
sublime		= "/root/Downloads/SublimeText2/sublime_text"
sublime_icon 		= "/root/Downloads/SublimeText2/Icon/16x16/sublime_text.png"

--Scripts
status_slapd_nslcd		=	"/root/Scripts/status_slapd_nslcd.sh"
slapd_restart			=	"/root/Scripts/slapd_restart.sh"
slapd_stop			=	"/root/Scripts/slapd_stop.sh"
nslcd_restart 			=	"/root/Scripts/nslcd_restart.sh"
nslcd_stop			=	"/root/Scripts/nslcd_stop.sh"

status_httpd_mysqld	=	"/root/Scripts/status_httpd_mysqld.sh"
httpd_restart			=	"/root/Scripts/httpd_restart.sh"
httpd_stop			=	"/root/Scripts/httpd_stop.sh"
mysqld_restart		=	"/root/Scripts/mysqld_restart.sh"
mysqld_stop			=	"/root/Scripts/mysqld_stop.sh"


authdmenu = {
	{"Status",		status_slapd_nslcd},
	{"Restart SLAPD",	slapd_restart,		beautiful.restart_icon},
	{"Stop SLAPD",		slapd_stop},
	{"Restart NSLCD",	nslcd_restart,		beautiful.restart_icon},
	{"Stop NSLCD",		nslcd_stop}
}
webdmenu = {
	{"Status",		status_httpd_mysqld},
	{"Restart HTTPD",	httpd_restart,		beautiful.restart_icon},
	{"Stop HTTPD",		httpd_stop},
	{"Restart MYSQLD",	mysqld_restart,		beautiful.restart_icon},
	{"Stop MYSQLD",	mysqld_stop}
}
daemonsmenu = {
	{"Auth",	authdmenu},
	{"Web", 	webdmenu}
}


]]--

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   --{ "manual", terminal .. " -e man awesome" },
   --{ "edit config", editor_cmd .. " " .. awesome.conffile },
   { "reload",	awesome.restart },
   { "quit",	awesome.quit }
}

mymainmenu = awful.menu({ items = { 
	{ "awesome", myawesomemenu, beautiful.awesome_icon },
	--{ "Daemons", daemonsmenu},
	--{"ApacheDS", apacheds, apacheds_icon},
	--{"Sublime", sublime,sublime_icon},
	{ "open terminal", terminal, beautiful.terminal_icon },
	{ "Reboot", "reboot", beautiful.restart_icon},
	{ "Shutdown", "shutdown now", beautiful.shutdown_icon}}
})

mylauncher = awful.widget.launcher({image = beautiful.arch_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
markup = lain.util.markup
separators = lain.util.separators

-- Textclock
--[[clockicon = wibox.widget.imagebox(beautiful.widget_clock)
mytextclock = awful.widget.textclock(" %a %d %b  %H:%M")

mytextclock = lain.widgets.abase({
	timeout  = 60,
	--cmd      = "date +'%a %d %b %R'",
	cmd      = "date +'%a %d %b'",
	settings = function() 
		widget:set_text(" " .. output)
	end
})

-- calendar
lain.widgets.calendar:attach(mytextclock, { font_size = 10 })
--]]
 ------------------------------------------------------
 -- Binary clock

 local binClock = wibox.widget.base.make_widget()
 binClock.radius = 1.5
 binClock.shift = 1.8
 binClock.farShift = 2
 binClock.border = 1
 binClock.lineWidth = 1
 binClock.colorActive = beautiful.bg_focus 
 
 binClock.fit = function(binClock, width, height)
	local size = math.min(width, height)
	return 6 * 2 * binClock.radius + 5 * binClock.shift + 2 * binClock.farShift + 2 * binClock.border + 2 * binClock.border, size
 end
 
 binClock.draw = function(binClock, wibox, cr, width, height)
	local curTime = os.date("*t")
 
	local column = {}
	table.insert(column, string.format("%04d", binClock:dec_bin(string.sub(string.format("%02d", curTime.hour), 1, 1))))
	table.insert(column, string.format("%04d", binClock:dec_bin(string.sub(string.format("%02d", curTime.hour), 2, 2))))
	table.insert(column, string.format("%04d", binClock:dec_bin(string.sub(string.format("%02d", curTime.min), 1, 1))))
	table.insert(column, string.format("%04d", binClock:dec_bin(string.sub(string.format("%02d", curTime.min), 2, 2))))
	table.insert(column, string.format("%04d", binClock:dec_bin(string.sub(string.format("%02d", curTime.sec), 1, 1))))
	table.insert(column, string.format("%04d", binClock:dec_bin(string.sub(string.format("%02d", curTime.sec), 2, 2))))
 
	local bigColumn = 0
	for i = 0, 5 do
		if math.floor(i / 2) > bigColumn then
			bigColumn = bigColumn + 1
		end
		for j = 0, 3 do
			if string.sub(column[i + 1], j + 1, j + 1) == "0" then 
				active = false 
			else 
				active = true 
			end 
			binClock:draw_point(cr, bigColumn, i, j, active)
		end
	end
 end
 
 binClock.dec_bin = function(binClock, inNum)
	inNum = tonumber(inNum)
	local base, enum, outNum, rem = 2, "01", "", 0
	while inNum > (base - 1) do
		inNum, rem = math.floor(inNum / base), math.fmod(inNum, base)
		outNum = string.sub(enum, rem + 1, rem + 1) .. outNum
	end
	outNum = inNum .. outNum
	return outNum
 end
 
 binClock.draw_point = function(binClock, cr, bigColumn, column, row, active)
	cr:arc(binClock.border + column * (2 * binClock.radius + binClock.shift) + bigColumn * binClock.farShift + binClock.radius,
		 binClock.border + row * (2 * binClock.radius + binClock.shift) + binClock.radius, 2, 0, 2 * math.pi)
	if active then
		cr:set_source_rgba(0, 0.8, 0, 1)
	else
		cr:set_source_rgba(0.8, 0.8, 0.8, 1)
	end
	cr:fill()
 end
 
 binClocktimer = timer { timeout = 1 }
 binClocktimer:connect_signal("timeout", function() binClock:emit_signal("widget::updated") end)
 binClocktimer:start()


-- Mail IMAP check
mailicon = wibox.widget.imagebox(beautiful.widget_mail)
mailicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(mail) end)))
--[[ commented because it needs to be set before use
mailwidget = lain.widgets.imap({
	timeout  = 180,
	server   = "server",
	mail     = "mail",
	password = "keyring get mail",
	settings = function()
		if mailcount > 0 then
			widget:set_text(" " .. mailcount .. " ")
			mailicon:set_image(beautiful.widget_mail_on)
		else
			widget:set_text("")
			mailicon:set_image(beautiful.widget_mail)
		end
	end
})
]]

-- MPD
--[[mpdicon = wibox.widget.imagebox(beautiful.widget_music)
mpdicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
mpdwidget = lain.widgets.mpd({
	settings = function()
		if mpd_now.state == "play" then
			artist = " " .. mpd_now.artist .. " "
			title  = mpd_now.title  .. " "
			mpdicon:set_image(beautiful.widget_music_on)
		elseif mpd_now.state == "pause" then
			artist = " mpd "
			title  = "paused "
		else
			artist = ""
			title  = ""
			mpdicon:set_image(beautiful.widget_music)
		end

		widget:set_markup(markup("#EA6F81", artist) .. title)
	end
})--]]

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
	settings = function()
		widget:set_text(" " .. mem_now.used .. "MB ")
	end
})

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = lain.widgets.cpu({
	settings = function()
		widget:set_text(" " .. cpu_now.usage .. "% ")
	end
})

-- Coretemp
--[[tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
	settings = function()
		widget:set_text(" " .. coretemp_now .. "°C ")
	end
})-]]

-- / fs
fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
fswidget = lain.widgets.fs({
	settings  = function()
		widget:set_text(" " .. fs_now.used .. "% ")
	end
})

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_battery)
batwidget = lain.widgets.bat({
	settings = function()
		if bat_now.perc == "N/A" then
			widget:set_markup(" AC ")
			baticon:set_image(beautiful.widget_ac)
			return
		elseif tonumber(bat_now.perc) <= 5 then
			baticon:set_image(beautiful.widget_battery_empty)
		elseif tonumber(bat_now.perc) <= 25 then
			baticon:set_image(beautiful.widget_battery_low)
		else
			baticon:set_image(beautiful.widget_battery)
		end
		widget:set_markup(" " .. bat_now.perc .. "% ")
	end
})

-- ALSA volume
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volumewidget = lain.widgets.alsa({
	settings = function()
		if volume_now.status == "off" then
			volicon:set_image(beautiful.widget_vol_mute)
		elseif tonumber(volume_now.level) == 0 then
			volicon:set_image(beautiful.widget_vol_no)
		elseif tonumber(volume_now.level) <= 50 then
			volicon:set_image(beautiful.widget_vol_low)
		else
			volicon:set_image(beautiful.widget_vol)
		end

		widget:set_text(" " .. volume_now.level .. "% ")
	end
})

-- Net
neticon = wibox.widget.imagebox(beautiful.widget_net)
neticon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))
netwidget = lain.widgets.net({
	settings = function()
		widget:set_markup(markup("#7AC82E", " " .. net_now.received)
						  .. " " ..
						  markup("#46A8C3", " " .. net_now.sent .. " "))
	end
})


-- Separators
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = separators.arrow_left(beautiful.bg_focus, "alpha") 
arrl_ld = separators.arrow_left("alpha", beautiful.bg_focus) 

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
					awful.button({ }, 1, awful.tag.viewonly),
					awful.button({ modkey }, 1, awful.client.movetotag),
					awful.button({ }, 3, awful.tag.viewtoggle),
					awful.button({ modkey }, 3, awful.client.toggletag),
					awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
					awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
					)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
					 awful.button({ }, 1, function (c)
											  if c == client.focus then
												  c.minimized = true
											  else
												  -- Without this, the following
												  -- :isvisible() makes no sense
												  c.minimized = false
												  if not c:isvisible() then
													  awful.tag.viewonly(c:tags()[1])
												  end
												  -- This will also un-minimize
												  -- the client, if needed
												  client.focus = c
												  c:raise()
											  end
										  end),
					 awful.button({ }, 3, function ()
											  if instance then
												  instance:hide()
												  instance = nil
											  else
												  instance = awful.menu.clients({ width=250 })
											  end
										  end),
					 awful.button({ }, 4, function ()
											  awful.client.focus.byidx(1)
											  if client.focus then client.focus:raise() end
										  end),
					 awful.button({ }, 5, function ()
											  awful.client.focus.byidx(-1)
											  if client.focus then client.focus:raise() end
										  end))

for s = 1, screen.count() do

	-- Create a promptbox for each screen
	mypromptbox[s] = awful.widget.prompt()

	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
							awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
							awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
							awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
							awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s, height = 20 })

	-- Widgets that are aligned to the upper left
	local left_layout = wibox.layout.fixed.horizontal()
   -- left_layout:add(spr)
	left_layout:add(mylauncher)
	left_layout:add(spr)
	left_layout:add(mytaglist[s])
	left_layout:add(mypromptbox[s])
	left_layout:add(spr)

	-- Widgets that are aligned to the upper right
	local right_layout_toggle = true
	local function right_layout_add (...)  
		local arg = {...}
		if right_layout_toggle then
			right_layout:add(arrl_ld)
			for i, n in pairs(arg) do
				right_layout:add(wibox.widget.background(n ,beautiful.bg_focus))
			end
		else
			right_layout:add(arrl_dl)
			for i, n in pairs(arg) do
				right_layout:add(n)
			end
		end
		right_layout_toggle = not right_layout_toggle
	end
	
	right_layout = wibox.layout.fixed.horizontal()
	if s == 1 then right_layout:add(wibox.widget.systray()) end
	right_layout:add(spr)
	right_layout:add(arrl)
	right_layout:add(pomodoro.icon_widget)
	right_layout:add(pomodoro.widget)
	--right_layout_add(mpdicon, mpdwidget)
	right_layout_add(volicon, volumewidget)
	--right_layout_add(mailicon, mailwidget)
	right_layout_add(memicon, memwidget)
	right_layout_add(cpuicon, cpuwidget)
	--right_layout_add(tempicon, tempwidget)
	right_layout_add(fsicon, fswidget)
	right_layout_add(baticon, batwidget)
	right_layout_add(neticon,netwidget)
	--right_layout_add(mytextclock, spr)
	right_layout_add(spr, binClock, spr)
	right_layout_add(mylayoutbox[s])

	-- Now bring it all together (with the tasklist in the middle)
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)
	mywibox[s]:set_widget(layout)

end
-- }}}

-- {{{ Mouse Bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	-- Take a screenshot
	-- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
	awful.key({ altkey }, "p", function() os.execute("screenshot") end),
	--CONKY
	awful.key({}, "F10", function() raise_conky() end, function() lower_conky() end),

	-- Tag browsing
	awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
	awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
	awful.key({ modkey }, "Escape", awful.tag.history.restore),

	-- Non-empty tag browsing
	awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
	awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

	-- Default client focus
	awful.key({ altkey }, "k",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ altkey }, "j",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),

	-- By direction client focus
	awful.key({ modkey }, "j",
		function()
			awful.client.focus.bydirection("down")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "k",
		function()
			awful.client.focus.bydirection("up")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "h",
		function()
			awful.client.focus.bydirection("left")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "l",
		function()
			awful.client.focus.bydirection("right")
			if client.focus then client.focus:raise() end
		end),

	-- Show Menu
	awful.key({ modkey }, "w",
		function ()
			mymainmenu:show({ keygrabber = true })
		end),

	-- Show/Hide Wibox
	awful.key({ modkey }, "b", function ()
		mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
	end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey,           }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end),
	awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
	awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
	awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
	awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
	awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
	awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
	awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
	awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
	awful.key({ modkey, "Control" }, "n",      awful.client.restore),

	-- Standard program
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
	awful.key({ modkey, "Control" }, "r",      awesome.restart),
	awful.key({ modkey, "Shift"   }, "q",      awesome.quit),
	
	 -- Menubar
	awful.key({ modkey }, "p", function() menubar.show() end),
	
	-- Dropdown terminal
	awful.key({ modkey,	          }, "z",      function () drop(terminal) end),

	-- Widgets popups
	awful.key({ altkey,           }, "c",      function () lain.widgets.calendar:show(7) end),
	awful.key({ altkey,           }, "h",      function () fswidget.show(7) end),

	-- ALSA volume control
	awful.key({ altkey }, "Up",
		function ()
			os.execute(string.format("amixer -c %s set %s 1+", volumewidget.card, volumewidget.channel))
			volumewidget.update()
		end),
	awful.key({ altkey }, "Down",
		function ()
			os.execute(string.format("amixer -c %s set %s 1-", volumewidget.card, volumewidget.channel))
			volumewidget.update()
		end),
	awful.key({ altkey }, "m",
		function ()
			os.execute(string.format("amixer -c %s set %s toggle", volumewidget.card, volumewidget.channel))
			--os.execute(string.format("amixer set %s toggle", volumewidget.channel))
			volumewidget.update()
		end),
	awful.key({ altkey, "Control" }, "m",
		function ()
			os.execute(string.format("amixer -c %s set %s 100%%", volumewidget.card, volumewidget.channel))
			volumewidget.update()
		end),

	-- MPD control
	--[[awful.key({ altkey, "Control" }, "Up",
		function ()
			awful.util.spawn_with_shell("mpc toggle || ncmpc toggle || pms toggle")
			mpdwidget.update()
		end),
	awful.key({ altkey, "Control" }, "Down",
		function ()
			awful.util.spawn_with_shell("mpc stop || ncmpc stop || pms stop")
			mpdwidget.update()
		end),
	awful.key({ altkey, "Control" }, "Left",
		function ()
			awful.util.spawn_with_shell("mpc prev || ncmpc prev || pms prev")
			mpdwidget.update()
		end),
	awful.key({ altkey, "Control" }, "Right",
		function ()
			awful.util.spawn_with_shell("mpc next || ncmpc next || pms next")
			mpdwidget.update()
		end),--]]

	-- Copy to clipboard
	awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

	-- User programs
	awful.key({ modkey }, "q", function () awful.util.spawn(browser) end),
	awful.key({ modkey }, "i", function () awful.util.spawn(browser2) end),
	awful.key({ modkey }, "s", function () awful.util.spawn(gui_editor) end),
	awful.key({ modkey }, "g", function () awful.util.spawn(graphics) end),

	-- Prompt
	awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
	awful.key({ modkey }, "x",
			  function ()
				  awful.prompt.run({ prompt = "Run Lua code: " },
				  mypromptbox[mouse.screen].widget,
				  awful.util.eval, nil,
				  awful.util.getdir("cache") .. "/history_eval")
			  end)

)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({ modkey,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end),
	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
)

-- Bind all key numbers to tags.
-- be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
				  function ()
						local screen = mouse.screen
						local tag = awful.tag.gettags(screen)[i]
						if tag then
						   awful.tag.viewonly(tag)
						end
				  end),
		-- Toggle tag.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
				  function ()
					  local screen = mouse.screen
					  local tag = awful.tag.gettags(screen)[i]
					  if tag then
						 awful.tag.viewtoggle(tag)
					  end
				  end),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus then
						  local tag = awful.tag.gettags(client.focus.screen)[i]
						  if tag then
							  awful.client.movetotag(tag)
						  end
					 end
				  end),
		-- Toggle tag.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus then
						  local tag = awful.tag.gettags(client.focus.screen)[i]
						  if tag then
							  awful.client.toggletag(tag)
						  end
					  end
				  end))
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
	-- All clients will match this rule.
   { rule = { class = "Conky" },
	 properties = {
	  floating = true,
	  sticky = true,
	  ontop = false,
	  focusable = false,
	  size_hints = {"program_position", "program_size"}
	}},--]]
	
	
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
					 border_color = beautiful.border_normal,
					 focus = awful.client.focus.filter,
					 keys = clientkeys,
					 buttons = clientbuttons,
					   size_hints_honor = false } },
	{ rule = { class = "URxvt" },
		  properties = { opacity = 0.99 } },

	{ rule = { class = "MPlayer" },
		  properties = { floating = true } },

	{ rule = { class = "Dwb" },
		  properties = { tag = tags[1][1] } },

	{ rule = { class = "Iron" },
		  properties = { tag = tags[1][1] } },

	{ rule = { instance = "plugin-container" },
		  properties = { tag = tags[1][1] } },

	  { rule = { class = "Gimp" },
			properties = { tag = tags[1][4] } },

	{ rule = { class = "Gimp", role = "gimp-image-window" },
		  properties = { maximized_horizontal = true,
						 maximized_vertical = true } },
}
-- }}}

-- {{{ Signals
-- signal function to execute when a new client appears.
local sloppyfocus_last = {c=nil}
client.connect_signal("manage", function (c, startup)
	-- Enable sloppy focus
	client.connect_signal("mouse::enter", function(c)
		 if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			and awful.client.focus.filter(c) then
			 -- Skip focusing the client if the mouse wasn't moved.
			 if c ~= sloppyfocus_last.c then
				 client.focus = c
				 sloppyfocus_last.c = c
			 end
		 end
	 end)

	local titlebars_enabled = false
	if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
		-- buttons for the titlebar
		local buttons = awful.util.table.join(
				awful.button({ }, 1, function()
					client.focus = c
					c:raise()
					awful.mouse.client.move(c)
				end),
				awful.button({ }, 3, function()
					client.focus = c
					c:raise()
					awful.mouse.client.resize(c)
				end)
				)
		 -- Widgets that are aligned to the left
		local left_layout = wibox.layout.fixed.horizontal()
		left_layout:add(awful.titlebar.widget.iconwidget(c))
		left_layout:buttons(buttons)

		-- widgets that are aligned to the right
		local right_layout = wibox.layout.fixed.horizontal()
		right_layout:add(awful.titlebar.widget.floatingbutton(c))
		right_layout:add(awful.titlebar.widget.maximizedbutton(c))
		right_layout:add(awful.titlebar.widget.stickybutton(c))
		right_layout:add(awful.titlebar.widget.ontopbutton(c))
		right_layout:add(awful.titlebar.widget.closebutton(c))

		-- the title goes in the middle
		local middle_layout = wibox.layout.flex.horizontal()
		local title = awful.titlebar.widget.titlewidget(c)
		title:set_align("center")
		middle_layout:add(title)
		middle_layout:buttons(buttons)

		-- now bring it all together
		local layout = wibox.layout.align.horizontal()
		layout:set_right(right_layout)
		layout:set_middle(middle_layout)

		awful.titlebar(c,{size=18}):set_widget(layout)
	end
end)

-- No border for maximized clients
client.connect_signal("focus",
	function(c)
		if c.maximized_horizontal == true and c.maximized_vertical == true then
			c.border_color = beautiful.border_normal
		else
			c.border_color = beautiful.border_focus
		end
	end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
		local clients = awful.client.visible(s)
		local layout  = awful.layout.getname(awful.layout.get(s))

		if #clients > 0 then -- Fine grained borders and floaters control
			for _, c in pairs(clients) do -- Floaters always have borders
				if awful.client.floating.get(c) or layout == "floating" then
					c.border_width = beautiful.border_width

				-- No borders with only one visible client
				elseif #clients == 1 or layout == "max" then
					c.border_width = 0
				else
					c.border_width = beautiful.border_width
				end
			end
		end
	  end)
end
-- }}}
