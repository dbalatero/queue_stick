# Pending removal after http://github.com/dbalatero/sinatra/commit/5fb4d1904dbbd79dfe3f06c9868c0603baf4dd80 is in Sinatra core, and released

$TRAP_INT_OCCURRED = false
module Kernel
  alias :old_trap :trap

  def trap(*args, &block)
    if args[0] == :INT || args[0] == 'INT'
      $TRAP_INT_OCCURRED = true
    end

    old_trap(*args, &block)
  end
end

