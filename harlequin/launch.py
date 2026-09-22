"""Launch Harlequin with a terminal-background-friendly Tokyo Night theme.

Harlequin removes Textual's ANSI themes from its public theme list, but
Textual 8.2.8 supports native ANSI colors.  Registering this small hybrid
theme before importing Harlequin's CLI keeps the change outside uv's managed
site-packages while retaining Harlequin's normal CLI, config, adapters, and
keymap handling.
"""

from textual.theme import BUILTIN_THEMES, Theme


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
        "button-color-foreground": "#1A1B26",
        "input-selection-background": "#7AA2F760",
        "screen-selection-background": "#7AA2F760",
    },
)


# App.__init__ registers Textual's built-in themes, while Harlequin's CLI
# imports VALID_THEMES to advertise/accept names.  Add the same theme to both
# registries before the CLI module is imported.
BUILTIN_THEMES[THEME_NAME] = TERMINAL_HOME_TOKYO

from harlequin import colors  # noqa: E402

colors.VALID_THEMES[THEME_NAME] = TERMINAL_HOME_TOKYO

from harlequin.cli import harlequin  # noqa: E402


if __name__ == "__main__":
    raise SystemExit(harlequin())
