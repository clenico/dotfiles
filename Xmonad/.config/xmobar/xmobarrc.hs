-- http://projects.haskell.org/xmobar/
-- install xmobar with these flags: --flags="with_alsa" --flags="with_mpd" --flags="with_xft"  OR --flags="all_extensions"
-- you can find weather location codes here: http://weather.noaa.gov/index.html

Config { font    = "xft:Ubuntu:weight=bold:pixelsize=20:antialias=true:hinting=true"
       , additionalFonts = [ "xft:FontAwesome:pixelsize=20",
                             "xft:Mononoki Nerd Font:pixelsize=20:antialias=true:hinting=true",
                             "xft:Mononoki Nerd Font:pixelsize=11:antialias=true:hinting=true"
                           ]
       , bgColor = "#292d3e"
       , fgColor = "#f07178"
       -- , position = Static { xpos = 0 , ypos = 1080, width = 1920, height = 35 }
       , position = Bottom
       -- , position = BottomW 100 10
       , border = TopB
       , sepChar =  "%"   -- delineator between plugin names and straight text
       , alignSep = "}{"  -- separator between left-right alignment
       -- , template = "  %UnsafeStdinReader% }{ <fc=#666666><fn=3>|</fn> </fc><fc=#b3afc2><fn=1></fn>  %Battery% </fc><fc=#666666> <fn=2>|</fn></fc> <fc=#FFB86C> %cpu% </fc><fc=#666666> <fn=2>|</fn></fc> <fc=#FF5555> %memory% </fc><fc=#666666> <fn=2>|</fn></fc> <fc=#82AAFF> %disku% </fc><fc=#666666> <fn=2>|</fn></fc> <fc=#c3e88d> %enp6s0% </fc><fc=#666666> </fc> <fc=#666666> <fn=2>|</fn></fc> <fc=#8BE9FD> %date%  </fc>"
       , template = "  %UnsafeStdinReader% <fc=#666666><fn=2> | </fn></fc> <fc=#b3afc2>%alsa:default:Master% </fc><fc=#666666><fn=2> | </fn></fc><fc=#b3afc2><fn=1></fn>%battery% </fc><fc=#666666> <fn=2>|</fn></fc> <fc=#FFB86C> %cpu% %multicoretemp% </fc><fc=#666666> <fn=2>|</fn></fc> <fc=#FF5555> %memory% </fc><fc=#666666> <fn=2>|</fn></fc> <fc=#82AAFF> %disku% </fc> <fc=#666666><fn=2>|</fn></fc> <fc=#8BE9FD> %date%  </fc>"
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , iconRoot = "/home/niccle27/.xmonad/xpm/"  -- default: "."
       , commands = [

                     -- volume indicator
                     Run Alsa "default" "Master"
                               [ "-t", "<fn=1>\xf028</fn>:<volumestatus>"
                               , "--"
                               , "-C", "#C0E550", "-c", "#E55C50"]

                      -- Time and date
                    ,  Run Date "%d %m %Y %H:%M" "date" 50
                      -- Network up and down
                              -- network activity monitor (dynamic interface resolution)
                    , Run DynNetwork     [ "--template" , "<dev>: <tx>kB/s|<rx>kB/s"
                                         , "--Low"      , "1000"       -- units: B/s
                                         , "--High"     , "5000"       -- units: B/s
                                         , "--low"      , "darkgreen"
                                         , "--normal"   , "darkorange"
                                         , "--high"     , "darkred"
                                         ] 10
                      -- Cpu usage in percent
                    , Run Cpu ["-t", "<fn=1>\xf108</fn>: <total>%","-H","50","--high","red"] 20


                    , Run MultiCoreTemp ["-t", "<avg>°C",
                                         "-L", "60", "-H", "80",
                                         "-l", "green", "-n", "yellow", "-h", "red",
                                         "--", "--mintemp", "20", "--maxtemp", "100"] 50

                      -- Ram used number and percent
                    , Run Memory ["-t", "<usedratio>%"] 20
                    -- battery monitor
                    , Run Battery        [ "--template" , ": <acstatus>"
                                         , "--Low"      , "10"        -- units: %
                                         , "--High"     , "80"        -- units: %
                                         , "--low"      , "darkred"
                                         , "--normal"   , "darkorange"
                                         , "--high"     , "darkgreen"

                                         , "--" -- battery specific options
                                                   -- discharging status
                                                   , "-o"	, "<left>%"
                                                   -- AC "on" status
                                                   , "-O"	, "<fc=#dAA520>c:<left>%</fc>"
                                                   -- charged status
                                                   , "-i"	, "<fc=#006000>C:<left>%</fc>"
                                         ] 50

                      -- Disk space free
                    , Run DiskU [("/", "r: <used>/<size>"),
                                 ("/home", "h: <used>/<size>")] [] 60
                    , Run Volume "default" "Master" [] 10
                    -- , Run DiskU [("/home", "<fn=1>\xf0c7</fn> home: <free> free")] [] 60
                      -- Runs custom script to check for pacman updates.
                      -- This script is in my dotfiles repo in .local/bin.
                    -- , Run Com "pacupdate" [] "" 36000
                      -- Runs a standard shell command 'uname -r' to get kernel version
                    -- , Run Com "uname" ["-r"] "" 3600
                      -- Prints out the left side items such as workspaces, layout, etc.
                      -- The workspaces are 'clickable' in my configs.
                    , Run UnsafeStdinReader
                    ]

       }
