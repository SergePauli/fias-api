Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope "/fias", controller: "v1/fias_api" do
    get "/", action: "index"
  end
end
