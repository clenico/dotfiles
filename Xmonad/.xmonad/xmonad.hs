import XMonad.Actions.WithAll
import XMonad.Actions.RotSlaves
import Control.Monad (liftM2)
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO (Handle, hPutStrLn)
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.DwmPromote
import XMonad.Actions.DynamicProjects
import XMonad.Actions.Minimize
import XMonad.Actions.SpawnOn
import XMonad.Actions.Submap
import XMonad.Config.Azerty
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Hooks.Minimize
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.CenteredMaster(centerMaster)
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Minimize
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
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
myModMask = mod4Mask
myTerminal = "urxvt"
myFileManager = "thunar"

mydefaults = def {
          normalBorderColor   = "#0066B5"
        , focusedBorderColor  = "#00ff00"
        , focusFollowsMouse   = False
        , mouseBindings       = myMouseBindings
        , workspaces          = myWorkspaces
        , keys                = myKeys
        , modMask             = myModMask
        , borderWidth         = 3
        , layoutHook          = myLayoutHook
        , manageHook          = insertPosition Below Newer
                                 <+> manageDocks
                                 <+> myManageHook
                                 <+> manageSpawn
                                 <+> namedScratchpadManageHook myScratchPads
        , startupHook         = myStartupHook
        , handleEventHook     = docksEventHook
                                <+> minimizeEventHook
        }`additionalKeysP` myKeymap



-- scratchpads = [
-- -- run htop in xterm, find it by title, use default floating window placement
--     -- NS "htop" "xterm -e htop" (title =? "htop") defaultFloating ,

-- -- run stardict, find it by class name, place it in the floating window
-- -- 1/6 of screen width from the left, 1/6 of screen height
-- -- from the top, 2/3 of screen width by 2/3 of screen height
--     NS "dropdown-terminal" myTerminal (className =? "URxvt" )
--         (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))

-- -- run gvim, find by role, don't float
--     -- NS "notes" "gvim --role notes ~/notes.txt" (role =? "notes") nonFloating
--                  ] where role = stringProperty "WM_WINDOW_ROLE"

projects :: [Project]
projects =
  [ Project { projectName      = "3"
            , projectDirectory = "~/Downloads"
            , projectStartHook = Just $ do spawn "firefox"
            }
  ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "dropdown-terminal" spawnTerm (resource =? "dropdown-terminal") (manage_dropdown)
                 ,NS "pavucontrol" "pavucontrol" (className =? "Pavucontrol") (manageThirdscreen)
                 ,NS "zeal" "zeal" (resource =? "zeal") (manageFullscreen)
                ]
  where
    spawnTerm  = myTerminal ++ " -name dropdown-terminal"
    findTerm   = resource =? "dropdown-terminal"
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


                 -- l = 0.95 -w
    -- spawnMocp  = myTerminal ++ " -n mocp 'mocp'"
    -- findMocp   = resource =? "mocp"
    -- manageMocp = customFloating $ W.RationalRect l t w h
    --            where
    --              h = 0.9
    --              w = 0.9
    --              t = 0.95 -h
    --              l = 0.95 -w

 -- , ((modm .|. controlMask .|. shiftMask, xK_t), namedScratchpadAction scratchpads "htop")
 -- , ((modm .|. controlMask .|. shiftMask, xK_s), namedScratchpadAction scratchpads "stardict")
 -- , ((modm .|. controlMask .|. shiftMask, xK_n), namedScratchpadAction scratchpads "notes")

-- Autostart
myStartupHook = do
    -- spawn "$HOME/.xmonad/scripts/autostart.sh"
    spawnOnce "exec trayer --align right --widthtype request --padding 0 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x292d3e --height 26 --margin 5 --edge bottom --distance 0"
    spawnOnce "/home/niccle27/MyScripts/autostart.sh > ~/.output/autostart.sh"
    -- spawnOn "3" "firefox"
    -- spawnOn "1" myTerminal
    -- spawnOn "1" myTerminal
    -- spawnOn "3" "firefox"
    setWMName "LG3D"

encodeCChar = map fromIntegral . B.unpack

myTitleColor = "#00ff" -- color of window title
myTitleLength = 80 -- truncate window title to this length
myCurrentWSColor = "#00ff00" -- color of active workspace
myVisibleWSColor = "#aaaaaa" -- color of inactive workspace
myUrgentWSColor = "#ff0000" -- color of workspace with 'urgent' window
myHiddenNoWindowsWSColor = "white"


myLayoutHook =
  -- spacingRaw True (Border 0 0 0 0) True (Border 0 0 0 0) True
                gaps [(U,0), (D,29), (R,0), (L,0)]
               $ minimize
               $ avoidStrutsOn [U,L]
               -- $ avoidStruts
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT)
               $ smartBorders
               $ tiled ||| Grid ||| spiral (6/7) ||| ThreeColMid 1 (3/100) (1/2) ||| noBorders Full ||| simpleFloat
                    where
                    tiled   = Tall nmaster delta ratio
                    nmaster = 1
                    delta   = 3/100
                    ratio   = 1/2



--WORKSPACES
xmobarEscape = concatMap doubleLts
    where doubleLts '<' = "<<"
          doubleLts x = [x]

myWorkspaces :: [String]
-- myWorkspaces = clickable . (map xmobarEscape) $ ["1","2","3","4","5","6","7","8","9","10"]
--     where
--                clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" | (i,ws) <- zip ["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "section", "egrave", "exclam", "ccedilla", "agrave"] l, let n = i ]
myWorkspaces = (map xmobarEscape) $ ["1","2","3","4","5","6","7","8","9","10"]
    -- where
               -- clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" | (i,ws) <- zip ["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "section", "egrave", "exclam", "ccedilla", "agrave"] l, let n = i ]



-- window manipulations
myManageHook = composeAll . concat $
    [
      -- [isFullscreen --> doFullFloat]
      [isDialog --> doCenterFloat]
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
    , [className =? c --> doShift (myWorkspaces !! 7) | c <- my8Shifts]
    , [className =? c --> doShift (myWorkspaces !! 8) | c <- my9Shifts]
    , [className =? c --> doShift (myWorkspaces !! 9) | c <- my10Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 0) <+> viewShift (myWorkspaces !! 0)        | c <- my1Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 1) <+> viewShift (myWorkspaces !! 1)        | c <- my2Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 2) <+> viewShift (myWorkspaces !! 2)        | c <- my3Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 3) <+> viewShift (myWorkspaces !! 3)        | c <- my4Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 4) <+> viewShift (myWorkspaces !! 4)        | c <- my5Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 5) <+> viewShift (myWorkspaces !! 5)        | c <- my6Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 6) <+> viewShift (myWorkspaces !! 6)        | c <- my7Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 7) <+> viewShift (myWorkspaces !! 7)        | c <- my8Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 8) <+> viewShift (myWorkspaces !! 8)        | c <- my9Shifts]
    -- , [className =? c --> doShift (myWorkspaces !! 9) <+> viewShift (myWorkspaces !! 9)        | c <- my10Shifts]
       ]
    where
--    viewShift    = doF . liftM2 (.) W.greedyView W.shift
    myCFullscreen = ["Xfce4-appfinder"]
    myCFloats = ["Arandr", "Arcolinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv", "Xfce4-terminal","Pavucontrol","Catfish"]
    myTFloats = ["Downloads", "Save As..."]
    myRFloats = []
    myCIgnores = ["trayer"]
    myIgnores = ["desktop_window"]
    my1Shifts = []
    my2Shifts = ["Org.gnome.Nautilus","Thunar"]
    my3Shifts = []
    my4Shifts = []
    my5Shifts = []
    my6Shifts = ["Virtualbox"]
    my7Shifts = []
    my8Shifts = ["Emacs"]
    my9Shifts = ["Gimp","Inkscape","krita","Shotcut","Blender"]
    my10Shifts = ["Thunderbird"]
    -- my1ViewShifts = []
    -- my2ViewShifts = []
    -- my3ViewShifts = []
    -- my4ViewShifts = []
    -- my5ViewShifts = []
    -- my6ViewShifts = ["Virtualbox"]
    -- my7ViewShifts = ["libreoffice-startcenter"]
    -- my8ViewShifts = []
    -- my9ViewShifts = ["Gimp","Inkscape","krita","Shotcut","Blender"]
    -- my1View0Shifts = []

-- keys config
myKeymap :: [(String, X ())]
myKeymap = [
             -- MENU shutdown (mod + n )
              ("M-n l", spawn "i3lock && sleep 1")
             ,("M-n e", io (exitWith ExitSuccess))
             ,("M-S-e", io (exitWith ExitSuccess))
             ,("M-n s", spawn "i3lock && sleep 1 && systemctl suspend")
             ,("M-n h", spawn "i3lock && sleep 1 && systemctl hibernate")
             ,("M-n r", spawn "systemctl reboot")
             ,("M-n S-s", spawn "systemctl poweroff -i")
             ,("M-n l", spawn "i3lock && sleep 1")
             -- MENU launch app (mod + p)
             ,("M-p c", spawn "colorpicker --short --one-shot --preview | xsel -b")
             ,("M-p e", spawn "emacs")
             ,("M-p f", spawn "firefox")
             ,("M-p m", spawn "gnome-system-monitor")
             ,("M-p n", spawn myFileManager)
             ,("M-p w", spawn "kwrite")
             ,("M-<Return>", spawn myTerminal)
             -- Xmonad
             ,("M-r", spawn "xmonad --restart")
             ,("M-S-r", spawn "xmonad --recompile")
             ,("C-M-r", spawn "xmonad --recompile && xmonad --restart")
             -- launch app
             ,("M-c", spawn "xfce4-appfinder")
             ,("M-d", spawn "rofi -show run")
             ,("M-e", spawn myFileManager)
             ,("M-u", spawn "urxvt")
             ,("M-w", spawn "rofi -show window")
             -- ,("M-<F1>", spawn "pavucontrol")
             ,("C-S-<Esc>", spawn "gnome-system-monitor")

             -- Workspace shortcut
             ,("M1-<F4>", kill)
             ,("M-S-q", kill)
             ,("M-f", sendMessage $ Toggle NBFULL)
             -- ,("M-<Esc>", spawn "xkill")
             ,("M-<Space>", sendMessage NextLayout )
             ,("C-M-<Space>", sendMessage FirstLayout )
             ,("M-<Tab>", moveTo Next NonEmptyWS )
             ,("M-S-<Tab>", moveTo Prev NonEmptyWS )
             ,("M-j", windows W.focusDown )
             ,("M-k", windows W.focusUp )
             ,("M-S-j", windows W.swapDown  )
             ,("M-S-k", windows W.swapUp )
             ,("M-m", windows W.focusMaster )
             ,("M-C-m", dwmpromote )
             ,("M-h", sendMessage Shrink)
             ,("M-l", sendMessage Expand)
             ,("M-i", withFocused $ windows . W.sink)
             ,("M-<R>", sendMessage (IncMasterN 1))
             ,("M-<L>", sendMessage (IncMasterN (-1)))
             ,("M-<F3>", switchProjectPrompt def)
             ,("M-<U>", withLastMinimized maximizeWindowAndFocus )
             ,("M-<D>", withFocused minimizeWindow )
             ,("C-M-j", rotAllDown )
             ,("C-M-k", rotAllUp )
             ,("M-S-i", sinkAll )
             ,("M3-S-q", killAll )
             -- ,("M-a", sendMessage ToggleStruts )



             -- sound and luminosity
             ,("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle")
             ,("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume 0 -5%")
             ,("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume 0 +5%")
             ,("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
             ,("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")

             -- ,("M-S-<Space>", setLayout $ XMonad.layoutHook conf ) -- conf not available in ezconfig

             -- Scratchpad
             ,("M-~", namedScratchpadAction myScratchPads "dropdown-terminal")
             ,("M-<F1>", namedScratchpadAction myScratchPads "pavucontrol")
             ,("M1-<Tab>", namedScratchpadAction myScratchPads "zeal")

             -- Design
             ,("M-S-p", spawn "variety -p")
             ,("M-S-n", spawn "variety -n")
             ,("M-p w", spawn "variety -f")
             ]

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- SUPER + FUNCTION KEYS

  [
   -- ((modMask, xK_c), spawn $ "xfce4-appfinder" )
  -- , ((modMask, xK_v), spawn $ "pavucontrol" )
  -- , ((modMask, xK_f), sendMessage $ Toggle NBFULL)
  -- , ((modMask, xK_h), spawn $ "urxvt 'htop task manager' -e htop" )
  -- , ((modMask, xK_y), spawn $ "polybar-msg cmd toggle" )

  -- , ((modMask, xK_Return), spawn $ myTerminal )
   ((controlMask .|. mod1Mask , xK_t ), spawn $ myTerminal)

  , ((modMask, xK_a), sendMessage ToggleStruts)
  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

  --Belgian Azerty users use this line
    | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_section, xK_egrave, xK_exclam, xK_ccedilla, xK_agrave]

      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
      , (\i -> W.greedyView i . W.shift i, shiftMask)]]

  ++
  -- ctrl-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- ctrl-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    ]

--XMOBAR
main = do
        xmproc0 <- spawnPipe "xmobar -x 0 /home/niccle27/.config/xmobar/xmobarrc0" -- xmobar monitor 1
        xmproc1 <- spawnPipe "xmobar -x 1 /home/niccle27/.config/xmobar/xmobarrc0" -- xmobar monitor 2
        -- xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.xmobarrc" -- xmobar monitor 2
        xmonad
          $ dynamicProjects projects
          $ ewmh
          -- $ XLF.fullscreenSupport
          $ mydefaults {
        logHook =  dynamicLogWithPP . namedScratchpadFilterOutWorkspacePP $ def {
        ppOutput = \x -> System.IO.hPutStrLn xmproc0 x  >> System.IO.hPutStrLn xmproc1 x
        , ppTitle = xmobarColor myTitleColor "" . ( \ str -> "")
        , ppCurrent = xmobarColor myCurrentWSColor "" . wrap """"
        , ppVisible = xmobarColor myVisibleWSColor "" . wrap """"
        , ppHidden = wrap """"
        , ppHiddenNoWindows = xmobarColor myHiddenNoWindowsWSColor ""
        , ppUrgent = xmobarColor myUrgentWSColor ""
        , ppSep = "  "
        , ppWsSep = "  "
        , ppLayout = (\ x -> case x of
           "Spacing Tall"                 -> "<fn=2>Tall</fn>"
           "Spacing Grid"                 -> "<fn=2>Grid</fn>"
           "Spacing Spiral"               -> "<fn=2>spiral</fn>"
           "Spacing ThreeCol"             -> "<fn=2>ThreeColMid</fn>"
           "Spacing Full"                 -> "<fn=2>Full</fn>"
           _                                         -> x )
 }
}
