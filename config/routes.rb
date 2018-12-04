Sirneim::Application.routes.draw do
  resources :combinaciones

  resources :cal_estudiante_tipo_planes

  resources :tipo_plan

  root :to => 'cal_inicio#index'
  match ':controller(/:action(/:id(.:format)))'
end
