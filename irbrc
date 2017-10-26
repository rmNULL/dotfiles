require 'irb/completion'
require 'irbtools'

IRB.conf[:AUTO_INDENT] = true
# I like the original "simple prompt" better but its hard to distinguish it from
# ri's interactive prompt.
IRB.conf.dig(:PROMPT, :SIMPLE)[:PROMPT_I] = "%n> "
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:SAVE_HISTORY] = 2048
