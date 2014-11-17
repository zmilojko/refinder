@refinder_carpart_demo_module.controller 'HomeController', [
  '$scope', '$http', ($scope, $http) ->
    $scope.criteria =
      text: null
    $scope.handle_search_criteria_change = ->
      console.log "Text change, now it is #{$scope.criteria.text}"
      $http.post('/search.json', $scope.criteria)
      .then (server_response) ->
        console.log server_response.data
    $scope.handle_search_button_click = ->
      console.log "Search button clicked"
]