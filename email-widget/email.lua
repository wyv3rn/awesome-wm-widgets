local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

local path_to_icons = "/usr/share/icons/Arc/actions/22/"

local email_widget = {}

function email_widget:new(args)
    self = {}
    self.icon = wibox.widget.imagebox()
    self.icon:set_image(path_to_icons .. "/mail-mark-new.png")
    self.count = wibox.widget.textbox("")

    if args.font then
        self.count:set_font(args.font)
    end

    local count_cmd = args.count_cmd or [[echo "-"]]
    local read_cmd = args.read_cmd or [[echo "Command for reading not specified"]]

    watch(
    count_cmd, args.interval or 20,
    function(widget, stdout, stderr, exitreason, exitcode)
        local unread_emails_num = tonumber(stdout) or 0
        if (unread_emails_num > 0) then
            self.icon:set_image(path_to_icons .. "/mail-mark-unread.png")
            self.count:set_text(stdout)
        elseif (unread_emails_num == 0) then
            self.icon:set_image(path_to_icons .. "/mail-message-new.png")
            self.count:set_text("")
        end
    end
    )

    function show_emails()
        awful.spawn.easy_async(read_cmd,
        function(stdout, stderr, reason, exit_code)
            naughty.notify{
                text = stdout,
                title = "Unread Emails",
                timeout = 5, hover_timeout = 0.5,
                width = args.display_width or 400,
            }
        end
        )
    end

    self.icon:connect_signal("mouse::enter", function() show_emails() end)

    return self
end

return setmetatable(email_widget, {
    __call = email_widget.new,
})
