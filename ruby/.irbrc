# frozen_string_literal: true

# credits to @woodruffw
def requireish(lib)
  require lib
  yield if block_given?
rescue LoadError => e
  warn "#{e.class}: #{e}"
end

requireish 'irb/completion'
requireish 'irbtools'
requireish 'elftools'
requireish 'looksee'

IRB.conf[:AUTO_INDENT] = true
# I like the original "simple prompt" better but its hard to distinguish it from
# ri's interactive prompt.
IRB.conf.dig(:PROMPT, :SIMPLE)[:PROMPT_I] = '%n> '
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:SAVE_HISTORY] = 2048
