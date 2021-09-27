import XMonad.Util.Cursor
import XMonad.Actions.PhysicalScreens
-- import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.UpdatePointer
import Data.Monoid
import XMonad.Hooks.DynamicProperty
-- import XMonad.Layout.Gaps
import XMonad.Layout.Named (named)
-- import XMonad.Layout.LayoutCombinators hiding ( (|||) )
import XMonad.Layout.FixedColumn
import XMonad.Layout.Dishes
import XMonad.Layout.TwoPane
import XMonad.Layout.Combo
import XMonad.Layout.DragPane
import XMonad.Layout.Spacing
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Tabbed
import XMonad.Layout.LimitWindows
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.Magnifier(magnifier)
import XMonad.Prompt                        -- to get my old key bindings working
-- import XMonad.Prompt.ConfirmPrompt          -- don't just hard quit
import XMonad.Layout.ResizableTile
import XMonad.Actions.WindowBringer
import XMonad.Actions.FloatKeys
import Data.Ratio ((%))
import XMonad.Util.WorkspaceCompare
import XMonad.Actions.CopyWindow
import XMonad.Actions.Navigation2D
import XMonad.Layout.Circle
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.WithAll
import XMonad.Actions.RotSlaves
-- import Data.Monoid
-- import Graphics.X11.ExtraTypes.XF86
import System.Exit
-- import System.IO (Handle, hPutStrLn)
import XMonad hiding ( (|||) )
import XMonad.Layout.LayoutCombinators
-- import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.DwmPromote
import XMonad.Actions.DynamicProjects
import XMonad.Actions.Minimize
import XMonad.Actions.SpawnOn
-- import XMonad.Actions.Submap
-- import XMonad.Config.Azerty
-- import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Hooks.Minimize
import XMonad.Hooks.SetWMName
-- import XMonad.Hooks.UrgencyHook
-- import XMonad.Layout.CenteredMaster(centerMaster)
-- import XMonad.Layout.Cross(simpleCross)
-- import XMonad.Layout.Fullscreen (fullscreenFull)
-- import XMonad.Layout.Gaps
import XMonad.Layout.Grid
-- import XMonad.Layout.IndependentScreens
import XMonad.Layout.Minimize
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
-- import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleFloat
-- import XMonad.Layout.Spacing
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
-- import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import qualified Codec.Binary.UTF8.String as UTF8
import qualified Data.ByteString as B
import qualified Data.Map as M
import qualified System.IO
import qualified XMonad.Actions.DynamicWorkspaceOrder as DO
import qualified XMonad.StackSet as W

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key


-- Defaults
myModMask = mod4Mask
myTerminal = "urxvt"
myFileManager = "nautilus"

prompt      = 20

base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"

active      = blue
activeWarn  = red
inactive    = base02
focusColor  = blue
unfocusColor = base02

myPromptTheme = def
    {
      font                  = "xft:Mononoki Nerd Font:pixelsize=20:antialias=true:hinting=true"
    , bgColor               = "#292D3E"
    , fgColor               = "#ebd82f"
    , fgHLight              = "#292D3E"
    , bgHLight              = "#ebd82f"
    , borderColor           = "#ebd82f"
    , promptBorderWidth     = 3
    , height                = 30
    , position              = Top
    , showCompletionOnTab   = True
    }

mydefaults = def {
          normalBorderColor   = "#0066B5"
        , focusedBorderColor  = "#00ff00"
        , focusFollowsMouse   = True
        , mouseBindings       = myMouseBindings
        , workspaces          = myWorkspaces
        , keys                = myKeys
        , modMask             = myModMask
        , borderWidth         = 3
        , layoutHook          = myLayoutHook
        , manageHook          =  manageDocks
                                 -- <+>insertPosition Below Newer
                                 <+> myManageHook
                                 <+> manageSpawn
                                 <+> namedScratchpadManageHook myScratchPads
        , startupHook         = myStartupHook
        , handleEventHook     = docksEventHook
                                <+> minimizeEventHook
                                -- <+> myHandleEventHook
        }`additionalKeysP` myKeymap


-- Projects
projects :: [Project]
projects =
  [
    Project { projectName      = "1"
            , projectDirectory = "~/"
            , projectStartHook = Just $ do
                spawn myTerminal
                spawn myTerminal
            }
  , Project { projectName      = "3"
            , projectDirectory = "~/Downloads"
            , projectStartHook = Just $ do spawn "firefox"
            }
  , Project { projectName      = "10"
            , projectDirectory = "~/"
            , projectStartHook = Just $ do spawn "thunderbird"
            }
  , Project { projectName      = "bl"
            , projectDirectory = "~/"
            , projectStartHook = Just $ do
                spawn "blender"
            }

  , Project { projectName      = "gi"
            , projectDirectory = "~/Pictures/"
            , projectStartHook = Just $ do
                spawn "gimp"
            }

  , Project { projectName      = "in"
            , projectDirectory = "~/Pictures/"
            , projectStartHook = Just $ do
                spawn "inkscape"
            }

  , Project { projectName      = "lo"
            , projectDirectory = "~/Documents/"
            , projectStartHook = Just $ do
                spawn "libreoffice"
            }

  , Project { projectName      = "nf"
            , projectDirectory = "~/Videos/"
            , projectStartHook = Just $ do
                spawn "firefox -new-window http://netflix.com"
            }

  , Project { projectName      = "ob"
            , projectDirectory = "~/Videos/"
            , projectStartHook = Just $ do
                spawn "obs"
            }
  , Project { projectName      = "py"
            , projectDirectory = "~/Documents/Programming/Python/"
            , projectStartHook = Just $ do
                spawn "pycharm"
            }

  , Project { projectName      = "sp"
            , projectDirectory = "~/Videos/"
            , projectStartHook = Just $ do
                spawn "firefox -new-window http://netflix.com"
                spawn "libreoffice"
            }

  , Project { projectName      = "ve"
            , projectDirectory = "~/Videos/"
            , projectStartHook = Just $ do
                sendMessage (JumpToLayout "Tall_little" )
                spawn myFileManager
                spawn "kdenlive"
            }

  ]

-- Named Scratchpad
nextNonEmptyWS = findWorkspace getSortByIndexNoSP Next HiddenNonEmptyWS 1
        >>= \t -> (windows . W.view $ t)
prevNonEmptyWS = findWorkspace getSortByIndexNoSP Prev HiddenNonEmptyWS 1
        >>= \t -> (windows . W.view $ t)
getSortByIndexNoSP =
        fmap (.namedScratchpadFilterOutWorkspace) getSortByIndex



-- myHandleEventHook :: Event -> X All
-- myHandleEventHook = dynamicPropertyChange "WM_NAME" (title =? "Spotify" --> manageThirdscreen)
--   -- <+> dynamicPropertyChange "WM_NAME" (className =? "URxvt" --> manageThirdscreen)



myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "dropdown-terminal" spawnTerm_dropdown (resource =? "dropdown-terminal") (manage_dropdown)
                 ,NS "floating-terminal" spawnTerm_floating (resource =? "floating-terminal") (manageThirdscreen)
                 ,NS "pavucontrol" "pavucontrol" (className =? "Pavucontrol") (manageThirdscreen)
                 ,NS "zeal" "zeal" (resource =? "zeal") (nonFloating)
                 ,NS "translate" "crow" (className =? "Crow Translate") (nonFloating)
                 -- ,NS "gnome-calendar" "gnome-calendar" (resource =? "gnome-calendar") (manageFullscreen)
                 ,NS "xfce4-appfinder" "xfce4-appfinder" (className =? "xfce4-appfinder") (manageFullscreen)
                 ,NS "note-scratchpad" "emacsclient --alternate-editor='' --no-wait --create-frame --frame-parameters='(quote (name . \"note-emacs\"))' "
                   (title =? "note-emacs") (nonFloating)
                 ,NS "agenda-emacs" "emacsclient --alternate-editor='' --no-wait --create-frame --frame-parameters='(quote (name . \"agenda-emacs\"))' --eval \"(org-agenda-list)\" \"(org-agenda-day-view)\" \"(delete-other-windows)\""
                  (title =? "agenda-emacs") (manageThirdscreen)
                 ,NS "todo-list" "emacsclient --alternate-editor='' --no-wait --create-frame --frame-parameters='(quote (name . \"todo-list\"))' --eval \"(org-todo-list)\" \"(delete-other-windows)\""
                  (title =? "todo-list") (manageThirdscreen)
                 ,NS "whatsapp" "surf https://web.whatsapp.com/" (className =? "Surf") (manageThirdscreen)
                 ,NS "spotify" "spotify" (className =? "Spotify") (defaultFloating)
                 ,NS "torrent" "qbittorrent" (className =? "qBittorrent") (manageFullscreen)
                 ,NS "skype" "skypeforlinux" (className =? "Skype") (manageFullscreen)
                 ,NS "pomodoro" "gnome-pomodoro" (className =? "Gnome-pomodoro") (manageThirdscreen)
                 ,NS "messenger" "messenger-nativefier" (className =? "facebookmessenger-nativefier-7ab88e") (manageThirdscreen)
                ]
  where
    spawnTerm_dropdown  = myTerminal ++ " -name dropdown-terminal -e tmux"
    spawnTerm_floating  = myTerminal ++ " -name floating-terminal -e tmux"

manage_dropdown = customFloating $ W.RationalRect l t w h
           where
             h = 0.5
             w = 1
             t = 0
             l = 0
manageFullscreen = customFloating $ W.RationalRect l t w h
                 where
                   h = 1
                   w = 1
                   t = 0
                   l = 0
manageThirdscreen = customFloating $ W.RationalRect l t w h
                 where
                   h = 4/5
                   w = 2/5
                   t = (1-h)/2
                   l = (1-w)/2

-- Startup
myStartupHook = do
    -- spawn "$HOME/.xmonad/scripts/autostart.sh"
    spawnOnce "exec trayer --align right --widthtype request --padding 0 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x292d3e --height 26 --margin 5 --edge bottom --distance 0 --monitor  \"primary\""
    spawnOnce "$HOME/MyScripts/autostart.sh > ~/.output/autostart.sh"
    spawnOnOnce "7" "korganizer"
    spawnOnOnce "2" myFileManager
    spawnOnOnce "3" "firefox"
    spawnOnOnce "8" "emacs"
    spawnOnOnce "NSP" "surf https://web.whatsapp.com/"
    spawnOnOnce "NSP" "messenger-nativefier"
    spawnOnOnce "NSP" "discord"
    spawnOnOnce "NSP" "gnome-pomodoro"
    spawnOnOnce "NSP" "skypeforlinux"
    setDefaultCursor xC_left_ptr
    setWMName "LG3D"

-- IDK wth is that
encodeCChar = map fromIntegral . B.unpack


-- Layouts
myTabConfig = def { fontName            = "xft:Mononoki Nerd Font:regular:pixelsize=11"
                  , activeColor         = "#292d3e"
                  , inactiveColor       = "#3e445e"
                  , activeBorderColor   = "#292d3e"
                  , inactiveBorderColor = "#292d3e"
                  , activeTextColor     = "#ffffff"
                  , inactiveTextColor   = "#d0d0d0"
                  }

-- mTabs     = renamed [Replace "tabs"]
--            -- I cannot add spacing to this layout because it will
--            -- add spacing between window and tabs which looks bad.
--            $ tabbed shrinkText myTabConfig



mFixedColumn = named "Split" (FixedColumn 1 20 30 10)


-- Makes setting the spacingRaw simpler to write. The spacingRaw
-- module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) False (Border i i i i) True

mySpacingValue = 5

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw False (Border i i i i) False (Border i i i i) False



mTall = named "Tall" (minimize
                     $ mySpacing' mySpacingValue
                     -- $ smartBorders
                     -- $ avoidStruts
                     $ ResizableTall 1 (3/100) (1/2) [])

mTall_little = named "Tall_little" (minimize
                                   $ mySpacing' mySpacingValue
                     -- $ smartBorders
                     -- $ avoidStruts
                     $ ResizableTall 1 (3/100) (1/4) [])

mDishes = named "Dishes" (minimize
                         $ mySpacing' mySpacingValue
                          $ Dishes 2 (1/6))

mThreeColMid = named "ThreeColMid" (minimize
                                   $ mySpacing' mySpacingValue
                                    $ ThreeColMid 1 (3/100) (1/2))

mGrid = named "Grid" (minimize
                      $ Grid)

mSpiral = named "Spiral" (minimize
                          $ mySpacing' mySpacingValue
                          $ spiral (3/4))

mFull = named "Full" (noBorders Full)

mFloat = named "Float" (minimize
                        $ mySpacing' mySpacingValue
                        $ simpleFloat)

mTabs = named "Tabs"(minimize
                     $ mySpacing' mySpacingValue
                     $ tabbed shrinkText myTabConfig)

myLayoutHook = avoidStruts
               $ smartBorders
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT)
               $ mkToggle (single MIRROR)
               $   mTall
               ||| mTall_little
               ||| mDishes
               ||| mThreeColMid
               ||| mGrid
               ||| mSpiral
               ||| Circle
               -- ||| mFull
               ||| mTabs
               ||| mFloat



--Workspaces
-- myWorkspaces :: [String]
myExtraWorkspaces = ["NSP"]
myKbWorkspaces = ["1","2","3","4","5","6","7","8","9","10"]
myWorkspaces = myKbWorkspaces ++ myExtraWorkspaces



--Windows Hook
myManageHook = composeAll . concat $
    [
      -- [isDialog --> sequence_ [doCenterFloat,doF W.swapUp]]
      [isFullscreen --> doFullFloat]
    -- , [isDialog --> doCenterFloat]

    , [isDialog --> doF W.swapMaster]
    , [title =? c --> hasBorder False | c <- myNoBorderW]
    , [className =? c --> doCenterFloat | c <- myCFloats]
    , [className =? c --> doFullFloat | c <- myCFullscreen]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    , [className =? i --> doIgnore | i <- myIgnores]
    , [className =? c --> doShift (myWorkspaces !! 0) | c <- my1Shifts]
    , [className =? c --> doShift (myWorkspaces !! 1) | c <- my2Shifts]
    , [className =? c --> doShift (myWorkspaces !! 2) | c <- my3Shifts]
    , [className =? c --> doShift (myWorkspaces !! 3) | c <- my4Shifts]
    , [className =? c --> doShift (myWorkspaces !! 4) | c <- my5Shifts]
    , [className =? c --> doShift (myWorkspaces !! 5) | c <- my6Shifts]
    , [className =? c --> doShift (myWorkspaces !! 6) | c <- my7Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 7) | c <- my8ShiftsClass]
    , [resource =? c --> doShift (myWorkspaces !! 7) | c <- my8ShiftsTitles]
    , [className =? c --> doShift (myWorkspaces !! 8) | c <- my9Shifts]
    , [className =? c --> doShift (myWorkspaces !! 9) | c <- my10Shifts]
    , [ className =? c --> doShift "NSP" | c <- myNSPShifts]
       ]
    where
--    viewShift    = doF . liftM2 (.) W.greedyView W.shift
    myNoBorderW = ["albert — Albert"]
    myCFullscreen = ["Xfce4-appfinder"]
    myCFloats = ["Arandr", "Arcolinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv", "Xfce4-terminal","Pavucontrol","Catfish","qt5ct"
                ,"Blueman-manager","Spotify","spotify","Hamster","Zenity"]
    myTFloats = ["Downloads", "Save As...","capture","1 Reminder"]
    myRFloats = []
    myCIgnores = ["trayer"]
    myIgnores = ["desktop_window"]
    myNSPShifts=["Skype"]
    my1Shifts = []
    my2Shifts = []
    -- my2Shifts = ["Org.gnome.Nautilus","Thunar"]
    my3Shifts = []
    my4Shifts = []
    my5Shifts = []
    my6Shifts = ["VirtualBox","VirtualBox Manager"]
    -- my7Shifts = ["libreoffice-startcenter","libreoffice-calc","libreoffice-writer","libreoffice-*"]
    my7Shifts = ["Gnome-calendar"]
    -- my8ShiftsClass = ["Emacs"]
    my8ShiftsTitles = []
    -- my9Shifts = ["Gimp","Inkscape","krita","Shotcut","Blender"]
    my9Shifts = []
    my10Shifts = []


centreRect = W.RationalRect 0.25 0.25 0.5 0.5

-- If the window is floating then (f), if tiled then (n)

floatOrNot f n = withFocused $ \windowId -> do
    floats <- gets (W.floating . windowset)
    if windowId `M.member` floats -- if the current window is floating...
       then f
       else n

-- Centre and float a window (retain size)
centreFloat win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()

-- Float a window in the centre
centreFloat' w = windows $ W.float w centreRect

-- Make a window my 'standard size' (half of the screen) keeping the centre of the window fixed
standardSize win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect x y 0.5 0.5)
    return ()


thumbnailFloat_m win = do
  (_, W.RationalRect x y w h) <- floatLocation win
  windows $ W.float win (W.RationalRect (1 - 0.2-0.01) (0.01) 0.2 0.25)
  return ()

thumbnailFloat_M win = do
  (_, W.RationalRect x y w h) <- floatLocation win
  windows $ W.float win (W.RationalRect (1 - 0.3-0.01) (0.01) 0.3 0.35)
  return ()

thumbnailFloat_g win = do
  (_, W.RationalRect x y w h) <- floatLocation win
  windows $ W.float win (W.RationalRect (1 - 0.4-0.01) (0.01) 0.4 0.45)
  return ()

thumbnailFloat_G win = do
  (_, W.RationalRect x y w h) <- floatLocation win
  windows $ W.float win (W.RationalRect (1 - 0.5-0.01) (0.01) 0.5 0.55)
  return ()

-- Float and centre a tiled window, sink a floating window
toggleFloat = floatOrNot (withFocused $ windows . W.sink) (withFocused thumbnailFloat_G)


-- Keymap
myKeymap :: [(String, X ())]
myKeymap = [
              -- MENU shutdown (mod + n )
              ("M-v l", spawn "i3lock && sleep 1")
             ,("M-v e", io (exitWith ExitSuccess))
             ,("M-v s", spawn "i3lock && sleep 1 && systemctl suspend")
             ,("M-v h", spawn "i3lock && sleep 1 && systemctl hibernate")
             ,("M-v r", spawn "systemctl reboot")
             ,("M-v S-s", spawn "systemctl poweroff -i")
             ,("M-v l", spawn "i3lock && sleep 1")

              -- MENU launch app (mod + p)
             ,("M-o  a", spawn "audacity")
             ,("M-o  b", spawn "blender")
             ,("M-o  c", spawn "cura")
             ,("M-o  d", spawn "discord")
             ,("M-o  e", spawn "emacsclient --alternate-editor='' --no-wait --create-frame --frame-parameters='(quote (name . \"scratchemacs-frame\"))' ")
             ,("M-o  S-e", spawn "emacs")
             ,("M-o  f", spawn "firefox")
             ,("M-o  S-f", spawn "gufw")
             ,("M-o  g", spawn "gimp")
             ,("M-o  S-g", spawn "gparted")
             ,("M-o  i", spawn "inkscape")
             ,("M-o  h", spawn "urxvt 'htop task manager' -e htop")
             ,("M-o  k r", spawn "krita")
             ,("M-o  k k", spawn "killall screenkey &>/dev/null || screenkey &")
             ,("M-o  k S-k", spawn "killall screenkey &>/dev/null")
             ,("M-o  k s", spawn "screenkey --show-settings")

             ,("M-o  S-l", spawn "libreoffice")
             ,("M-o  l b", spawn "libreoffice --base")
             ,("M-o  l c", spawn "libreoffice --calc")
             ,("M-o  l d", spawn "libreoffice --draw")
             ,("M-o  l i", spawn "libreoffice --impress")
             ,("M-o  l m", spawn "libreoffice --math")
             ,("M-o  l w", spawn "libreoffice --writer")
             ,("M-o  m", spawn "gnome-system-monitor")
             ,("M-o  n", spawn myFileManager)
             ,("M-o  p", spawn "gnome-power-statistics")
             ,("M-o  s", spawn "~/MyScripts/rofi-screenlayout.sh")
             ,("M-o  t", spawn "thunderbird")
             ,("M-o  S-t", spawn myTerminal)
             ,("M-o  v", spawn "virtualbox")
             ,("M-o  S-v", spawn "vlc")
             ,("M-o  q", spawn "qbittorrent")
             ,("M-o  S-q", spawn "qtcreator")
             ,("M-o  w", spawn "kwrite")
             ,("M-o  S-w", spawn "cheese")
             ,("M-o x", spawn "a=$(zenity --file-selection --directory) && echo $a > /tmp/location")
             -- ,("M-o  x", )
             -- ,("M-o  y", )
             ,("M-o  z", spawn "filezilla")

              -- MENU copy
             ,("M-y c", spawn "colorpicker --short --one-shot --preview | xsel -b")
             ,("M-y S-c", spawn "xprop -id $(xdotool getactivewindow) WM_CLASS| awk '{gsub(/[\",\"]/,\"\",$3);print $3}' | xsel -b")
             ,("M-y d f", spawn "scrot '%Y-%m-%d-%H:%M:%S.png' -d 3 -e 'mv $f ~/Pictures/Screenshots/Full/' && notify-send -t 2000 'Screenshot saved at ~/Pictures/Screenshots/Full/'" )
             ,("M-y d s", spawn "flameshot screen -d 3000 -p ~/Pictures/Screenshots/Screen")
             ,("M-y d w", spawn "scrot '%Y-%m-%d-%H-%M-%S.png' -d 3l -u -e 'mv $f ~/Pictures/Screenshots/Windows/' && notify-send -t 2000 'Screenshot saved at ~/Pictures/Screenshots/Windows/'" )

             ,("M-y s", spawn "~/MyScripts/makeScreenshot.sh screen yes ~/Pictures/Screenshots/Screen")
             ,("M-y f", spawn "~/MyScripts/makeScreenshot.sh full yes ~/Pictures/Screenshots/Full" )
             ,("M-y w", spawn "~/MyScripts/makeScreenshot.sh window yes ~/Pictures/Screenshots/Windows" )
             ,("M-y z", spawn "~/MyScripts/makeScreenshot.sh zone yes ~/Pictures/Screenshots/Zone" )

             ,("M-y S-s", spawn "~/MyScripts/makeScreenshot.sh screen yes $(cat /tmp/location)n")
             ,("M-y S-f", spawn "~/MyScripts/makeScreenshot.sh full yes $(cat /tmp/location)" )
             ,("M-y S-w", spawn "~/MyScripts/makeScreenshot.sh window yes $(cat /tmp/location)" )
             ,("M-y S-z", spawn "~/MyScripts/makeScreenshot.sh zone yes $(cat /tmp/location)" )


              -- Direct Shortcuts
             -- ,("M-a" ,  ) -- USED or multi screen
             -- ,("M-S-a" ,  )
             -- ,("M-C-a" ,  )-- USED for multi screen

             ,("M-b" , windows copyToAll ) -- Pin to all workspaces
             ,("M-S-b" , kill1 ) -- remove window from current, kill if only one
             ,("M-C-b" , killAllOtherCopies ) -- remove window from all but current


             ,("M-c", namedScratchpadAction myScratchPads "xfce4-appfinder")
             -- ,("M-S-c" ,  )
             -- ,("M-C-c" ,  )


             ,("M-d" , spawn "rofi -show run -modi run -theme ~/.config/rofi/config_monokai.rasi" )
             ,("M-S-d", spawn "rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/config_launchpad.rasi")

             ,("M-C-d" ,  spawn "rofi -show window")


             -- ,("M-e", ) -- USED for multi screen
             ,("M-S-e", io (exitWith ExitSuccess))
             -- ,("M-C-e" ,  ) -- USED for multi screen


             ,("M-f", sequence_ [withFocused $ windows . W.sink,
                                 sendMessage $ Toggle NBFULL,
                                 sendMessage ToggleStruts])
             -- ,("M-f", sequence_ [sendMessage (JumpToLayout "Full" ),
                                 -- sendMessage ToggleStruts])

             -- ,("M-S-f" ,  )
             -- ,("M-C-f" ,  )

             -- ,("M-g" ,  )
             -- ,("M-S-g" ,  )
             -- ,("M-C-g" ,  )

             ,("M-h", windowGo L True )
             ,("M-S-h", windowSwap L False )
             ,("M-C-h", sendMessage Shrink)


             -- ,("M-i" ,  )
             ,("M-i" , namedScratchpadAction myScratchPads "translate")
             ,("M-S-i", sinkAll )
             ,("M-C-i" , namedScratchpadAction myScratchPads "zeal")

             ,("M-j", windowGo D True )
             ,("M-S-j", windowSwap D False )
             -- ,("M-C-j" ,  )

             ,("M-k", windowGo U True )
             ,("M-S-k", windowSwap U False )
             -- ,("M-C-i" ,  )

             ,("M-l", windowGo R True )
             ,("M-S-l", windowSwap R False )
             ,("M-C-l", sendMessage Expand)

             ,("M-m", windows W.focusMaster )
             ,("M-S-m" , sendMessage $ Toggle MIRROR)
             ,("M-C-m", dwmpromote )

             ,("M-n" , windows W.focusDown )
             ,("M-S-n", spawn "variety -n")
             -- ,("M-C-n",  )

             -- PREFIX open app,("M-o" ,  )
             -- ,("M-S-o" ,  )
             ,("M-C-o" ,  toggleWS)

             ,("M-p" , windows W.focusUp )
             ,("M-S-p", spawn "variety -p")
             -- ,("M-C-p",  )

             -- ,("M-q" ,  )
             ,("M-S-q", kill)
             -- ,("M-C-q" ,  )

             ,("M-r", rotAllDown )
             ,("M-S-r", rotAllUp )
             ,("M-C-r", spawn "xmonad --recompile && xmonad --restart")
             ,("M3-r", spawn "xmonad --restart")

             ,("M-s" , spawn "albert toggle")
             ,("M-S-s", spawn "~/MyScripts/makeScreenshot.sh zone yes ~/Pictures/Screenshots/Zone")
             -- ,("M-C-s" ,  )

             -- ,("M-t" ,  )
             -- ,("M-S-t" ,  )
             -- ,("M-C-t" ,  )


             ,("M-u", spawn "urxvt")
             -- ,("M-S-u" ,  )
             -- ,("M-C-u" ,  )

             -- ,PREFIX systemctl ("M-v" ,  )
             -- ,("M-S-v" ,  )
             -- ,("M-C-v" ,  )

             -- ,("M-w", )
             -- ,("M-S-w" ,  )
             -- ,("M-C-w" ,  )

             -- ,("M-x" ,  )
             -- ,("M-S-x" ,  )
             -- ,("M-C-x" ,  )

             -- ,PREFIX copy("M-y" ,  )
             -- ,("M-S-y" ,  )
             -- ,("M-C-y" ,  )

             -- ,("M-z",  ) -- USED for multi screen
             -- ,("M-S-z", )
             -- ,("M-C-z" ,  ) -- USED for multi screen

             ,("M-;", sequence_[toggleScreenSpacingEnabled,
                               toggleWindowSpacingEnabled])
             -- ,("M-S-;", )
             -- ,("M-C-;" ,  )


             ,("M-<Return>", spawn myTerminal)
             -- ,("M-S-<Return>" ,  )
             -- ,("M-C-<Return>" ,  )


             ,("M-~", namedScratchpadAction myScratchPads "dropdown-terminal")
             -- ,("M-S-~" ,  )
             -- ,("M-C-~" ,  )


             ,("M-,", toggleFloat)
             -- ,("M-S-," ,  )
             -- ,("M-C-," ,  )

             -- ,("M-µ" , )
             -- ,("M-S-µ" ,  )
             ,("M-C-µ", spawn "variety -f && notify-send -t 1000 \"Wallpaper saved\"")


             ,("M-$" ,  namedScratchpadAction myScratchPads "note-scratchpad")
             -- ,("M-S-$" ,  )
             -- ,("M-C-$", namedScratchpadAction myScratchPads "todo-scratchpad")
             ,("M-C-$", namedScratchpadAction myScratchPads "agenda-emacs")

             ,("M-:" ,  namedScratchpadAction myScratchPads "todo-list")
             -- ,("M-S-:" ,  )
             ,("M-C-:", spawn "emacsclient --create-frame --alternate-editor='' --frame-parameters='(quote (name . \"capture\"))' --no-wait --eval \"(my/org-capture-frame)\"")

             ,("M-=" ,  namedScratchpadAction myScratchPads "floating-terminal")
             -- ,("M-S-=" ,  )
             ,("M-C-=", sendMessage MirrorShrink)

             ,("M--", switchProjectPrompt myPromptTheme)
             ,("M-S--" ,shiftToProjectPrompt myPromptTheme)
             ,("M-C--", sendMessage MirrorExpand)


             ,("M-<Space> a" , sendMessage (JumpToLayout "Tall" ))
             ,("M-<Space> c" , sendMessage (JumpToLayout "ThreeColMid" ))
             ,("M-<Space> d" , sendMessage (JumpToLayout "Dishes" ))
             ,("M-<Space> f" , sendMessage (JumpToLayout "Float" ))
             ,("M-<Space> S-f" , sendMessage (JumpToLayout "Full" ))
             ,("M-<Space> g" , sendMessage (JumpToLayout "Grid" ))
             ,("M-<Space> k" , sendMessage (JumpToLayout "Tall_little" ))
             ,("M-<Space> s" , sendMessage (JumpToLayout "Spiral" ))
             ,("M-<Space> t" , sendMessage (JumpToLayout "Tabs" ))
             ,("M-S-<Space>", sendMessage (JumpToLayout "Tall" ))
             ,("M-C-<Space>" , sendMessage NextLayout)

             ,("M-<Delete>", killAll )
             ,("M-S-<Delete>", sequence_[killAll,removeWorkspace])
             -- ,("M-C-<Delete>" ,  )

             -- ,("M-<Esc>" ,  )
             ,("M-S-<Esc>", spawn "xkill")
             -- ,("M-C-<Esc>" ,  )
             ,("C-S-<Esc>", spawn "gnome-system-monitor")

             ,("M-<Tab>", nextNonEmptyWS )
             ,("M-S-<Tab>", prevNonEmptyWS)
             -- ,("M-C-<Tab>" ,  )

             ,("M3-<", sequence_[withFocused minimizeWindow, windows W.focusUp] )
             ,("M3-S-<", withLastMinimized maximizeWindowAndFocus )



             ,("M-<F1>", namedScratchpadAction myScratchPads "pavucontrol")
             -- ,("M-<F2>", )
             ,("M-<F3>", sequence_[namedScratchpadAction myScratchPads "whatsapp"])
             ,("M-S-<F3>", namedScratchpadAction myScratchPads "messenger")
             ,("M-<F4>", namedScratchpadAction myScratchPads "spotify")
             ,("M-S-<F4>", namedScratchpadAction myScratchPads "torrent")
             ,("M-<F5>", namedScratchpadAction myScratchPads "discord")
             ,("M-S-<F5>", namedScratchpadAction myScratchPads "skype")
             -- ,("M1-<F4>", kill)
             ,("M-<F8>", namedScratchpadAction myScratchPads "pomodoro")
             ,("M-<F11>", sendMessage (IncMasterN 1))
             ,("M-<F12>", sendMessage (IncMasterN (-1)))

              -- Hamster
              ,("M-<Home>", spawn "hamster")
              ,("M-<End>", spawn "hamster stop")
              ,("M-<Insert>", spawn "hamster add")

              -- Move floating window
             ,("M-<L>", withFocused (keysMoveWindow (-80, 0  )))
             ,("M-<U>", withFocused (keysMoveWindow (0  , -80)))
             ,("M-<D>", withFocused (keysMoveWindow (0  , 80 )))
             ,("M-<R>", withFocused (keysMoveWindow (80 , 0  )))
              -- Resize floating window
             ,("M-S-<U>", withFocused (keysResizeWindow    (0  , -40) (0, 0)))
             ,("M-S-<L>", withFocused (keysResizeWindow    (-40,   0) (0, 0)))
             ,("M-S-<D>", withFocused (keysResizeWindow    (0  ,  40) (0, 0)))
             ,("M-S-<R>", withFocused (keysResizeWindow    (40 ,   0) (0, 0)))
             ,("M-<Page_Up>", withFocused (keysResizeWindow    ( 40 ,    40) (0, 0)))
             ,("M-<Page_Down>", withFocused (keysResizeWindow  (-40 ,   -40) (0, 0)))

               -- Sound And Luminosity
             ,("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle")
             ,("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume 0 -5%")
             ,("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume 0 +5%")
             ,("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
             ,("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
             ]

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- SUPER + FUNCTION KEYS

  [
  --  Reset the layouts on the current workspace to default.
   ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

  --Belgian Azerty users use this line
    | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_section, xK_egrave, xK_exclam, xK_ccedilla, xK_agrave]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)
                  , (\i -> W.view i . W.shift i, shiftMask)
                  , (\i -> W.greedyView i, controlMask)]]


  ++
-- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
-- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), f sc)
    | (key, sc) <- zip [xK_a, xK_z, xK_e] [0..]
    , (f, m) <- [(viewScreen def, 0), (sendToScreen def, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    ]

--XMOBAR
myTitleColor = "#00ff" -- color of window title
myTitleLength = 80 -- truncate window title to this length
myCurrentWSColor = "#00ff00" -- color of active workspace
myVisibleWSColor = "#aaaaaa" -- color of inactive workspace
myUrgentWSColor = "#ff0000" -- color of workspace with 'urgent' window
myHiddenNoWindowsWSColor = "white"


main = do
        xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc.hs" -- xmobar monitor 1
        xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc.hs" -- xmobar monitor 2
        xmproc2 <- spawnPipe "xmobar -x 2 $HOME/.config/xmobar/xmobarrc.hs" -- xmobar monitor 3
        xmonad
          $ withNavigation2DConfig def
          $ dynamicProjects projects
          $ ewmh
          $ docks
          $ mydefaults {
        logHook =  dynamicLogWithPP def {
        ppOutput = \x -> System.IO.hPutStrLn xmproc0 x  >> System.IO.hPutStrLn xmproc1 x >> System.IO.hPutStrLn xmproc2 x
        , ppTitle = xmobarColor myTitleColor "" . ( \ str -> "")
        , ppCurrent = xmobarColor myCurrentWSColor "" . wrap """"
        , ppVisible = xmobarColor myVisibleWSColor "" . wrap """"
        , ppHidden = noScratchpad
        -- , ppHidden = wrap """"
        -- , ppHiddenNoWindows = xmobarColor myHiddenNoWindowsWSColor ""
        -- ,ppHiddenNoWindows = noScratchpad
        , ppUrgent = xmobarColor myUrgentWSColor ""
        , ppSep = " | "
        , ppWsSep = " "
 }
>> updatePointer (0.5, 0.5) (0, 0)
}

noScratchpad ws = if ws == "NSP" then "" else ws

{-
  TODO:
          - XMonad.Actions.TagWindows
          - https://rina-kawakita.tistory.com/entry/xmonadxmonadhs
          - https://gist.github.com/mopemope/c13e8a10da2769c357ad78696ac640e9
          - https://github.com/randomthought/xmonad-config/blob/master/xmonad.hs
          - https://gist.github.com/sboehler/5f48017a6b53805485180a9a6d81196b
          - https://github.com/davama/dotfiles/blob/master/xmonad/xmonad.hs
          - https://git.iiens.net/martin2018/xmonad/-/blob/master/xmonad.hs
-}
