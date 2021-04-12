module Manifester
  class Engine < ::Rails::Engine
    isolate_namespace Manifester

    initializer "manifester.helper" do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.helper Manifester::ApplicationHelper
      end

      ActiveSupport.on_load :action_view do
        include Manifester::ApplicationHelper
      end
    end
  end
end
