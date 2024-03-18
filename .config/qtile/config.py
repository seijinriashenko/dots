######################################
###---------- Imports -------------###
######################################
from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

######################################
###--------- Variables ------------###
######################################
mod = "mod4"
terminal = guess_terminal()
browser = 'sh -c "GTK_THEME=Adwaita:dark firefox"'
file_manager = "nemo"


#####################################
###---------- Keymaps ------------###
#####################################
keys = [
    ##--- Qtile-related ---##
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    ##--- Windows ---##
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in a current stack.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Kill currently focused window.
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    ##--- Layouts ---##
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    # Fullscreen
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    # Floating
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    ##--- User programs ---##
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch a browser"),
    Key([mod], "e", lazy.spawn(file_manager), desc="Launch a file manager"),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui"), desc="Area screenshot"),
    Key([mod, "shift"], "p", lazy.spawn("flameshot screen"), desc="Desktop screenshot"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


#####################################
###----- Groups (workspaces) -----###
#####################################
# groups = [Group(f"{i+1}", label="◉") for i in range(5)]

groups = [
    Group(
        "1",
        label="一",
        matches=[
            Match(wm_class="Emacs"),
        ],
    ),
    Group(
        "2",
        label="二",
        matches=[],
    ),
    Group(
        "3",
        label="三",
        matches=[
            Match(wm_class="firefox"),
            Match(wm_class="chromium"),
        ],
    ),
    Group(
        "4",
        label="四",
        matches=[],
    ),
    Group(
        "5",
        label="五",
        matches=[],
    ),
    # Group(
    #     "6",
    #     label="六",
    #     matches=[],
    # ),
    # Group(
    #     "7",
    #     label="七",
    #     matches=[],
    # ),
]

for i in groups:
    keys.extend(
        [
            # mod1 + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


#####################################
###---------- Layouts ------------###
#####################################
layouts = [
    layout.Columns(
        border_focus="#bdae93",
        border_normal="#0e1018",
        border_width=2,
        border_on_single=True,
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="Media viewer"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)


#####################################
###---------- Widgets ------------###
#####################################
widget_defaults = dict(
    font="HelveticaNeueCyr Bold",
    fontsize=14,
    padding=3,
    foreground="ebdbb2",
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(
                    this_current_screen_border="c64b3d",
                    this_screen_border="c64b3d",
                    block_highlight_text_color="ebdbb2",
                    active="99554e",
                    inactive="665c54",
                    highlight_method="line",
                    # highlight_color=['07080c','0e1018', '191d2b', '202538', '272e44'],
                    highlight_color=["07080c"],
                    urgent_alert_method="text",
                    urgent_border="c64b3d",
                    urgent_text="c64b3d",
                    hide_unused=False,
                    disable_drag=True,
                    use_mouse_wheel=False,
                ),
                widget.Prompt(),
                widget.Spacer(),
                # widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.CPUGraph(
                    border_width=0,
                    line_width=1,
                    fill_color="dfaf87",
                    graph_color="458588",
                    samples=50,
                    margin_x=1,
                    width=50,
                ),
                widget.CPU(format="{load_percent}%"),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.Systray(),
            ],
            24,
            background="#07080c",
            # border_width = [2, 0, 0, 0],  # Draw top and bottom borders
            # border_color = ["0e1018", "000000", "000000", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]


###################################
###---------- Mouse ------------###
###################################
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]


###################################
###---------- Rules ------------###
###################################
dgroups_app_rules = []  # type: list


#####################################
###---------- General ------------###
#####################################
dgroups_key_binder = None
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

auto_minimize = True  # should we respect auto-minimize feature of apps?
wl_input_rules = None  # used to configure input devices in Wayland
wmname = "LG3D"  # just leave it as it is
