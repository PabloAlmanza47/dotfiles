"""Launch Harlequin with a terminal-background-friendly Tokyo Night theme.

The profile deliberately names Textual's built-in ``tokyo-night`` theme so
Harlequin can validate the config before the app exists.  Once Harlequin has
constructed its normal app, the subclass below registers and applies the
terminal-home variant.  This keeps Harlequin's regular CLI, config, adapter,
locale, and keymap handling intact without changing its installed files.
"""

from textual.theme import Theme
from pathlib import Path


THEME_NAME = "terminal-home-tokyo"


TERMINAL_HOME_TOKYO = Theme(
    name=THEME_NAME,
    ansi=True,
    primary="#BB9AF7",       # Tokyo Night purple
    secondary="#7AA2F7",     # Tokyo Night blue
    warning="#E0AF68",
    error="#F7768E",
    success="#9ECE6A",
    accent="#FF9E64",
    foreground="#A9B1D6",
    # Native ANSI default is emitted for these fields, allowing the terminal
    # to supply its own background instead of receiving a truecolor fill.
    background="ansi_default",
    surface="#24283B",
    panel="#414868",
    boost="#2F3560",
    dark=True,
    variables={
        "ansi-background": "ansi_default",
        "ansi-foreground": "ansi_default",
        "button-color-foreground": "#1A1B26",
        "input-selection-background": "#7AA2F760",
        "screen-selection-background": "#7AA2F760",
    },
)


import harlequin.app as harlequin_app  # noqa: E402
from harlequin.app import Harlequin  # noqa: E402
from harlequin.cli import harlequin as harlequin_cli  # noqa: E402


class TerminalHomeHarlequin(Harlequin):
    """Apply the custom theme after Harlequin's normal app initialization."""

    # Textual resolves relative CSS_PATH entries from the module defining the
    # concrete app class.  Keep Harlequin's packaged stylesheets when this
    # wrapper supplies that concrete class from the dotfiles checkout.
    CSS_PATH = [
        Path(harlequin_app.__file__).with_name("global.tcss"),
        Path(harlequin_app.__file__).with_name("app.tcss"),
    ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.register_theme(TERMINAL_HOME_TOKYO)
        self.theme = THEME_NAME


# The CLI imports the app class as a module global and instantiates that
# symbol after it has parsed and validated the profile.  Replacing only that
# class keeps the rest of the normal Harlequin startup path unchanged.
import harlequin.cli as harlequin_cli_module  # noqa: E402

harlequin_cli_module.Harlequin = TerminalHomeHarlequin


if __name__ == "__main__":
    raise SystemExit(harlequin_cli())
