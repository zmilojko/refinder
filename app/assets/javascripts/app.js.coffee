#= require angular
#= require angular-route
#= require angular-resource
#= require angular-rails-templates
#= require_tree ./templates
#= require_self
#= require_tree ./includes
#= require_tree ./directives
#= require_tree ./services
#= require_tree ./controllers
#= require angular-ui-bootstrap

@refinder_carpart_demo_module = angular.module('refinder-carpart-demo', [
  'ngRoute', 
  'ngResource', 
  'templates',
  'ui.bootstrap',
  'LocalStorageModule',
  ])

@refinder_carpart_demo_module.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    #when('/url', {
    #  templateUrl: 'template.html',
    #}).
    otherwise({
      templateUrl: 'home.html',
    }) 
])

@refinder_carpart_demo_module.config(['localStorageServiceProvider', (localStorageServiceProvider) ->
  localStorageServiceProvider
    .setPrefix('refinder-carpart-demo')
    .setStorageType('localStorage')
    .setStorageCookie(0, '<path>')
    .setNotify(true, true)
])
