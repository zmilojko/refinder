@refinder_carpart_demo_module.controller 'HomeController', [
  '$scope', '$http', ($scope, $http) ->
    $scope.criteria =
      text: ""
      selected_categories: ["Jarrupalat", "foo", "bar", "baz", "qux"]
    $scope.unselect_category = (index) ->
        $scope.criteria.selected_categories.splice(index, 1)
    $scope.handle_search_criteria_change = ->
      console.log "Text change, now it is #{$scope.criteria.text}"
      $http.post('/search.json', $scope.criteria)
      .then (server_response) ->
        $scope.result_info = server_response.data
        console.log(server_response.data)
    $scope.handle_search_button_click = ->
      console.log "Search button clicked"
    $scope.input_focus_changed = ($event) ->
      $scope.showtips = not $scope.criteria.criteria_text

    # to be fetched from the server
    $scope.result_info = {}
]
