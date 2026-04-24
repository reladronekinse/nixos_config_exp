# ============================================================
# Home Manager Configuration
# ============================================================
{ config, pkgs, lib, ... }:

{
  home = {
    username    = "reladronekinse";
    homeDirectory = "/home/reladronekinse";
    stateVersion = "24.11";

    packages = with pkgs; [
      networkmanagerapplet
      bibata-cursors
    ];

    pointerCursor = {
      name    = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size    = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  programs.home-manager.enable = true;

  # ── XDG config files ──────────────────────────────────────
  xdg.configFile = {
    "fastfetch" = {
      source    = ./fastfetch;
      recursive = true;
    };
  };

  # ============================================================
  # Niri
  # ============================================================
  xdg.configFile."niri/config.kdl".text = ''
    // Input device configuration.
    input {
        keyboard {
            xkb {
                layout "us,ru"
                options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"
            }
            numlock
        }

        touchpad {
            tap
            natural-scroll
        }

        warp-mouse-to-focus
        focus-follows-mouse max-scroll-amount="0%"
    }

    // Spawn at startup
    spawn-at-startup "nm-applet"
    spawn-at-startup "waybar"
    spawn-at-startup "awww-daemon"
    spawn-at-startup "dunst"
    spawn-at-startup "xwayland-satellite"

    // Environment variables
    environment {
        XCURSOR_THEME "Bibata-Modern-Classic"
        XCURSOR_SIZE "24"
        DISPLAY ":0"
        // Для Qt-приложений (например, Telegram, VLC)
        QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
        // Для GTK-приложений (иногда помогает)
        GTK_CSD "0"
    }
    prefer-no-csd
    // Outputs
    output "DP-1" {
        mode "2560x1440@164.998"
        position x=0 y=0
        variable-refresh-rate
    }

    output "HDMI-A-1" {
        mode "1280x1024@75.025"
        position x=2560 y=0
    }

    // Layout
    layout {
        gaps 16
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 4
            active-color "#7fc8ff"
            inactive-color "#505050"
        }

        border {
            off
            width 4
            active-color "#cba6f7"
            inactive-color "#45475a"
            urgent-color "#9b0000"
        }

    }

    // Screenshot path
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // Gestures
    gestures {
        hot-corners {
            off
        }
    }

    // Animations
    animations { }

    // Window rules
    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }
    window-rule {
        match app-id=r#"^org\.wezfurlong\.wezterm$"#
        default-column-width {}
    }

    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        open-floating true
    }

    // Keybindings
    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }
        Mod+Q { spawn "kitty"; }
        Mod+R { spawn "wofi" "--show" "drun"; }
        Super+Alt+L { spawn "swaylock"; }

        Mod+C repeat=false { close-window; }
        Mod+O repeat=false { toggle-overview; }
        Mod+V { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }
        Mod+W { toggle-column-tabbed-display; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Ctrl+F { expand-column-to-available-width; }
        Mod+Ctrl+C { center-visible-columns; }

        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }

        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        Mod+WheelScrollDown      { focus-column-right; }
        Mod+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+WheelScrollDown { move-column-right; }
        Mod+Ctrl+WheelScrollUp   { move-column-left; }
        Mod+Shift+WheelScrollDown { focus-workspace-down; }
        Mod+Shift+WheelScrollUp   { focus-workspace-up; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        Mod+Shift+E { quit; }
        Ctrl+Alt+Delete { quit; }
        Mod+Shift+P { power-off-monitors; }
        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
        XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
        XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
        XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
        XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }
    }
  '';

  # ============================================================
  # Kitty
  # ============================================================
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    settings = {
      linux_display_server   = "wayland";
      wayland_titlebar_color = "background";
      bold_font              = "auto";
      italic_font            = "auto";
      bold_italic_font       = "auto";
      background_opacity     = "0.5";
      shell                  = "fish";

      # Window
      initial_window_width    = "95c";
      initial_window_height   = "35c";
      window_padding_width    = 20;
      confirm_os_window_close = 0;

      # Colors — Neovim Tokyo Night
      background = "#14151e";
      foreground = "#98b0d3";

      color0  = "#151720"; color8  = "#4f5572";
      color1  = "#dd6777"; color9  = "#e26c7c";
      color2  = "#90ceaa"; color10 = "#95d3af";
      color3  = "#ecd3a0"; color11 = "#f1d8a5";
      color4  = "#86aaec"; color12 = "#8baff1";
      color5  = "#c296eb"; color13 = "#c79bf0";
      color6  = "#93cee9"; color14 = "#98d3ee";
      color7  = "#cbced3"; color15 = "#d0d3d8";

      cursor            = "#cbced3";
      cursor_text_color = "#a5b6cf";

      selection_foreground = "#a5b6cf";
      selection_background = "#1c1e27";

      url_color = "#5de4c7";

      active_border_color   = "#3d59a1";
      inactive_border_color = "#101014";
      bell_border_color     = "#fffac2";

      # Tab bar
      tab_bar_style           = "fade";
      tab_fade                = 1;
      active_tab_foreground   = "#3d59a1";
      active_tab_background   = "#16161e";
      active_tab_font_style   = "bold";
      inactive_tab_foreground = "#787c99";
      inactive_tab_background = "#16161e";
      inactive_tab_font_style = "bold";
      tab_bar_background      = "#101014";

      macos_titlebar_color = "#16161e";
    };

    keybindings = {
      "kitty_mod+t" = "new_tab_with_cwd";
    };
  };

  # ============================================================
  # Fish
  # ============================================================
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting
      fastfetch
    '';

    plugins = [
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
    ];
  };

  # ============================================================
  # Waybar
  # ============================================================
  programs.waybar = {
    enable  = true;
    # Собираем waybar с поддержкой модуля niri/workspaces
    package = pkgs.waybar.override { niriSupport = true; };

    settings = [{
      layer        = "top";
      position     = "top";
      height       = 30;
      margin-top   = 8;
      margin-left  = 80;  # Убрали жесткие отступы
      margin-right = 80;  # Убрали жесткие отступы
      modules-left   = [ "custom/launcher"];
      modules-center = [ "clock" ];
      modules-right  = [
        "pulseaudio" "network" "cpu" "memory"
        "backlight" "battery" "tray" "custom/power"
      ];

      "niri/workspaces" = {
        disable-scroll = true;
        all-outputs    = true;
        format         = "{name}";
        on-click       = "activate";
      };

      "custom/launcher" = {
        format   = " ";
        tooltip  = false;
        on-click = "hyprlauncher";
      };

      "custom/power" = {
        format          = "⏻ ";
        tooltip         = false;
        on-click        = "shutdown now";
        on-click-right  = "reboot";
      };

      "tray" = {
        spacing   = 10;
        icon-size = 18;
      };

      "clock" = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format         = " {:%H:%M}";
        format-alt     = " {:%Y-%m-%d}";
      };

      "cpu" = {
        format  = " {usage}% ";
        tooltip = false;
      };

      "memory" = {
        format = " {}% ";
      };

      "backlight" = {
        format       = "{percent}% {icon}";
        format-icons = [ "󰃞" "󰃟" "󰃠" ];
      };

      "battery" = {
        states = {
          warning  = 30;
          critical = 15;
        };
        format          = "{capacity}% {icon}";
        format-full     = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged  = "{capacity}% ";
        format-alt      = "{time} {icon}";
        format-icons    = [ "" "" "" "" "" ];
      };

      "network" = {
        format-wifi       = " {essid} ({signalStrength}%) ";
        format-ethernet   = "󰈀 {ifname} ";
        tooltip-format    = "{ifname} via {gwaddr} ";
        format-linked     = "󰈀 {ifname} (No IP) ";
        format-disconnected = "󰤮 Disconnected ";
        format-alt        = "{ifname}: {ipaddr}/{cidr}";
      };

      "pulseaudio" = {
        format                 = "{volume}% {icon} {format_source} ";
        format-bluetooth       = "{volume}% {icon}  {format_source}";
        format-bluetooth-muted = "󰂲 {format_source}";
        format-muted           = "󰝟 {format_source}";
        format-source          = " {volume}%  ";
        format-source-muted    = " ";
        format-icons = {
          headphone  = "";
          hands-free = "";
          headset    = "";
          phone      = "";
          portable   = "";
          car        = "";
          default    = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
    }];
    style = ''
      /* ============================================================
       *  Waybar — Catppuccin Mocha
       * ============================================================ */

      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 14px;
          min-height: 0;
      }

      @define-color base      #161320;
      @define-color text      #cdd6f4;
      @define-color rosewater #F2CDCD;
      @define-color flamingo  #F28FAD;
      @define-color mauve     #DDB6F2;
      @define-color red       #F38BA8;
      @define-color peach     #F8BD96;
      @define-color yellow    #FAE3B0;
      @define-color green     #ABE9B3;
      @define-color teal      #B5E8E0;
      @define-color sky       #89DCEB;
      @define-color blue      #96CDFB;
      @define-color mauve2    #C3BAC6;

      window#waybar {
          background: @base;
          color: @text;
          border-radius: 12px;
      }

      window#waybar.hidden { opacity: 0.2; }

      .modules-left,
      .modules-center,
      .modules-right {
          background: transparent;
          margin: 0;
          padding: 0;
      }

      .modules-left  { padding-left:  4px; }
      .modules-right { padding-right: 4px; }

      .module {
          margin: 0;
          padding: 0 10px;
          border-radius: 0;
          color: @text;
      }

      #clock, #cpu, #memory, #backlight,
      #pulseaudio, #network, #battery {
          border-right: 1px solid rgba(255, 255, 255, 0.08);
      }

      #workspaces {
          background: transparent;
          padding: 0 4px;
          border-right: 1px solid rgba(255, 255, 255, 0.08);
      }

      #workspaces button {
          transition: none;
          color: @teal;
          background: transparent;
          font-size: 13px;
          border-radius: 0;
          border-top: 2px solid transparent;
          border-bottom: 2px solid transparent;
          padding: 0 6px;
      }

      #workspaces button.visible  { color: @flamingo; }

      #workspaces button.active {
          color: @green;
          border-top-color: @green;
          border-bottom-color: @green;
      }

      #workspaces button:hover,
      #workspaces button.active:hover {
          box-shadow: none;
          text-shadow: none;
          color: @flamingo;
          background: transparent;
      }

      #network    { color: @blue;   padding: 0 12px 0 10px; }
      #pulseaudio { color: @yellow; }
      #pulseaudio.muted { color: @mauve2; }
      #battery    { color: @teal;   }
      #battery.charging,
      #battery.plugged  { color: @teal; }
      #battery.warning:not(.charging)  { color: @peach; }
      #battery.critical:not(.charging) {
          color: @red;
          animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink { to { color: @teal; } }

      #backlight       { color: @peach;  }
      #clock           { color: @green;  }
      #memory          { color: @mauve;  }
      #cpu             { color: @blue;   }

      #tray {
          color: @teal;
          padding: 0 10px;
          border-left: 1px solid rgba(255, 255, 255, 0.08);
      }

      #custom-launcher {
          font-size: 20px;
          color: @sky;
          padding: 0 10px;
          border-right: 1px solid rgba(255, 255, 255, 0.08);
      }

      #custom-power {
          font-size: 16px;
          color: @flamingo;
          padding: 0 8px;
      }

      #window {
          color: transparent;
          background: transparent;
      }
    '';
  };

  # ============================================================
  # Wofi
  # ============================================================
  programs.wofi = {
    enable = true;

    settings = {
      width          = 400;
      height         = 500;
      location       = "center";
      show           = "drun";
      prompt         = "Search...";
      filter_rate    = 100;
      allow_markup   = true;
      no_actions     = true;
      halign         = "fill";
      orientation    = "vertical";
      content_halign = "fill";
      insensitive    = true;
      allow_images   = true;
      image_size     = 16;
      gtk_dark       = true;
    };

    style = ''
      window {
          background-color: #1a1525;
          border: 1px solid #6c4fa3;
          font-family: sans-serif;
          font-size: 14px;
      }

      #input {
          background-color: #241b35;
          color: #d4b8f0;
          border: 1px solid #6c4fa3;
          border-radius: 8px;
          padding: 8px 12px;
          margin: 8px;
          outline: none;
          caret-color: #a07ad4;
      }

      #input::placeholder { color: #6b5490; }

      #outer-box { padding: 4px; }
      #scroll    { margin: 0 4px 4px 4px; }
      #inner-box { background: transparent; }

      #entry {
          padding: 6px 10px;
          border-radius: 8px;
          color: #c9a8f0;
      }

      #entry:selected {
          background-color: #3d2460;
          color: #e8d4ff;
      }

      #entry image { margin-right: 8px; }
      #text { color: inherit; }
    '';
  };
}
