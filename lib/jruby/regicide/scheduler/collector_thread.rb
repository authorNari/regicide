module Regicide
  class Scheduler
    class CollectorThread < Thread
      attr_reader :context

      def initialize(scheduler, context)
        @context = context
        @scheduler = scheduler
        self.abort_on_exception = true
        super do
          begin
            @scheduler.add_active_collector(self)
            context.run
            @scheduler.delete_active_collector(self)
          end
        end
      end
    end
  end
end
