--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import XMonad.Util.SpawnOnce
import Data.Monoid
import System.Exit
import XMonad.Hooks.EwmhDesktops

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Actions.CycleWS

import XMonad.Layout.NoBorders

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"
userBinPath     = "/home/joakim/.local/bin/"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9", "0"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#232529" 
myFocusedBorderColor = "#1f8fff"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
--
moveCurrentWindowAndFocusIt :: WorkspaceId -> X ()
moveCurrentWindowAndFocusIt wid = windows $ W.view wid . W.shift wid

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_f     ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- launch terminal
    , ((modm , xK_Return   ), spawn myTerminal)

    -- close focused window
    , ((modm , xK_Escape     ), kill)

    -- open custom notification dashboard
    , ((modm , xK_f     ), spawn "~/scripts/notification_dash.sh | python ~/scripts/jwqtnotify.py")

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    -- , ((modm,               xK_u), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm .|. shiftMask, xK_u     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_Escape     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_b     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))

    -- USERCONFIG
    --

    , ((modm, xK_q), windows $ W.greedyView "1")
    -- -- , ((shiftMask .|. modm, xK_q), windows $ W.shift "1")
    -- , ((shiftMask .|. modm, xK_q), windows $ )
    -- -- , ((shiftMask .|. modm, xK_q), windows $ W.shift "1")
    -- , ((modm .|. shiftMask, xK_q), windows $ W.shift "1")
    , ((modm .|. shiftMask, xK_q), windows $ W.greedyView "1" . W.shift "1")
    , ((modm, xK_w), windows $ W.greedyView "2")
    , ((modm .|. shiftMask, xK_w), windows $ W.greedyView "2" . W.shift "2")
    , ((modm, xK_e), windows $ W.greedyView "3")
    , ((modm .|. shiftMask, xK_e), windows $ W.greedyView "3" . W.shift "3")
    , ((modm, xK_r), windows $ W.greedyView "4")
    , ((modm .|. shiftMask, xK_r), windows $ W.greedyView "4" . W.shift "4")
    , ((modm, xK_t), windows $ W.greedyView "5")
    , ((modm .|. shiftMask, xK_t), windows $ W.greedyView "5" . W.shift "5")
    , ((modm, xK_y), windows $ W.greedyView "6")
    , ((modm .|. shiftMask, xK_y), windows $ W.greedyView "6" . W.shift "6")
    , ((modm, xK_u), windows $ W.greedyView "7")
    , ((modm .|. shiftMask, xK_u), windows $ W.greedyView "7" . W.shift "7")
    , ((modm, xK_i), windows $ W.greedyView "8")
    , ((modm .|. shiftMask, xK_i), windows $ W.greedyView "8" . W.shift "8")
    , ((modm, xK_o), windows $ W.greedyView "9")
    , ((modm .|. shiftMask, xK_o), windows $ W.greedyView "9" . W.shift "9")
    , ((modm, xK_p), windows $ W.greedyView "0")
    , ((modm .|. shiftMask, xK_p), windows $ W.greedyView "0" . W.shift "0")

    -- a basic CycleWS setup
    -- , ((modm,               xK_x),  nextWS)
    -- , ((modm,               xK_z),    prevWS)
    -- , ((modm .|. shiftMask, xK_x),  shiftToNext)
    -- , ((modm .|. shiftMask, xK_z),    shiftToPrev)
    , ((modm,               xK_Right), nextScreen)
    , ((modm,               xK_Left),  prevScreen)
    , ((modm .|. shiftMask, xK_Right), shiftNextScreen)
    , ((modm .|. shiftMask, xK_Left),  shiftPrevScreen)
    -- , ((modm .|. shiftMask, xK_x), shiftToNext >> nextWS)
    -- , ((modm .|. shiftMask, xK_z),   shiftToPrev >> prevWS)

    -- Media Keys TODO: implement notify-send
    -- media keys for home cherry keyboard
    , ((0                     , 0x1008ff11), spawn "amixer -q sset Master 2%-")
    , ((0                     , 0x1008ff13), spawn "amixer -q sset Master 2%+")
    , ((0                     , 0x1008ff12), spawn "amixer set Master toggle")
    -- alternative media keys for any keyboard 
    -- OLD amixer conifgs
    --, ((mod1Mask .|. controlMask, xK_period), spawn "amixer -q -D pulse sset Master 2%-")
    --, ((mod1Mask .|. controlMask, xK_comma), spawn "amixer  --q -D pulse sset Master 2%+")
    --, ((mod1Mask .|. controlMask, xK_m), spawn "amixer  -q -D pulse sset Master toggle")

    -- pulsemixer configs, requires pulsemixer to be installed via pip
    , ((mod1Mask .|. controlMask, xK_period), spawn (userBinPath ++ "pulsemixer --change-volume -2"))
    , ((mod1Mask .|. controlMask, xK_comma), spawn (userBinPath ++ "pulsemixer --change-volume +2"))
    , ((mod1Mask .|. controlMask, xK_m), spawn (userBinPath ++ "pulsemixer --toggle-mute"))

    -- pavucontrol sound cards and volume management
    , ((mod1Mask .|. controlMask, xK_p), spawn "pavucontrol --tab 3")
    -- Screenshot
    , ((controlMask .|. shiftMask , xK_Print ), spawn $ "gnome-screenshot -i")
    -- Screensaver
    , ((mod1Mask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock")

    -- Flamemeshot capture to Pictures folder
    , ((modm              , xK_s     ), spawn "flameshot gui")

    ]
    ++

    -- CUSTOM ATTEMPT AT MOVE WINDOW AND FOCUS - NOT WORKING
    -- [ ( (modm .|. shiftMask, key), screenWorkspace sc >>= flip whenJust moveCurrentWindowAndFocusIt  )
    --    | (key, sc) <- zip [xK_q, xK_w, xK_e, xK_r, xK_t, xK_y, xK_u, xK_i, xK_o, xK_p] [0..] 
    -- ]

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm .|. controlMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_x, xK_c] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    -- | (key, sc) <- zip [xK_q, xK_w, xK_e, xK_r, xK_t, xK_y, xK_u, xK_i, xK_o, xK_p] [0..]
    -- , let shiftAndView i = W.view i . W.shift i
    -- , (f, m) <- [(W.view, 0), (shiftAndView, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = smartBorders tiled  ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    , className =? "hl_linux"       --> doFloat
    , className =? "jwqtnotify"     --> doFloat
    , className =? "Yad"            --> doFloat
    --, className =? "Mindustry"      --> doFloat
    --, className =? "csgo_linux64"   --> doFloat
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawnOnce "nitrogen --restore &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = ewmhFullscreen $ def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
