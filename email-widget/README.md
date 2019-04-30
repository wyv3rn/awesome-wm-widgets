# Email widget

This widget consists of an icon with counter which shows number of unread emails: ![email icon](./em-wid-1.png)
and a popup message which appears when mouse hovers over an icon: ![email popup](./em-wid-2.png)

Note that the widget uses the Arc icon theme, so it should be [installed](https://github.com/horst3180/arc-icon-theme#installation) first under **/usr/share/icons/Arc/** folder.

## Installation

To install the widget, put the `email-widget` folder somewhere under `~/.config/awesome`. Then

 - if you want to use the existing python scripts for counting/displaying unread mails: add your credentials (note that password should be encrypted using pgp for example);
 - else prepare whatever scripts/programs you like for counting/displaying unread mails
 - add widget to awesome in your rc.lua (example config):

```lua
require("email-widget") -- important: specify the email-widget folder path relative to your rc.lua!

-- create the widget(s) with arguments
mail = email_widget {
    count_cmd = [[python ~/.config/awesome/email-widget/count_unread_emails.py]],
    interval = 30,
    read_cmd = [[python ~/.config/awesome/email-widget/read_emails.py]],
    display_width = 800
}

...
-- add the widget(s) to your wibar
s.mytasklist, -- Middle widget
    { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        ...
        mail.icon,
        mail.count,
        ...
    },
```

## How it works

This widget uses the output of two commands, specified by `count_cmd` and `read_cmd` (both have to be in your `$PATH`).
The first is called periodically (default 20s) and should print the number of unread emails.
The second is called when mouse hovers over the mail icon and displays content of those emails.

If you want to use the shipped python scripts, you'll need to provide your credentials and IMAP server for both.
For testing they can simply be called from console:

``` bash
python ~/.config/awesome/email/count_unread_emails.py
python ~/.config/awesome/email/read_emails.py
```

## Configuration

Currently, the following arguments are supported when creating the widget:

  - `count_cmd` (mandatory): Command which should print the number of unread mails to stdout
  - `read_cmd` (mandatory): Command which should print unread mails (or a summary or whatever info you want to be displayed) to stdout
  - `interval`: Interval (in seconds) for calling `count_cmd` and thus updating the count (default = `20`)
  - `font`: Font to use for the count (defaults to your default for awesome text widgets)
  - `display_width`: Width of the popup for displaying your unread mails (default = `400`)
