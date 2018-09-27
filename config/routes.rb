Sirneim::Application.routes.draw do
  root :to => 'cal_inicio#index'
  match ':controller(/:action(/:id(.:format)))'
end
